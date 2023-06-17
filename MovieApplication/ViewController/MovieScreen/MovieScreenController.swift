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
    @IBOutlet weak var sgmTrendingFilter: UISegmentedControl!
    @IBOutlet weak var tfSearchMovie: UITextField!
    @IBOutlet weak var clMovieGenre: UICollectionView!
    @IBOutlet weak var clPlayingMovie: UICollectionView!
    @IBOutlet weak var imgTrendingMovie: UIImageView!
    @IBOutlet weak var tbPopularMovie: UITableView!
    @IBOutlet weak var tbTopRated: UITableView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var heightContraintsTBPopularMovie: NSLayoutConstraint!
    @IBOutlet weak var heightConstraintsTBTopRatedMovie: NSLayoutConstraint!
    @IBOutlet weak var imgAccount: UIImageView!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var btnMoreMoviePlaying: UIButton!
    
    var popularListMovie: Movie?
    var topRatedListMovie: Movie?
    var playingListMovie: Movie?
    var genreList: Genre?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        firstView.layer.cornerRadius = 15
        
        sgmTrendingFilter.setBackgroundImage(UIImage(color: .systemBackground), for: .normal, barMetrics: .default)

        let normalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13, weight: .light)]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13, weight: .medium)]
        sgmTrendingFilter.setTitleTextAttributes(normalAttributes, for: .normal)
        sgmTrendingFilter.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        imgTrendingMovie.layer.cornerRadius = 8
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .light)
        ]
        tfSearchMovie.attributedPlaceholder = NSAttributedString(string: "Search movies", attributes: attributes)
        firstView.setBackground(tabbar: self.tabBarController!)
        
        let MovieGenreNib = UINib(nibName: "MovieGenreCell", bundle: nil)
        clMovieGenre.register(MovieGenreNib, forCellWithReuseIdentifier: "MovieGenreCell")

        let AiringTodayMovieNib = UINib(nibName: "PlayingMovieCell", bundle: nil)
        clPlayingMovie.register(AiringTodayMovieNib, forCellWithReuseIdentifier: "PlayingMovieCell")
        
        let MovieNib = UINib(nibName: "MovieCell", bundle: nil)
        tbPopularMovie.register(MovieNib, forCellReuseIdentifier: "MovieCell")
        
        tbTopRated.register(MovieNib, forCellReuseIdentifier: "MovieCell")
        
        btnOptions.setBackgroundImage(UIImage(named: "more_horiz")?.withTintColor(.label), for: .normal)
        btnMenu.setBackgroundImage(UIImage(named: "menu")?.withTintColor(.label), for: .normal)
        imgAccount.image = UIImage(named: "person_fill")?.withTintColor(.label)
        
        btnMoreMoviePlaying.setBackgroundImage(UIImage(named: "arrow_forward")?.withTintColor(.label), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationThemeChange), name: Notification.Name("Theme Changed"), object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showManagerAccountDialog(_:)))
        imgAccount.addGestureRecognizer(tapGesture)
        imgAccount.isUserInteractionEnabled = true
        
        getDataPopular()
        getDataTopRated()
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
        if self.tabBarController?.overrideUserInterfaceStyle == .dark {
            self.sgmTrendingFilter.setBackgroundImage(UIImage(color: .black), for: .normal, barMetrics: .default)
        } else if self.tabBarController?.overrideUserInterfaceStyle == .light {
            self.sgmTrendingFilter.setBackgroundImage(UIImage(color: .white), for: .normal, barMetrics: .default)
        }
        
        firstView.setBackground(tabbar: self.tabBarController!)
    }
    
    @IBAction func btnMenuClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnViewMoreClicked(_ sender: Any) {
        tbPopularMovie.reloadData()
    }
    
    @IBAction func btnOptionsClicked(_ sender: Any) {
        let dropDown = DropDown().initProperties(view: btnOptions, tabbar: MainScreenController.tabbar!)
        dropDown.show()
    }
    
    private func getDataPopular() {
        if let urlPopular = URL(string: Constant.urlMovieAPI +  "popular" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)
                  self.updatePopularTable(movie: movie!)
               }
           }.resume()
        }
    }
    
    private func getDataTopRated() {
        if let urlTopRated = URL(string: Constant.urlMovieAPI +  "top_rated" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlTopRated) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)
                  self.updateTopRatedTable(movie: movie!)
               }
           }.resume()
        }
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
    
    private func updatePopularTable(movie: Movie) {
        DispatchQueue.main.async {
            self.popularListMovie = movie
            self.tbPopularMovie.delegate = self
            self.tbPopularMovie.dataSource = self
            self.tbPopularMovie.reloadData()
        }
    }
    
    private func updateTopRatedTable(movie: Movie) {
        DispatchQueue.main.async {
            self.topRatedListMovie = movie
            self.tbTopRated.delegate = self
            self.tbTopRated.dataSource = self
            self.tbTopRated.reloadData()
        }
    }
    
    private func updateGenreCollection(genre: Genre) {
        DispatchQueue.main.async {
            self.genreList = genre
            self.clMovieGenre.delegate = self
            self.clMovieGenre.dataSource = self
            self.clMovieGenre.reloadData()
        }
    }
    
    private func updatePlayingMovieCollection(movie: Movie) {
        DispatchQueue.main.async {
            self.playingListMovie = movie
            self.clPlayingMovie.delegate = self
            self.clPlayingMovie.dataSource = self
            self.clPlayingMovie.reloadData()
        }
    }
    
}

