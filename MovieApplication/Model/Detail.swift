//
//  Detail.swift
//  Movie Application
//
//  Created by ThanDuc on 15/06/2023.
//

import Foundation

// MARK: - Detail
class Detail: Codable {
    let alsoKnownAs: [String]?
    let biography, birthday: String?
    let id: Int
    let knownForDepartment: String?
    let placeOfBirth: String?

    enum CodingKeys: String, CodingKey {
        case alsoKnownAs = "also_known_as"
        case biography, birthday, id
        case knownForDepartment = "known_for_department"
        case placeOfBirth = "place_of_birth"
    }

    init(alsoKnownAs: [String], biography: String, birthday: String, id: Int, imdbID: String, knownForDepartment: String, placeOfBirth: String) {
        self.alsoKnownAs = alsoKnownAs
        self.biography = biography
        self.birthday = birthday
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.placeOfBirth = placeOfBirth
    }
}
