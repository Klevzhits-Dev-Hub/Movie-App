//
//  SettingPresenter.swift
//  Movie App
//
//  Created by Екатерина Орлова on 31.03.2025.
//


import UIKit

protocol SettingPresenterProtocol {
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
    
}