extension MovieScreenController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case clMovieGenre:
            return genreList?.genres.count ?? 0
        case clPlayingMovie:
            return playingListMovie?.results.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case clMovieGenre:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGenreCell", for: indexPath) as! MovieGenreCell
            cell.lbGenre.text = genreList?.genres[indexPath.row].name
            cell.imgGenre.image = UIImage(named: "hq")
            return cell
        case clPlayingMovie:
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
        case clMovieGenre:
            return CGSize(width: UIScreen.main.bounds.width/2.3 + 32, height: 40)
        case clPlayingMovie:
            return CGSize(width: UIScreen.main.bounds.width/2.95 + 32, height: 205)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clMovieGenre:
            return -20
        case clPlayingMovie:
            return -19.5
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case clMovieGenre:
            return 12
        case clPlayingMovie:
            return 0
        default:
            return 0
        }
    }
    
}

extension MovieScreenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tbPopularMovie:
            return 5
        case tbTopRated:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tbPopularMovie:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.lbMovieName.text = popularListMovie?.results[indexPath.row].originalTitle
            cell.lbMovieRating.text = String(describing: popularListMovie!.results[indexPath.row].voteAverage)
            cell.lbDateTime.text = popularListMovie?.results[indexPath.row].releaseDate
            cell.imgRatingStars.setRatingStar(rate: (popularListMovie?.results[indexPath.row].voteAverage)!)
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (popularListMovie?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgMovie.image = image
                    }
                }
            }.resume()
            return cell
        case tbTopRated:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
            cell.lbMovieName.text = topRatedListMovie?.results[indexPath.row].originalTitle
            cell.lbMovieRating.text = String(describing: topRatedListMovie!.results[indexPath.row].voteAverage)
            cell.lbDateTime.text = topRatedListMovie?.results[indexPath.row].releaseDate
            cell.imgRatingStars.setRatingStar(rate: (topRatedListMovie?.results[indexPath.row].voteAverage)!)
            URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (topRatedListMovie?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell.imgMovie.image = image
                    }
                }
            }.resume()
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let myCell = cell as? MovieCell {
            let height = myCell.contentView.systemLayoutSizeFitting(CGSize(width: tableView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            heightContraintsTBPopularMovie.constant = height * CGFloat(5)
            heightConstraintsTBTopRatedMovie.constant = height * CGFloat(5)
        }
    }

    
    
}
