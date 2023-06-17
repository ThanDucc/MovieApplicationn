//
//  PopularMovieCell.swift
//  MovieApplication
//
//  Created by thanpd on 28/04/2023.
//

import UIKit
import DropDown

class MovieCell: UITableViewCell {

    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbMovieRating: UILabel!
    @IBOutlet weak var lbDateTime: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet var imgRatingStars: [UIImageView]!
    @IBOutlet weak var btnOptions: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgMovie.layer.cornerRadius = 8
        btnOptions.setBackgroundImage(UIImage(named: "more_vert")?.withTintColor(.label), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnOptionsClicked(_ sender: Any) {
        let dropDown = DropDown().initProperties(view: btnOptions, tabbar: MainScreenController.tabbar!)
        dropDown.show()
    }
    
}

