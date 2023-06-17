//
//  People.swift
//  Movie Application
//
//  Created by ThanDuc on 15/06/2023.
//

import Foundation

// MARK: - People
class People: Codable {
    let results: [ResultPeople]

    init(results: [ResultPeople]) {
        self.results = results
    }
}

// MARK: - Result
class ResultPeople: Codable {
    let id: Int
    let name: String
    let profilePath: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }

    init(id: Int, name: String, profilePath: String) {
        self.id = id
        self.name = name
        self.profilePath = profilePath
    }
}
