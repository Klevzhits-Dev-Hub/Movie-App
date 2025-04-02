//
//  ProfileFactory.swift
//  Movie App
//
//  Created by Екатерина Орлова on 01.04.2025.
//

import UIKit

final class ProfileFactory {
 static func makeSettingViewModel() -> UIViewController {
        let presenter = ProfilePresenter()
        let viewController = ProfileViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
