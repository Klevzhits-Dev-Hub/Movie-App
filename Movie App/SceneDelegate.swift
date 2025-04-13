//
//  SceneDelegate.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 30.03.2025.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        let navVC = UINavigationController()
        
        let searchViewController = UINavigationController(rootViewController: SearchFactory.makeSearchViewModel())
        let recentWatchViewController = UINavigationController(rootViewController: RecentWatchFactory.makeRecentWatchViewModel())
        let homeViewController = UINavigationController(rootViewController: HomeFactory.makeHomeViewModel())
        let wishlistViewController = WishlistViewController()
        let settingsViewController = UINavigationController(rootViewController: SettingFactory.makeSettingViewModel(navigationController: navVC))
        
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
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            // поменять на экран онбординга
            self.goToController(with: LoginViewController())
        } else {
            // на главный экран(поменять на таббар)
            self.goToController(with: HomeFactory.makeHomeViewModel())
        }
    }
    
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.25) {
                self?.window?.layer.opacity = 0
                
            } completion: { [weak self] _ in
                
                let nav = UINavigationController(rootViewController: viewController)
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
        
    }
}
