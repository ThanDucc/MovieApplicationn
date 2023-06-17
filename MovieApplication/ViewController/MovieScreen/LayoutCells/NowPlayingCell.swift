//
//  NowPlayingCell.swift
//  Movie Application
//
//  Created by ThanDuc on 25/05/2023.
//

import UIKit

class NowPlayingCell: UITableViewCell {

    @IBOutlet weak var btnMoreList: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnMoreList.setBackgroundImage(UIImage(named: "arrow_forward")?.withTintColor(.label), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
