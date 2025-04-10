//
//  AlertManager.swift
//  Movie App
//
//  Created by Екатерина Орлова on 06.04.2025.
//

import UIKit

final class AlertManager {
    
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

//MARK: - validator alert
extension AlertManager {
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter valid email")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter valid password")
    }
    
    public static func showInvalidUserNameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid User Name", message: "Please enter valid name")
    }
}


//MARK: - ошибка регистрации
extension AlertManager {
    
    public static func showRegistrationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Registration Error", message: "Go to home")
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
}


//MARK: - ошибка логина
extension AlertManager {
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknow Sign In Error", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Sign In Error", message: "\(error.localizedDescription)")
    }
}


//MARK: - ошибка выхода
extension AlertManager {
    
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Log out Error", message: "\(error.localizedDescription)")
    }
}


//MARK: - ошибка забыли пароль
extension AlertManager {
    
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password reset sent", message: nil)
    }
    
    public static func showForgotPasswordErrorSending(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Error sending password reset", message: "\(error.localizedDescription)")
    }
}


//MARK: - Fetching User Errors
extension AlertManager {
    
    public static func showUnknowFetchingError(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Password reset sent", message: nil)
    }
   
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        self.showBasicAlert(on: vc, title: "Unknow Fetching Error", message: "\(error.localizedDescription)")
    }
}
