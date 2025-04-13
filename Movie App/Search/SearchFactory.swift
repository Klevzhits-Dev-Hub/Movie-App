//
//  SearchFactory.swift
//  Movie App
//
//  Created by Анна on 12.04.2025.
//

import UIKit

final class SearchFactory {
 static func makeSearchViewModel() -> UIViewController {
   let presenter = SearchPresenter()
   let viewController = SearchViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
