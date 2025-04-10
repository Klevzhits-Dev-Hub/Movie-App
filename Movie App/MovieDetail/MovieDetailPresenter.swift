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
    func getTrailerURL() -> URL?
    func toggleLike()
    func isMovieLiked() -> Bool
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
    
    func getTrailerURL() -> URL? {
        guard let trailers = movie?.videos?.trailers else { return nil }
        for trailer in trailers {
            if let site = trailer.site?.lowercased(),
               site == "youtube",
               let urlString = trailer.url,
               let url = URL(string: urlString) {
                return url
            }
        }
        return nil
    }
    
    func toggleLike() {
        guard let movie = movie else { return }
        CoreDataManager.shared.toggleLike(movie: movie)
        view?.updateLikeButton()
    }
    
    func isMovieLiked() -> Bool {
        guard let movie = movie else { return false }
        return CoreDataManager.shared.getLikedMovies().contains { $0.id == Int32(movie.id) }
    }
}
