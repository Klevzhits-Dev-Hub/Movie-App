//
//  OnboardingManager.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 30.03.2025.
//

import Foundation

class OnboardingManager {
    
    // MARK: - Properties
    static let shared = OnboardingManager()
    
    private let userDefaults = UserDefaults.standard
    private let onboardingKey = "hasSeenOnboarding"
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Public Methods
    func hasSeenOnboarding() -> Bool {
        return userDefaults.bool(forKey: onboardingKey)
    }
    
    func setOnboardingComplete() {
        userDefaults.set(true, forKey: onboardingKey)
    }
    
    func resetOnboardingStatus() {
        userDefaults.set(false, forKey: onboardingKey)
    }
}