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
    let username: String
    let email: String
    let password: String
}

struct LoginUserRequest {
    let email: String
    let password: String
}

final class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    
    
    /// метод регистрации пользователя
    /// - Parameters:
    ///   - userRequest: информация о пользователе ( username , email , password )
    ///   - completion: завершение с 2мя значениями
    ///   - Bool: wasRegistered - был ли зарегестрирован в базе данных правильно
    ///   - Error?:  возможная ошибка от FB
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error  in
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
                    "username" : username,
                    "email" : email
                ]) { error in
                    if let error = error {
                        completion(false, error)
                        return
                    }
                    
                    completion(true, nil)
                }
        }
    }
    
    public func singIn(with userRequest: LoginUserRequest, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: userRequest.email, password: userRequest.password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping (Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    
    public func forgotPassword(with email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
        
    }
    
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
                let username = data?["username"] as? String
                completion(username)
            } else {
                completion(nil)
            }
        }
    }
    
    public func updateUserNameForFB(newUsername: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(false, nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "username" : newUsername]) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
                
            }
    }
    
}


