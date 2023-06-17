//
//  PopularCell.swift
//  MovieApplication
//
//  Created by thanpd on 16/05/2023.
//

import UIKit

class PopularCell: UITableViewCell {

    @IBOutlet weak var tbPopularMovie: UITableView!
    @IBOutlet weak var heightContraintsTBPopularMovie: NSLayoutConstraint!
    
    private let popularSize = 5
    
    var popularListTV: TV?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let MovieNib = UINib(nibName: "MovieCell", bundle: nil)
        tbPopularMovie.register(MovieNib, forCellReuseIdentifier: "MovieCell")
        
        heightContraintsTBPopularMovie.constant = CGFloat(Constant.heightARowOfMovieCell) * CGFloat(popularSize)
        
        getDataPopularMovie()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func btnViewMoreClicked(_ sender: Any) {
        tbPopularMovie.reloadData()
    }

    private func getDataPopularMovie() {
        if let urlPopular = URL(string: Constant.urlTVApi +  "popular" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(TV.self, from: jsonData)
                  self.updatePopularTable(movie: movie!)
               }
           }.resume()
        }
    }
    
    private func updatePopularTable(movie: TV) {
        DispatchQueue.main.async {
            self.popularListTV = movie
            self.tbPopularMovie.dataSource = self
            self.tbPopularMovie.delegate = self
            self.tbPopularMovie.reloadData()
        }
    }
    
}

extension PopularCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.lbMovieName.text = popularListTV?.results[indexPath.row].originalName
        cell.lbMovieRating.text = String(describing: popularListTV!.results[indexPath.row].voteAverage)
        cell.lbDateTime.text = popularListTV?.results[indexPath.row].firstAirDate
        cell.imgRatingStars.setRatingStar(rate: (popularListTV?.results[indexPath.row].voteAverage)!)
        URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (popularListTV?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.imgMovie.image = image
                }
            }
        }.resume()
        return cell
    }
    
}
