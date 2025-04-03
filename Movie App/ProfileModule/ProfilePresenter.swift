//
//  ProfilePresenter.swift
//  Movie App
//
//  Created by Екатерина Орлова on 01.04.2025.
//

import UIKit

protocol ProfilePresenterProtocol {
    func changeAvatarButtonTapped()
    func saveButtonPressed()
}

final class ProfilePresenter{
    // MARK: - Properties
    private weak var view: ProfileViewProtocol?
    
    // MARK: - Initialization
    init() {}
    
    func setupView(_ view: ProfileViewProtocol) {
        self.view = view
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func changeAvatarButtonTapped() {
        
    }
    
    func saveButtonPressed() {
        
    }   
    
}
