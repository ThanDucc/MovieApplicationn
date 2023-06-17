//
//  PopularCell.swift
//  MovieApplication
//
//  Created by thanpd on 16/05/2023.
//

import UIKit

class ListTVCell: UITableViewCell {

    @IBOutlet weak var tbTV: UITableView!
    @IBOutlet weak var heightContraintsTBPopularMovie: NSLayoutConstraint!
    @IBOutlet weak var lbTitle: UILabel!
    
    var type: String = "" {
        didSet {
            lbTitle.text = type
            if type == "Popular" {
                getDataTV(type: "popular")
            } else if type == "Top Rated" {
                getDataTV(type: "top_rated")
            } else {
                getDataTV(type: "on_the_air")
            }
        }
    }
    
    private let size = 5
    
    var listTV: TV?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let MovieNib = UINib(nibName: "MovieCell", bundle: nil)
        tbTV.register(MovieNib, forCellReuseIdentifier: "MovieCell")
        
        heightContraintsTBPopularMovie.constant = CGFloat(Constant.heightARowOfMovieCell) * CGFloat(size)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func btnViewMoreClicked(_ sender: Any) {
        tbTV.reloadData()
    }

    private func getDataTV(type: String) {
        if let urlPopular = URL(string: Constant.urlTVApi +  type + Constant.apiKey) {
           URLSession.shared.dataTask(with: urlPopular) { data, response, error in
              if let jsonData = data {
                  let tv = try? JSONDecoder().decode(TV.self, from: jsonData)
                  self.updateTV(tv: tv!)
               }
           }.resume()
        }
    }
    
    private func updateTV(tv: TV) {
        DispatchQueue.main.async {
            self.listTV = tv
            self.tbTV.dataSource = self
            self.tbTV.delegate = self
            self.tbTV.reloadData()
        }
    }
    
}

extension ListTVCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return size
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.lbMovieName.text = listTV?.results[indexPath.row].name
        cell.lbMovieRating.text = String(describing: listTV!.results[indexPath.row].voteAverage)
        cell.lbDateTime.text = listTV?.results[indexPath.row].firstAirDate
        cell.imgRatingStars.setRatingStar(rate: (listTV?.results[indexPath.row].voteAverage)!)
        URLSession.shared.dataTask(with: URL(string: "https://image.tmdb.org/t/p/w200" + (listTV?.results[indexPath.row].posterPath)!)!) { (data, response, error) in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.imgMovie.image = image
                }
            }
        }.resume()
        return cell
    }
    
}
