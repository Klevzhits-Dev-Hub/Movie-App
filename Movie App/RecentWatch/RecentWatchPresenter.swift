//
//  RecentWatchPresenter.swift
//  Movie App
//
//  Created by Анна on 03.04.2025.
//

import UIKit

protocol RecentWatchPresenterProtocol {
    
}

final class RecentWatchPresenter {
    // MARK: - Properties
    private weak var view: RecentWatchViewProtocol?
    
    // MARK: - Initialization
    init() {}
    
    func setupView(_ view: RecentWatchViewProtocol) {
        self.view = view
    }
}

// MARK: - RecentWatchPresenterProtocol
extension RecentWatchPresenter: RecentWatchPresenterProtocol {
    
}
