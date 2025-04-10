//
//  AlertManager.swift
//  Movie App
//
//  Created by Екатерина Орлова on 06.04.2025.
//

import UIKit

final class AlertManager {
     static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Validator Alerts
extension AlertManager {
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password.")
    }
    
    public static func showInvalidUserNameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please enter a valid username.")
    }
}

// MARK: - Registration Errors
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Registration Error", message: "An unknown error occurred during registration.")
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Sign-In Errors
extension AlertManager {
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Sign-In Error", message: "An unknown error occurred during sign-in.")
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Sign-In Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Logout Errors
extension AlertManager {
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Logout Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Forgot Password Errors
extension AlertManager {
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password Reset Sent", message: "Check your email for instructions.")
    }
    
    public static func showForgotPasswordErrorSending(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error sending password reset", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors
extension AlertManager {
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Fetching User Error", message: "\(error.localizedDescription)")
    }
}
