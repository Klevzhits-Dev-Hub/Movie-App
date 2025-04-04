//
//  SettingPresenter.swift
//  Movie App
//
//  Created by Екатерина Орлова on 31.03.2025.
//


import UIKit

protocol SettingPresenterProtocol {
    func nextButtonTapped()
    func changePasswordButtonTapped()
    func forgotPasswordButtonTapped()
    func darkModeButtonTapped()
}

final class SettingPresenter{
    // MARK: - Properties
    private weak var view: SettingViewProtocol?
    
    // MARK: - Initialization
    init() {}
    
    func setupView(_ view: SettingViewProtocol) {
        self.view = view
    }
}

// MARK: - SettingPresenterProtocol
extension SettingPresenter: SettingPresenterProtocol {
    func nextButtonTapped() {
        view?.navigateToProfile()
    }
    
    func changePasswordButtonTapped() {
        
    }
    
    func forgotPasswordButtonTapped() {
        
    }
    
    func darkModeButtonTapped() {
        
    }
    
    
}
