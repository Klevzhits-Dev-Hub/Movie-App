//
//  SettingPresenter.swift
//  Movie App
//
//  Created by Екатерина Орлова on 31.03.2025.
//


import UIKit

protocol SettingPresenterProtocol {
    func nextButtonTapped()
    func changePasswordTapped()
    func forgotPasswordTapped()
    func darkModeButtonTapped(isOn: Bool)
    func logOutButtonTaped()
}

final class SettingPresenter{
    // MARK: - Properties
    private weak var view: SettingViewProtocol?
    private weak var navigationController: UINavigationController?
        
      
    // MARK: - Initialization
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func setupView(_ view: SettingViewProtocol) {
        self.view = view
    }
}

// MARK: - SettingPresenterProtocol
extension SettingPresenter: SettingPresenterProtocol {
    func nextButtonTapped() {
        view?.navigateToProfile()
    }
    
    func changePasswordTapped() {
        view?.navigateToRessetVC()
    }
    
    func forgotPasswordTapped() {
        view?.navigateToRessetVC()
    }
    
    func darkModeButtonTapped(isOn: Bool) {
        view?.darkModeTapped(isOn: isOn)
    }
    
    func logOutButtonTaped() {
        view?.logOut()
    }
}
