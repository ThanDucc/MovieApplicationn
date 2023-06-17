//
//  PopularMovieCell.swift
//  Movie Application
//
//  Created by ThanDuc on 25/05/2023.
//

import UIKit

class ListMovieCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tbMovie: UITableView!
    @IBOutlet weak var heightContraintsTBPopularMovie: NSLayoutConstraint!
    
    var type: String = "" {
        didSet {
            lbTitle.text = type
            if type == "Popular" {
                getDataMovie(type: "popular")
            } else if type == "Top Rated" {
                getDataMovie(type: "top_rated")
            } else {
                getDataMovie(type: "upcoming")
            }
        }
    }
    
    private let size = 5
    
    var listMovie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let MovieNib = UINib(nibName: "MovieCell", bundle: nil)
        tbMovie.register(MovieNib, forCellReuseIdentifier: "MovieCell")
        
        heightContraintsTBPopularMovie.constant = CGFloat(Constant.heightARowOfMovieCell) * CGFloat(size)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func btnViewMoreClicked(_ sender: Any) {
        tbMovie.reloadData()
    }

    private func getDataMovie(type: String) {
        if let urlPopular = URL(string: Constant.urlMovieAPI + type + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)
                  self.updateMovie(movie: movie!)
               }
           }.resume()
        }
    }
    private func updateMovie(movie: Movie) {
        DispatchQueue.main.async {
            self.listMovie = movie
            self.tbMovie.delegate = self
            self.tbMovie.dataSource = self
            self.tbMovie.reloadData()
        }
    }
    
}

extension ListMovieCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.lbMovieName.text = listMovie?.results[indexPath.row].title
        cell.lbMovieRating.text = String(describing: listMovie!.results[indexPath.row].voteAverage)
        cell.lbDateTime.text = listMovie?.results[indexPath.row].releaseDate
        cell.imgRatingStars.setRatingStar(rate: (listMovie?.results[indexPath.row].voteAverage)!)
        URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (listMovie?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.imgMovie.image = image
                }
            }
        }.resume()
        return cell
    }
    
}
