//
//  AiringToday.swift
//  Movie Application
//
//  Created by ThanDuc on 15/06/2023.
//

import Foundation

// MARK: - Genre
class TV: Codable {
    let page: Int
    let results: [Results]

    enum CodingKeys: String, CodingKey {
        case page, results
    }

    init(page: Int, results: [Results]) {
        self.page = page
        self.results = results
    }
}

// MARK: - Result
class Results: Codable {
    let backdropPath: String?
    let firstAirDate: String
    let genreIDS: [Int]
    let id: Int
    let name: String
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case genreIDS = "genre_ids"
        case id, name
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    init(backdropPath: String?, firstAirDate: String, genreIDS: [Int], id: Int, name: String, originCountry: [String], originalLanguage: String, originalName: String, overview: String, popularity: Double, posterPath: String, voteAverage: Double, voteCount: Int) {
        self.backdropPath = backdropPath
        self.firstAirDate = firstAirDate
        self.genreIDS = genreIDS
        self.id = id
        self.name = name
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalName = originalName
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}
