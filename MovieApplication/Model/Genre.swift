//
//  Genre.swift
//  Movie Application
//
//  Created by ThanDuc on 12/06/2023.
//

import Foundation

// MARK: - Genre
class Genre: Codable {
    let genres: [GenreElement]

    init(genres: [GenreElement]) {
        self.genres = genres
    }
}

// MARK: - GenreElement
class GenreElement: Codable {
    let id: Int
    let name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
