//
//  ViewController.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 30.03.2025.
//

import UIKit

// MARK: - Пример использования api

class ViewController: UIViewController {
    private var movies: [Movie] = []
    let movieId: Int = 535341
    let currentPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
//        NetworkManager.shared.fetchMovieDetails(id: movieId) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let movie):
//                    print(movie)
//                case .failure(let error):
//                    print("Error: ")
//                    print(error)
//                }
//            }
//        }
//        NetworkManager.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let response):
//                    self?.movies.append(contentsOf: response.docs)
//                case .failure(let error):
//                    print("Error: \(error)")
//                }
//                print(self?.movies ?? [])
//            }
//        }
        NetworkManager.shared.fetchMoviesByGenre(genre: "драма") { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        NetworkManager.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                print(genres)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }


}

