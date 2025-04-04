//
//  ProfilePresenter.swift
//  Movie App
//
//  Created by Екатерина Орлова on 01.04.2025.
//

import UIKit

protocol ProfilePresenterProtocol {
    func changeAvatarButtonTapped(option: EditAvatarOption)
    func saveButtonPressed()
    func backButtonPressed()
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
    func changeAvatarButtonTapped(option: EditAvatarOption) {
        switch option {
        case .photoLibrary:
            // Логика для выбора изображения из фотоальбома
            print("Photo Library Selected")
        case .camera:
            // Логика для выбора изображения с камеры
            print("Camera Selected")
        }
    }
        func saveButtonPressed() {
            
        }
        func backButtonPressed() {
        }
    }

