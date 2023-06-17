//
//  TopRateCell.swift
//  MovieApplication
//
//  Created by thanpd on 16/05/2023.
//

import UIKit

class TopRateCell: UITableViewCell {

    @IBOutlet weak var tbTopRated: UITableView!
    @IBOutlet weak var heightConstraintsTBTopRatedMovie: NSLayoutConstraint!
    
    private let popularSize = 5
    var rate = 5.9
    
    var topRatedListTV: TV?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let MovieNib = UINib(nibName: "MovieCell", bundle: nil)
        tbTopRated.register(MovieNib, forCellReuseIdentifier: "MovieCell")
        
        heightConstraintsTBTopRatedMovie.constant = CGFloat(Constant.heightARowOfMovieCell) * CGFloat(popularSize)
        
        getDataTopRatedMovie()
    }
    
    private func getDataTopRatedMovie() {
        if let urlPopular = URL(string: Constant.urlTVApi +  "top_rated" + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let movie = try? JSONDecoder().decode(TV.self, from: jsonData)
                  self.updateTopRatedTable(movie: movie!)
               }
           }.resume()
        }
    }
    
    private func updateTopRatedTable(movie: TV) {
        DispatchQueue.main.async {
            self.topRatedListTV = movie
            self.tbTopRated.dataSource = self
            self.tbTopRated.delegate = self
            self.tbTopRated.reloadData()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TopRateCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.lbMovieName.text = topRatedListTV?.results[indexPath.row].originalName
        cell.lbMovieRating.text = String(describing: topRatedListTV!.results[indexPath.row].voteAverage)
        cell.lbDateTime.text = topRatedListTV?.results[indexPath.row].firstAirDate
        cell.imgRatingStars.setRatingStar(rate: (topRatedListTV?.results[indexPath.row].voteAverage)!)
        URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (topRatedListTV?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.imgMovie.image = image
                }
            }
        }.resume()
        return cell
    }
    
}
