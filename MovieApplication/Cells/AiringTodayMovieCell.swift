//
//  AiringTodayMovieCell.swift
//  MovieApplication
//
//  Created by thanpd on 05/05/2023.
//

import UIKit
import DropDown

class AiringTodayMovieCell: UICollectionViewCell {

    @IBOutlet weak var imgAiringTodayMovie: UIImageView!
    @IBOutlet weak var imgCoverPhoto: UIImageView!
    @IBOutlet weak var lbMovieName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var btnOptions: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgAiringTodayMovie.layer.cornerRadius = 8
        imgCoverPhoto.layer.cornerRadius = 8
        btnOptions.setBackgroundImage(UIImage(named: "more_horiz")?.withTintColor(.label), for: .normal)
    }
    
    @IBAction func btnOptionsClicked(_ sender: Any) {
        let dropDown = DropDown().initProperties(view: btnOptions, tabbar: MainScreenController.tabbar!)
        dropDown.show()
    }

}
