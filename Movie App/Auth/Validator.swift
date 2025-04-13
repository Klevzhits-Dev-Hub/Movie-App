//
//  Validator.swift
//  Movie App
//
//  Created by Екатерина Орлова on 06.04.2025.
//

import Foundation


final class Validator {
    static func isValidEmail(for email: String) -> Bool {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    static func isValidUserName(for username: String) -> Bool {
        let name = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let userRegEx = "\\w{4,24}"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", userRegEx)
        return usernamePred.evaluate(with: name)
    }
    
    static func isValidPassword(for password: String) -> Bool {
        let pass = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let passRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passRegEx)
        return passwordPred.evaluate(with: pass)
    }
}
