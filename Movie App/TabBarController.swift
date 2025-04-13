//
//  TabBarController.swift
//  Movie App
//
//  Created by Trae AI on 10.04.2025.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Setup
    
    private func setupTabBar() {
        let searchViewController = UINavigationController(rootViewController: SearchFactory.makeSearchViewModel())
        let recentWatchViewController = UINavigationController(rootViewController: RecentWatchFactory.makeRecentWatchViewModel())
        let homeViewController = UINavigationController(rootViewController: HomeFactory.makeHomeViewModel())
        let wishlistViewController = UINavigationController(rootViewController: WishlistViewController())
        let settingsViewController = UINavigationController(rootViewController: SettingFactory.makeSettingViewModel(navigationController: nil))
        
        viewControllers = [
            searchViewController,
            recentWatchViewController,
            homeViewController,
            wishlistViewController,
            settingsViewController
        ]
        
        selectedViewController = homeViewController
        
        searchViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "magnifyingglass"),
            tag: 0)
        
        recentWatchViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "play.circle"),
            tag: 1)
        
        homeViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "house.circle.fill"),
            tag: 2)
        
        wishlistViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "heart"),
            tag: 3)
        
        settingsViewController.tabBarItem = UITabBarItem(
            title: "",
            image: .init(systemName: "person"),
            tag: 4)
        
        tabBar.isTranslucent = false
        tabBar.tintColor = .purple
        tabBar.unselectedItemTintColor = .gray
    }
}

// MARK: - Factory

final class TabBarFactory {
    static func makeTabBarController() -> UITabBarController {
        return TabBarController()
    }
}