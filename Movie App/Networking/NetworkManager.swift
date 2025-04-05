//
//  NetworkManager.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 02.04.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "1E0WW96-HB8M6SK-NB8MQ7C-DE2TBXD"
    private let baseURL = "https://api.kinopoisk.dev/v1.4/"
    
    private init() {}
    
    func fetchPopularMovies(page: Int = 1, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        let urlString = "\(baseURL)movie?page=\(page)&limit=20&type=movie&lists=popular-films"
        performRequest(urlString: urlString, completion: completion)
    }
    
    func fetchMoviesByGenre(
            genre: String,
            page: Int = 1,
            limit: Int = 20,
            completion: @escaping (Result<MovieResponse, Error>) -> Void
    ) {
        var urlComponents = URLComponents(string: "\(baseURL)movie")
        
        let queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "genres.name", value: genre),
            URLQueryItem(name: "typeNumber", value: "1") // только фильмы
        ]
        
        urlComponents?.queryItems = queryItems
        
        guard let urlString = urlComponents?.url?.absoluteString else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        performRequest(urlString: urlString, completion: completion)
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let urlString = "\(baseURL)movie/\(id)"
        performRequest(urlString: urlString, completion: completion)
    }
    
    private func performRequest<T: Codable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-API-KEY")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    completion(.failure(NetworkError.noInternetConnection))
                } else {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.unknown))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                break
            case 401:
                completion(.failure(NetworkError.unauthorized))
                return
            case 403:
                completion(.failure(NetworkError.unauthorized))
                return
            case 500...599:
                completion(.failure(NetworkError.serverError))
                return
            default:
                completion(.failure(NetworkError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }.resume()
    }
    
    enum NetworkError: Error, LocalizedError {
        case invalidURL
        case noData
        case noInternetConnection
        case httpError(statusCode: Int)
        case decodingError
        case serverError
        case unauthorized
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL provided."
            case .noData:
                return "No data received from the server."
            case .noInternetConnection:
                return "No internet connection. Please check your network settings."
            case .httpError(let statusCode):
                return "HTTP Error: Request failed with status code \(statusCode)."
            case .decodingError:
                return "Failed to decode server response."
            case .serverError:
                return "Server is currently unavailable. Please try again later."
            case .unauthorized:
                return "Authentication failed. Check your API key."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
}
