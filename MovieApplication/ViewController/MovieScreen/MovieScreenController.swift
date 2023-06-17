//
//  MovieScreenController.swift
//  MovieApplication
//
//  Created by thanpd on 26/04/2023.
//

import UIKit
import DropDown

class MovieScreenController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tfSearchMovie: UITextField!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var tbLayout: UITableView!
    
    let listNibNameCell: [String] = ["TrendingMovieCell", "NowPlayingCell", "ListMovieCell", "ListMovieCell", "ListMovieCell"]

    var listCollectionViewFromCells = [UICollectionView]()
    
    var genreList: Genre?
    var playingListMovie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        firstView.layer.cornerRadius = 15
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchMovie.attributedPlaceholder = NSAttributedString(string: "Search movies", attributes: attributes)
        
        tbLayout.delegate = self
        tbLayout.dataSource = self
        
        for nibName in listNibNameCell {
            tbLayout.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
        }

        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        imgAccount.image = UIImage(named: "person_fill")?.withTintColor(.label)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:)))
        imgAccount.addGestureRecognizer(tapGesture)
        imgAccount.isUserInteractionEnabled = true
        
        getDataGenre()
        getDataNowPlaying()
        
    }
    
    @objc private func showManagerAccountDialog(_ sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "AccountSettingView", bundle: nil)
        let accSettingVC = storyboard.instantiateViewController(withIdentifier: "AccountSettingView") as! AccountSettingView
        accSettingVC.modalPresentationStyle = .overFullScreen
        accSettingVC.modalTransitionStyle = .crossDissolve
        self.parent!.present(accSettingVC, animated: true)
    }
    
    @objc func notificationThemeChange() {
        firstView.setBackground(tabbar: self.tabBarController!)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnViewMoreClicked(_ sender: Any) {
//        tbPopularMovie.reloadData()
    }

    private func getDataGenre() {
        if let url = URL(string: Constant.urlGenre + "movie" + "/list" + Constant.apiKey) {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let jsonData = data {
                  let genre = try? JSONDecoder().decode(Genre.self, from: jsonData)
                  self.updateGenreCollection(genre: genre!)
               }
           }.resume()
        }
    }

    private func getDataNowPlaying() {
        if let urlPopular = URL(string: Constant.urlMovieAPI +  "now_playing" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)
                  self.updatePlayingMovieCollection(movie: movie!)
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

    private func updatePlayingMovieCollection(movie: Movie) {
        DispatchQueue.main.async {
            self.playingListMovie = movie
            self.tbLayout.reloadData()
        }
    }
}

extension MovieScreenController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case listCollectionViewFromCells[0]:
            return genreList?.genres.count ?? 0
        case listCollectionViewFromCells[1]:
            return playingListMovie?.results.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case listCollectionViewFromCells[0]:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGenreCell", for: indexPath) as! MovieGenreCell
            cell.lbGenre.text = genreList?.genres[indexPath.row].name
            cell.imgGenre.image = UIImage(named: "hq")
            return cell
        case listCollectionViewFromCells[1]:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayingMovieCell", for: indexPath) as! PlayingMovieCell
            cell.lbMovieRating.text = String(describing: playingListMovie!.results[indexPath.row].voteAverage)
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (playingListMovie?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgPlayingMovie.image = image
                    }
                }
            }.resume()
            cell.lbMovieName.text = playingListMovie?.results[indexPath.row].title ?? ""
            cell.lbDate.text = playingListMovie?.results[indexPath.row].releaseDate ?? ""
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case listCollectionViewFromCells[0]:
            return CGSize(width: UIScreen.main.bounds.width/2.3 + 32, height: 40)
        case listCollectionViewFromCells[1]:
            return CGSize(width: UIScreen.main.bounds.width/2.95 + 32, height: 205)
        default:
            return CGSize(width: 0, height: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case listCollectionViewFromCells[0]:
            return -20
        case listCollectionViewFromCells[1]:
            return -19.5
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case listCollectionViewFromCells[0]:
            return 12
        default:
            return 0
        }
    }

}

extension MovieScreenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listNibNameCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tbLayout:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! TrendingMovieCell
                cell.clMovieGenre.delegate = self
                cell.clMovieGenre.dataSource = self
                cell.clMovieGenre.reloadData()
                listCollectionViewFromCells.append(cell.clMovieGenre)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! NowPlayingCell
                cell.clPlayingMovie.delegate = self
                cell.clPlayingMovie.dataSource = self
                cell.clPlayingMovie.reloadData()
                listCollectionViewFromCells.append(cell.clPlayingMovie)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! ListMovieCell
                cell.type = "Popular"
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! ListMovieCell
                cell.type = "Top Rated"
                return cell
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: listNibNameCell[indexPath.row]) as! ListMovieCell
                cell.type = "Upcoming"
                return cell
            default:
                return UITableViewCell()
            }
        default:
            return UITableViewCell()
        }
    }
}
