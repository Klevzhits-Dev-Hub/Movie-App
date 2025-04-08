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
    func movieTapped(selectedMovie: Movie)
    func toggleFavourite()
    func seeAllTapped()
}

final class HomePresenter {
    private weak var view: HomeViewProtocol?

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
        NetworkManager.shared.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let response):
                self?.view?.showMovies(response.docs)
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func categoryTapped(category: String) {
        print("<DEBUGGGG")
        NetworkManager.shared.fetchMoviesByGenre(genre: category.lowercased()) { result in
            switch result {
            case .success(let response):
                let filteredMovies = response.docs.filter { $0.name?.isEmpty == false }
                self.view?.showMovies(filteredMovies)
            case .failure(let error):
                print("Error fetching genres: \(error)")
            }
        }
    }
    
    func movieTapped(selectedMovie: Movie) {
        print("Tapped movie: \(selectedMovie.name)")
    }
    
    func toggleFavourite() {
        print("Toggle Favotites")
    }
    
    func seeAllTapped() {
        print("See all tapped")
    }
}





