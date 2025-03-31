//
//  SceneDelegate.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 30.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.overrideUserInterfaceStyle = .light
        
        let tabBarController = UITabBarController()
        
        let searchViewController = ViewController()
        let recentWatchViewController = ViewController()
        let homeViewController = MovieDetailViewController() // Что это за экран??)
        let wishlistViewController = ViewController()
        let settingsViewController = ViewController()
        
        tabBarController.viewControllers = [
            searchViewController,
            recentWatchViewController,
            homeViewController,
            wishlistViewController,
            settingsViewController
        ]
        
        tabBarController.selectedViewController = homeViewController
        
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
        
        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.tabBar.tintColor = .purple
        
        tabBarController.tabBar.unselectedItemTintColor = .gray
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

}

