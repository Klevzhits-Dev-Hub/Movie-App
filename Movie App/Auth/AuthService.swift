//
//  AuthService.swift
//  Movie App
//
//  Created by Екатерина Орлова on 06.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


struct RegisterUserRequest {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct LoginUserRequest {
    let email: String
    let password: String
}

import FirebaseAuth
import FirebaseFirestore

final class AuthService {
    public static let shared = AuthService()
    private init() {}
    
    /// Метод регистрации пользователя
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        let firstName = userRequest.firstName
        let lastName = userRequest.lastName
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            let db = Firestore.firestore()
            
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "firstName": firstName,
                    "lastName": lastName,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
    
    /// Метод входа пользователя
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    /// Метод выхода пользователя
    public func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    /// Метод восстановления пароля
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    /// Метод получения имени пользователя
    public func fetchUserName(completion: @escaping(String?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Ошибка получения данных: \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                let data = document.data()
                let username = data?["firstName"] as? String
                completion(username)
            } else {
                completion(nil)
            }
        }
    }
    
    /// Метод обновления имени пользователя
    public func updateUserNameForFB(newFirstName: String, newLastName: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "firstName": newFirstName,
            "lastName": newLastName
        ]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}
