//
//  TelevisionScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 04/05/2023.
//

import UIKit

class TelevisionScreenController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tfSearchMovie: UITextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var tbLayout: UITableView!
    @IBOutlet weak var imgAccount: UIImageView!
    
    let listNibNameCell: [String] = ["TrendingTelevisionCell", "AiringTodayCell", "PopularCell", "TopRateCell"]
    var listCollectionViewFromCells = [UICollectionView]()
    
    var genreList: Genre?
    var airingTodayListMovie: TV?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        firstView.layer.cornerRadius = 15
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchMovie.attributedPlaceholder = NSAttributedString(string: "Search televisions", attributes: attributes)
        
        tbLayout.delegate = self
        tbLayout.dataSource = self
        for nibName in listNibNameCell {
            tbLayout.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        }
        
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        
        imgAccount.image = UIImage(named: "person_fill")?.withTintColor(.label)
        imgAccount.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:)))
        imgAccount.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        getDataGenre()
        getDataAiringTodayMovie()
    }
    
    @objc func notificationThemeChange() {
        firstView.setBackground(tabbar: self.tabBarController!)
    }
    
    @objc private func showManagerAccountDialog(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "AccountSettingView", bundle: nil)
        let accSettingVC = storyboard.instantiateViewController(withIdentifier: "AccountSettingView") as! AccountSettingView
        accSettingVC.modalPresentationStyle = .overFullScreen
        accSettingVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(accSettingVC, animated: true)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        
    }

    @IBAction func tfEnterringToSearch(_ sender: Any) {
//        tbLayout.isHidden = true
    }
    
    private func getDataGenre() {
        if let url = URL(string: Constant.urlGenre + "tv" + "/list" + Constant.apiKey) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let jsonData = data {
                  let genre = try? JSONDecoder().decode(Genre.self, from: jsonData)
                  self.updateGenreCollection(genre: genre!)
               }
           }.resume()
        }
    }
    
    private func updateGenreCollection(genre: Genre) {
        DispatchQueue.main.async {
            self.genreList = genre
            self.tbLayout.reloadData()
        }
    }
    
    private func getDataAiringTodayMovie() {
        if let urlPopular = URL(string: Constant.urlTVApi +  "airing_today" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(TV.self, from: jsonData)
                  self.updateAiringTodayCollection(movie: movie!)
               }
           }.resume()
        }
    }
    
    private func updateAiringTodayCollection(movie: TV) {
        DispatchQueue.main.async {
            self.airingTodayListMovie = movie
            self.tbLayout.reloadData()
        }
    }
    
}

extension TelevisionScreenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tbLayout:
            return listNibNameCell.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tbLayout:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! TrendingTelevisionCell
                cell.clMovieGenre.delegate = self
                cell.clMovieGenre.dataSource = self
                cell.clMovieGenre.reloadData()
                listCollectionViewFromCells.append(cell.clMovieGenre)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! AiringTodayCell
                cell.clAiringTodayMovie.delegate = self
                cell.clAiringTodayMovie.dataSource = self
                cell.clAiringTodayMovie.reloadData()
                listCollectionViewFromCells.append(cell.clAiringTodayMovie)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! PopularCell
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! TopRateCell
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
        
    }

}

extension TelevisionScreenController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == listCollectionViewFromCells[0] {
            return genreList?.genres.count ?? 0
        } else {
            return airingTodayListMovie?.results.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == listCollectionViewFromCells[0] {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGenreCell", for: indexPath) as! MovieGenreCell
            cell.lbGenre.text = genreList?.genres[indexPath.row].name
            cell.imgGenre.image = UIImage(named: "hq")
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AiringTodayMovieCell", for: indexPath) as! AiringTodayMovieCell
            let posterPath = (airingTodayListMovie?.results[indexPath.row].posterPath)!
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + posterPath)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgCoverPhoto.image = image
                    }
                }
            }.resume()
            let backdropPath = airingTodayListMovie?.results[indexPath.row].backdropPath ?? posterPath
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + backdropPath)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgAiringTodayMovie.image = image
                    }
                }
            }.resume()
            cell.lbMovieName.text = airingTodayListMovie?.results[indexPath.row].name
            cell.lbDate.text = airingTodayListMovie?.results[indexPath.row].firstAirDate ?? "No information"
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == listCollectionViewFromCells[0] {
            return CGSize(width: UIScreen.main.bounds.width/2.3 + 32, height: 40)
        } else {
            return CGSize(width: UIScreen.main.bounds.width/1.7 + 32, height: Constant.heightConstraintCollectionAiringToday - 1)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listCollectionViewFromCells[0] {
            return -20
        } else {
            return -16
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == listCollectionViewFromCells[0] {
            return 12
        } else {
            return 0
        }
    }

}
