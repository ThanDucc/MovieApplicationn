//
//  AiringTodayCell.swift
//  MovieApplication
//
//  Created by thanpd on 16/05/2023.
//

import UIKit

class AiringTodayCell: UITableViewCell {

    @IBOutlet weak var clAiringTodayMovie: UICollectionView!
    @IBOutlet weak var heightConstraintClAiringToday: NSLayoutConstraint!
    @IBOutlet weak var btnMoreMovieAiring: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let AiringTodayMovieNib = UINib(nibName: "AiringTodayMovieCell", bundle: nil)
        clAiringTodayMovie.register(AiringTodayMovieNib, forCellWithReuseIdentifier: "AiringTodayMovieCell")
        
        heightConstraintClAiringToday.constant = Constant.heightConstraintCollectionAiringToday
        
        btnMoreMovieAiring.setBackgroundImage(UIImage(named: "arrow_forward")?.withTintColor(.label), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
