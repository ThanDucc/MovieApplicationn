//
//  PeopleCell.swift
//  MovieApplication
//
//  Created by thanpd on 08/05/2023.
//

import UIKit

class PeopleCell: UICollectionViewCell {

    @IBOutlet weak var imgPeopleAvatar: UIImageView!
    @IBOutlet weak var viewState: UIView!
    @IBOutlet weak var btnPeopleState: UIButton!
    @IBOutlet weak var lbPersonName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewState.layer.cornerRadius = viewState.frame.size.width/2
        viewState.layer.borderColor = UIColor.lightGray.cgColor
        viewState.layer.borderWidth = 1

        imgPeopleAvatar.layer.cornerRadius = imgPeopleAvatar.frame.size.width/2
        imgPeopleAvatar.clipsToBounds = true
        btnPeopleState.setBackgroundImage(UIImage(named: "add")?.withTintColor(.label), for: .normal)
    }

}
