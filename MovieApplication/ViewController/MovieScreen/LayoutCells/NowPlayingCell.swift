//
//  NowPlayingCell.swift
//  Movie Application
//
//  Created by ThanDuc on 25/05/2023.
//

import UIKit

class NowPlayingCell: UITableViewCell {

    @IBOutlet weak var btnMoreList: UIButton!
    @IBOutlet weak var clPlayingMovie: UICollectionView!
    @IBOutlet weak var heightConstraintClNowPlaying: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnMoreList.setBackgroundImage(UIImage(named: "arrow_forward")?.withTintColor(.label), for: .normal)
        let PlayingMovieNib = UINib(nibName: "PlayingMovieCell", bundle: nil)
        clPlayingMovie.register(PlayingMovieNib, forCellWithReuseIdentifier: "PlayingMovieCell")
        
        heightConstraintClNowPlaying.constant = 205
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
