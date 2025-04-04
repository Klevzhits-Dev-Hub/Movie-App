//
//  RecentWatchFactory.swift
//  Movie App
//
//  Created by Анна on 03.04.2025.
//

import UIKit

final class RecentWatchFactory {
    static func makeRecentWatchViewModel() -> UIViewController {
        let presenter = RecentWatchPresenter()
        let viewController = RecentWatchViewController(presenter: presenter)
        presenter.setupView(viewController)
        return viewController
    }
}
