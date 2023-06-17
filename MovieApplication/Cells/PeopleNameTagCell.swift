//
//  PeopleNameTag.swift
//  MovieApplication
//
//  Created by thanpd on 08/05/2023.
//

import UIKit

class PeopleNameTagCell: UICollectionViewCell {
    
    @IBOutlet weak var viewCell: UIView!
    @IBOutlet weak var lbNameTag: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCell.layer.cornerRadius = 8
        viewCell.layer.borderWidth = 1
        viewCell.layer.borderColor = UIColor.lightGray.cgColor
    }

}
