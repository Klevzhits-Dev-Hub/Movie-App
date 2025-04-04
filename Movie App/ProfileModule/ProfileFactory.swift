//
//  ProfileFactory.swift
//  Movie App
//
//  Created by Екатерина Орлова on 01.04.2025.
//

import UIKit

final class ProfileFactory {
 static func makeProfileModule() -> UIViewController {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
