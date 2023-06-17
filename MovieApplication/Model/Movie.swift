//
//  Movie.swift
//  Movie Application
//
//  Created by ThanDuc on 11/06/2023.
//

import Foundation

// MARK: - Popular
class Movie: Codable {
    let page: Int
    let results: [Result]

    enum CodingKeys: String, CodingKey {
        case page, results
    }

    init(page: Int, results: [Result]) {
        self.page = page
        self.results = results
    }
}

// MARK: - Result
class Result: Codable {
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalTitle, overview: String
    let posterPath, releaseDate, title: String
    let voteAverage: Double

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }

    init(backdropPath: String, genreIDS: [Int], id: Int, originalTitle: String, overview: String, posterPath: String, releaseDate: String, title: String, voteAverage: Double) {
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.voteAverage = voteAverage
    }
}

