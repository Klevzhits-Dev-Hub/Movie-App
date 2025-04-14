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
        
        if !OnboardingManager.shared.hasSeenOnboarding() {
            showOnboarding()
        } else {
            checkAuthentication()
        }
    }
    
    // Публичный метод для проверки аутентификации и перехода на соответствующий экран
    func checkAuthentication() {
        if Auth.auth().currentUser != nil {
            setupMainInterface()
        } else {
            let loginVC = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginVC)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }
    
    private func showOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        window?.rootViewController = onboardingVC
        window?.makeKeyAndVisible()
    }
    
    private func setupMainInterface() {
        let tabBarController = TabBarFactory.makeTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
