//
//  Rider.swift
//  MotoGP21-MVVM
//
//  Created by Dima Yarmolchuk on 24.02.2021.
//

import Foundation

// MARK: - Riders

struct Riders<T: Codable>: Codable {
    let riders: [T]
}

// MARK: - Rider

struct Rider: Codable {
    let name: String
    let team: String
    let bike: String
    let number: String
    let photo: String
    
    var poster: URL? { URL(string: photo) }
    
    let information: Information
}

// MARK: - Information

struct Information: Codable {
    let placeOfBirth: String
    let dateOfBirth: String
    let weight: String
    let height: String
    let info: String
}
