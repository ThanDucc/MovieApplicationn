//
//  PeopleImages.swift
//  Movie Application
//
//  Created by ThanDuc on 16/06/2023.
//

import Foundation

// MARK: - PeopleImages
class PeopleImages: Codable {
    let id: Int
    let profiles: [Profile]

    init(id: Int, profiles: [Profile]) {
        self.id = id
        self.profiles = profiles
    }
}

// MARK: - Profile
class Profile: Codable {
    let height: Int
    let filePath: String
    let width: Int

    enum CodingKeys: String, CodingKey {
        case height
        case filePath = "file_path"
        case width
    }

    init(height: Int, filePath: String, width: Int) {
        self.height = height
        self.filePath = filePath
        self.width = width
    }
}
