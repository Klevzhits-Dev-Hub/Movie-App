//
//  HomePresenter.swift
//  Movie App
//
//  Created by Dmitry Volkov on 04/04/2025.
//

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
}

class HomePresenter: HomePresenterProtocol {
    weak var view: HomeViewProtocol?

    init(view: HomeViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        fetchData()
    }
    
    func fetchData() {
        NetworkManager.shared.fetchPopularMovies { [weak self] result in
            switch result {
            case .success(let movieResponse):
                self?.view?.showMovies(movieResponse.docs)
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
    }
}
