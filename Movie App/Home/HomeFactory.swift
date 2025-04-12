//
//  HomeFactory.swift
//  Movie App
//
//  Created by Dmitry Volkov on 07/04/2025.
//

import UIKit

final class HomeFactory {
 static func makeHomeViewModel() -> UIViewController {
        let presenter = HomePresenter()
        let viewController = HomeViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
