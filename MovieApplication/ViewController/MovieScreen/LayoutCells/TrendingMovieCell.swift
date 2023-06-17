//
//  TrendingMovieCell.swift
//  Movie Application
//
//  Created by ThanDuc on 25/05/2023.
//

import UIKit
import DropDown

class TrendingMovieCell: UITableViewCell {

    @IBOutlet weak var sgmTrendingFilter: UISegmentedControl!
    @IBOutlet weak var imgTrendingMovie: UIImageView!
    @IBOutlet weak var clMovieGenre: UICollectionView!
    @IBOutlet weak var btnOptions: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        sgmTrendingFilter.setBackgroundImage(UIImage(color: .white), for: .normal, barMetrics: .default)

        let normalAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13, weight: .light)]
        let selectedAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13, weight: .medium)]
        sgmTrendingFilter.setTitleTextAttributes(normalAttributes, for: .normal)
        sgmTrendingFilter.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        imgTrendingMovie.layer.cornerRadius = 8
        
        let MovieGenreNib = UINib(nibName: "MovieGenreCell", bundle: nil)
        clMovieGenre.register(MovieGenreNib, forCellWithReuseIdentifier: "MovieGenreCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnOptionsClicked(_ sender: Any) {
        let dropDown = DropDown().initProperties(view: btnOptions, tabbar: MainScreenController.tabbar!)
        dropDown.show()
    }
    
}
