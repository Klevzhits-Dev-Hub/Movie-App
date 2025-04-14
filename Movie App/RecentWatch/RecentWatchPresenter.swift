//
//  RecentWatchPresenter.swift
//  Movie App
//
//  Created by Анна on 03.04.2025.
//

import UIKit

protocol RecentWatchPresenterProtocol {
  var view: RecentWatchViewProtocol? { get set }
  var selectedCategoryIndex: IndexPath? { get }
  func getNumberOfItems() -> Int
  func getRecentMovies(at index: Int) -> WishlistMovie
  func viewDidLoad()
  func viewWillAppear()
  func didSelectMovie(at index: IndexPath)
  func didSelectCategory(at indexPath: IndexPath)
  func categoryTapped(category: String)
}

final class RecentWatchPresenter: RecentWatchPresenterProtocol {
    // MARK: - Properties
  weak var view: RecentWatchViewProtocol?
  private let networkManager: NetworkManager
  private let imageLoader: ImageLoader
  private var movies: [WishlistMovie] = []
  private var filteredMovies: [WishlistMovie] = []
  private let coreDataManager: CoreDataManager
  private var categories: [String] = []
  private(set) var selectedCategoryIndex: IndexPath?
  private var selectedCategory: String = "All"
    
  init(
      networkManager: NetworkManager = .shared,
      imageLoader: ImageLoader = .shared,
      coreDataManager: CoreDataManager = .shared
  
  ) {
      self.networkManager = networkManager
      self.imageLoader = imageLoader
    self.coreDataManager = coreDataManager
  }
    
  func setupView(_ view: RecentWatchViewProtocol) {
      self.view = view
  }
  
  func viewDidLoad() {
      loadMovies()
    view?.showCategories(categories)
  }
  
  func viewWillAppear() {
    loadMovies()
  }
  
  func didSelectCategory(at indexPath: IndexPath) {
    guard indexPath.row < categories.count else { return }
        selectedCategoryIndex = indexPath
    let category = categories[indexPath.row]
        categoryTapped(category: category)
  }
  
  func categoryTapped(category: String) {
    selectedCategory = category

    if category == "All" {
      filteredMovies = movies
    } else {
      print(955)
      filteredMovies = movies.filter { movie in
        if let genres = movie.movie.genres {
          return genres.contains(where: { $0.name.lowercased() == category.lowercased() })
        }
        
        return false
      }
    }
    
    view?.showMovies(filteredMovies.map({ m in
      m.movie
    }))
}
  
  private func loadMovies() {
    movies = coreDataManager.getWatchedMovies().map { movie in
      WishlistMovie(movie: Movie(id: Int(movie.id), name: movie.title, alternativeName: movie.title, type: nil, description: nil, shortDescription: nil, rating: nil, votes: nil, poster: Poster(url: movie.posterURL, previewUrl: nil), movieLength: Int(movie.duration), videos: nil, genres: [Genre(name: movie.genre ?? "")], persons: nil, premiere: nil),
                    releaseDate: movie.releaseDate, isLike: movie.isLiked)
    }
    
    categories = ["All"] + Array(Set(
        movies.compactMap { movie in
            movie.movie.genres?.map { $0.name.capitalized }
        }
        .flatMap { $0 }
    )).sorted()

    self.filteredMovies = movies
      self.selectedCategoryIndex = IndexPath(row: 0, section: 0)
      view?.showCategories(categories)
      view?.showMovies(filteredMovies.map({ m in
      m.movie
    }))
  }
  
  func getNumberOfItems() -> Int {
    return filteredMovies.count
  }
  
  func getRecentMovies(at index: Int) -> WishlistMovie {
    return filteredMovies[index]
  }
  
  func didSelectMovie(at index: IndexPath) {
    let id = filteredMovies[index.row].movie.id
    view?.navigateToMovieDetail(movieId: id)
   }
}
