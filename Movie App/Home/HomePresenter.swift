//
//  HomePresenter.swift
//  Movie App
//
//  Created by Dmitry Volkov on 04/04/2025.
//
import UIKit

protocol HomePresenterProtocol: AnyObject {
    func fetchCategories()
    func fetchAllMovies()
    func categoryTapped(category: String)
    func getSelectedCategory() -> String?
    func movieTapped(selectedMovie: Movie)
    func highlightCurrentCategory()
    func toggleFavourite(movie: Movie)
    func seeAllTapped()
}

final class HomePresenter {
    private weak var view: HomeViewProtocol?
    private var selectedCategory: String?
    private var moviesCache: [String: [Movie]] = [:]

    init() {
    }
    
    func setupView(_ view: HomeViewProtocol) {
        self.view = view
    }
}

// MARK: - SettingPresenterProtocol
extension HomePresenter: HomePresenterProtocol {
    
    func fetchCategories() {
        var fetchedCategories: [String] = []
        NetworkManager.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                fetchedCategories = ["All"] + genres.map { $0.name.capitalized }
                self?.view?.showCategories(fetchedCategories)
            case .failure(let error):
                print("Error fetching genres: \(error)")
            }
        }
    }
    
    
    func fetchAllMovies() {
        let key = "all"
        
        if let cached = moviesCache[key] {
            self.view?.showBoxOfficeMovies(cached)
            return
        }
        
        NetworkManager.shared.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let response):
                self?.moviesCache[key] = response.docs
                self?.view?.showMovies(response.docs)
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func categoryTapped(category: String) {
        selectedCategory = category
        let key = category.lowercased()

        if let cached = moviesCache[key] {
            view?.showBoxOfficeMovies(cached)
            return
        }

        switch category {
        case "All":
            fetchAllMovies()
            
        default:
            NetworkManager.shared.fetchMoviesByGenre(genre: key) { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    let filteredMovies = response.docs.filter { !($0.name?.isEmpty ?? true) }
                    self.moviesCache[key] = filteredMovies
                    self.view?.showBoxOfficeMovies(filteredMovies)
                case .failure(let error):
                    print("Error fetching genres: \(error)")
                }
            }
        }
    }
    
    func highlightCurrentCategory() {
        guard let category = selectedCategory else { return }
        view?.highlightSelectedCategory(category)
    }
    
    func getSelectedCategory() -> String? {
        return selectedCategory
    }
    
    func movieTapped(selectedMovie: Movie) {
        view?.navigateToMovieDetail(movieId: selectedMovie.id)
    }
    
    func toggleFavourite(movie: Movie) {
        CoreDataManager.shared.toggleLike(movie: movie)
        print("Toggle Favotites")
    }
    
    func seeAllTapped() {
        print("See all tapped")
    }
}





