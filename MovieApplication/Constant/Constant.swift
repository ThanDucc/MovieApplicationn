//
//  Constant.swift
//  MovieApplication
//
//  Created by thanpd on 12/05/2023.
//

import Foundation
import UIKit

class Constant {
    public static let heightConstraintCollectionAiringToday = UIScreen.main.bounds.width/1.7/1.7 + 80
    public static let heightConstraintCollectionPeopleImage = UIScreen.main.bounds.width/1.2/1.43
    public static let heightARowOfMovieCell = 96
    public static let urlMovieAPI = "https://api.themoviedb.org/3/movie/"
    public static let apiKey = "?api_key=df611a77e6551bff31f9f50fc1855181"
    public static let urlGenre = "https://api.themoviedb.org/3/genre/"
    public static let urlTVApi = "https://api.themoviedb.org/3/tv/"
    public static let urlPeople = "https://api.themoviedb.org/3/person/"
}
