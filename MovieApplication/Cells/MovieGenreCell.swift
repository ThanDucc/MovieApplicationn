//
//  MoviegGenreCell.swift
//  MovieApplication
//
//  Created by thanpd on 27/04/2023.
//

import UIKit

class MovieGenreCell: UICollectionViewCell {

    @IBOutlet weak var imgGenre: UIImageView!
    @IBOutlet weak var lbGenre: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        view.layer.cornerRadius = 4
    }

}
