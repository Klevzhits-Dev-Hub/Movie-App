//
//  MovieDetailPresenter.swift
//  Movie App
//
//  Created by Artem Kriukov on 06.04.2025.
//

import Foundation

protocol MovieDetailPresenterProtocol: AnyObject {
    var view: MovieDetailViewProtocol? { get set }
    func viewDidLoad()
    func watchNowButtonTapped()
    func getActorsCount() -> Int
    func getActor(at index: Int) -> Person?
}

protocol MovieDetailViewProtocol: AnyObject {
    func displayMovieDetails(_ movie: Movie)
    func reloadActorsCollection()
}

final class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    weak var view: MovieDetailViewProtocol?
    private let networkManager: NetworkManager
    private let imageLoader: ImageLoader
    private let movieId: Int
    private var movie: Movie?
    
    init(
        networkManager: NetworkManager = .shared,
        imageLoader: ImageLoader = .shared,
        movieId: Int
    ) {
        self.networkManager = networkManager
        self.imageLoader = imageLoader
        self.movieId = movieId
    }
    
    func viewDidLoad() {
        loadMovieDetails()
    }
    
    func watchNowButtonTapped() {
        print("Watch now tapped for movie: \(movie?.name ?? "")")
    }
    
    func getActorsCount() -> Int {
        return movie?.persons?.count ?? 0
    }
    
    func getActor(at index: Int) -> Person? {
        guard let persons = movie?.persons, index < persons.count else {
            return nil
        }
        return persons[index]
    }
    
    private func loadMovieDetails() {
        print("Loading details for movie ID: \(movieId)")
        networkManager.fetchMovieDetails(id: movieId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movie):
                    self?.movie = movie
                    self?.view?.displayMovieDetails(movie)
                    self?.view?.reloadActorsCollection()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
