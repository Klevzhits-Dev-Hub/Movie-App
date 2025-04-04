//
//  MovieModel.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 02.04.2025.
//
import Foundation

struct MovieResponse: Codable {
    let docs: [Movie]
    let total: Int
    let limit: Int
    let page: Int
    let pages: Int
}

struct Movie: Codable {
    let id: Int
    let name: String?
    let alternativeName: String?
    let type: String?
    let description: String?
    let shortDescription: String?
    let rating: Rating?
    let votes: Votes?
    let poster: Poster?
    let movieLength: Int?
    let videos: VideoResponse?
    let genres: [Genre]?
    let persons: [Person]?
    let premiere: Premiere?
    
    var durationString: String {
        guard let length = movieLength else { return "N/A" }
        return "\(length) min"
    }
}

struct Rating: Codable {
    let kp: Double?
}

struct Votes: Codable {
    let kp: Int?
}

struct Poster: Codable {
    let url: String?
    let previewUrl: String?
}

struct VideoResponse: Codable {
    let trailers: [Trailer]?
}

struct Trailer: Codable {
    let url: String?
    let name: String?
    let site: String?
    let size: Int?
    let type: String?
}

struct Genre: Codable {
    let name: String
}

struct Person: Codable {
    let id: Int
    let photo: String?
    let name: String?
    let enName: String?
    let description: String?
    let enProfession: String?
}

struct Premiere: Codable {
    let world: String?
}
