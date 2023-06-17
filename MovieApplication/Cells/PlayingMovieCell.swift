//
//  PlayingMovieCell.swift
//  MovieApplication
//
//  Created by thanpd on 28/04/2023.
//

import UIKit
import DropDown

class PlayingMovieCell: UICollectionViewCell {

    @IBOutlet weak var imgPlayingMovie: UIImageView!
    @IBOutlet weak var lbMovieRating: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgPlayingMovie.layer.cornerRadius = 8
        view.layer.cornerRadius = 15
        
        btnOptions.setBackgroundImage(UIImage(named: "more_horiz")?.withTintColor(.label), for: .normal)
    }

    @IBAction func btnOptionsClicked(_ sender: Any) {
        let dropDown = DropDown().initProperties(view: btnOptions, tabbar: MainScreenController.tabbar!)
        dropDown.show()
    }
}
