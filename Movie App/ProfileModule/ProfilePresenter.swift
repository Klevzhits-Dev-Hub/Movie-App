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
    func genderButtonTapped(type: GenderCustomButton.ButtonType)
    func getSelectedGender() -> GenderCustomButton.ButtonType?
}

final class ProfilePresenter{
    // MARK: - Properties
    private weak var view: ProfileViewProtocol?
    private var selectedGender: GenderCustomButton.ButtonType?
    
    // MARK: - Initialization
    init() {}
    
    func setupView(_ view: ProfileViewProtocol) {
        self.view = view
    }
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func genderButtonTapped(type: GenderCustomButton.ButtonType) {
            selectedGender = type
            print("Gender Button Tapped: \(type)")
            view?.updateGenderSelection(type: type)
        }
        
        func getSelectedGender() -> GenderCustomButton.ButtonType? {
            return selectedGender
        }
    
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
            view?.saveTapped()
        }
        func backButtonPressed() {
            view?.backButtonTapped()
        }
    }

