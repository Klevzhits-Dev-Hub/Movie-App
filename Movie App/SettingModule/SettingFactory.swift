//
//  SettingFactory.swift
//  Movie App
//
//  Created by Екатерина Орлова on 31.03.2025.
//

import UIKit

final class SettingFactory {
 static func makeSettingViewModel() -> UIViewController {
        let presenter = SettingPresenter()
        let viewController = SettingViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
