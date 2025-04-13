//
//  WishlistViewPresenter.swift
//  Movie App
//
//  Created by Анна on 11.04.2025.
//

import Foundation

protocol WishlistViewPresenterProtocol: AnyObject {
  var view: WishlistViewProtocol? { get set }
  func getNumberOfItems() -> Int
  func getWishlistMovies(at index: Int) -> WishlistMovie
  func viewDidLoad()
  func viewWillAppear()
  func didSelectMovie(at index: Int)
}

final class WishlistViewPresenter: WishlistViewPresenterProtocol {
  weak var view: WishlistViewProtocol?
  private let networkManager: NetworkManager
  private let imageLoader: ImageLoader
  private var movies: [WishlistMovie] = []
  private let coreDataManager: CoreDataManager
  
  init(
      networkManager: NetworkManager = .shared,
      imageLoader: ImageLoader = .shared,
      coreDataManager: CoreDataManager = .shared
  ) {
      self.networkManager = networkManager
      self.imageLoader = imageLoader
    self.coreDataManager = coreDataManager
  }
  
  func viewDidLoad() {
      loadMovies()
  }
  
  func viewWillAppear() {
    loadMovies()
  }
  
  private func loadMovies() {
    movies = coreDataManager.getLikedMovies().map { movie in
      WishlistMovie(movie: Movie(id: Int(movie.id), name: movie.title, alternativeName: movie.title, type: nil, description: nil, shortDescription: nil, rating: nil, votes: nil, poster: Poster(url: movie.posterURL, previewUrl: nil), movieLength: Int(movie.duration), videos: nil, genres: [Genre(name: movie.genre ?? "")], persons: nil, premiere: nil),
                    releaseDate: movie.releaseDate, isLike: movie.isLiked)
    }
    view?.reloadCollectionView()
  }
  
  func getNumberOfItems() -> Int {
    return movies.count
  }
  
  func getWishlistMovies(at index: Int) -> WishlistMovie {
    return movies[index]
  }
  
  func didSelectMovie(at index: Int) {
    let movie = movies[index].movie.id
    view?.navigateToMovieDetail(movieId: movie)
   }
}
