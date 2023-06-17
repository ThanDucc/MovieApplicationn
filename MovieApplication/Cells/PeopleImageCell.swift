//
//  PeopleImageCell.swift
//  MovieApplication
//
//  Created by thanpd on 10/05/2023.
//

import UIKit

class PeopleImageCell: UICollectionViewCell {

    @IBOutlet weak var imgPeople: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgPeople.layer.cornerRadius = 10
    }

}
