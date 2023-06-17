//
//  LibraryMovieCell.swift
//  MovieApplication
//
//  Created by thanpd on 11/05/2023.
//

import UIKit

class LibraryMovieCell: UITableViewCell {

    @IBOutlet weak var btnRemoveMovie: UIButton!
    @IBOutlet weak var imgMovie: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgMovie.layer.cornerRadius = 8
        btnRemoveMovie.setBackgroundImage(UIImage(named: "delete")?.withTintColor(.label), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
