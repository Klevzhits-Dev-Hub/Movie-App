//
//  SearchPresenter.swift
//  Movie App
//
//  Created by Анна on 12.04.2025.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func viewDidLoad()
    func categoryTapped(category: String)
    func filterButtonTapped()
    func searchTextFieldShouldReturn()
    func numberOfCategories() -> Int
    func didSelectMovie(at indexPath: IndexPath)
    func numberOfMovies() -> Int
    func didSelectCategory(at indexPath: IndexPath)
    func searchMovies(query: String)
    var selectedCategoryIndex: IndexPath? { get }
    
}

final class SearchPresenter: SearchPresenterProtocol {
    private weak var view: SearchViewProtocol?
    private var categories: [String] = []
    private var selectedCategory: String = "All"
    private var displayedMovies = [Movie]()
    private(set) var selectedCategoryIndex: IndexPath?
    private var currentSearchTask: URLSessionDataTask?
    private var searchTimer: Timer?
    
    init() {
    }
    
    func setupView(_ view: SearchViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchCategories()
        fetchAllMovies()
    }
    
    func searchMovies(query: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false
        ) { [weak self] _ in
            self?.performSearch(query: query)
        }
    }
    
    private func performSearch(query: String) {
        currentSearchTask?.cancel()
        
        NetworkManager.shared.fetchSearchMovies(query: query) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.displayedMovies = response.docs
                    self?.view?.showMovies(response.docs)
                }
            case .failure(let error as NetworkManager.NetworkError) where error == .noData:
                DispatchQueue.main.async {
                    self?.displayedMovies = []
                    self?.view?.showMovies([])
                }
            case .failure(let error):
                print("Search error: \(error.localizedDescription)")
            }
        }
    }
    
    func didSelectCategory(at indexPath: IndexPath) {
        guard indexPath.row < categories.count else { return }
        selectedCategoryIndex = indexPath
        let category = categories[indexPath.row]
        categoryTapped(category: category)
    }
    
    func filterButtonTapped() {
        view?.showFilterSheet()
    }
    
    func searchTextFieldShouldReturn() {
        view?.dismissKeyboardSearch()
    }
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func numberOfMovies() -> Int {
        return displayedMovies.count
    }
    
    func fetchAllMovies() {
        _ = "all"
        
        NetworkManager.shared.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let response):
                self?.displayedMovies = response.docs
                self?.view?.showMovies(response.docs)
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
    
    func categoryTapped(category: String) {
        selectedCategory = category
        
        if category == "All" {
            fetchAllMovies()
        } else {
            let key = category.lowercased()
            
            NetworkManager.shared.fetchMoviesByGenre(genre: key) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    let filteredMovies = response.docs.filter { !($0.name?.isEmpty ?? true) }
                    
                    DispatchQueue.main.async {
                        self.displayedMovies = filteredMovies 
                        self.view?.showMovies(filteredMovies)
                    }
                case .failure(let error):
                    print("Error fetching genres: \(error)")
                }
            }
        }
    }
    
    func fetchCategories() {
        NetworkManager.shared.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                if let self {
                    self.categories = ["All"] + genres.map { $0.name.capitalized }
                    let allIndex = IndexPath(item: 0, section: 0)
                    self.didSelectCategory(at: allIndex)
                    self.view?.showCategories(self.categories)
                    
                }
            case .failure(let error):
                print("Error fetching genres: \(error)")
            }
        }
    }
    
    func didSelectMovie(at indexPath: IndexPath) {
        let id = displayedMovies[indexPath.row].id
        view?.navigateToMovieDetail(movieId: id)
    }
}
