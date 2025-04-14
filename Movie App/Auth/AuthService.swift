//
//  AuthService.swift
//  Movie App
//
//  Created by Екатерина Орлова on 06.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn


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

public struct UserProfileData {
    let firstName: String?
    let lastName: String?
    let email: String?
    let birthDate: String?
    let gender: String?
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
    
    /// Метод получения полных данных профиля пользователя
    public func fetchUserProfileData(completion: @escaping(UserProfileData?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                print("Ошибка получения данных: \(error)")
                completion(nil, error)
            } else if let document = document, document.exists {
                let data = document.data()
                let firstName = data?["firstName"] as? String
                let lastName = data?["lastName"] as? String
                let email = data?["email"] as? String
                let birthDate = data?["birthDate"] as? String
                let gender = data?["gender"] as? String
                
                let profileData = UserProfileData(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    birthDate: birthDate,
                    gender: gender
                )
                
                completion(profileData, nil)
            } else {
                completion(nil, NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Документ пользователя не найден"]))
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
    
    /// Метод обновления данных профиля пользователя
    public func updateUserProfile(firstName: String?, lastName: String?, birthDate: String?, gender: String?, completion: @escaping (Bool, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Ошибка: пользователь не авторизован (uid отсутствует)")
            completion(false, NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
            return
        }
        
        let db = Firestore.firestore()
        var userData: [String: Any] = [:]
        
        // Проверяем, что хотя бы одно поле не пустое
        var hasData = false
        
        if let firstName = firstName, !firstName.isEmpty { 
            userData["firstName"] = firstName 
            print("Добавлено firstName: \(firstName)")
            hasData = true
        }
        if let lastName = lastName, !lastName.isEmpty { 
            userData["lastName"] = lastName 
            print("Добавлено lastName: \(lastName)")
            hasData = true
        }
        if let birthDate = birthDate, !birthDate.isEmpty { 
            userData["birthDate"] = birthDate 
            print("Добавлено birthDate: \(birthDate)")
            hasData = true
        }
        if let gender = gender, !gender.isEmpty { 
            userData["gender"] = gender 
            print("Добавлено gender: \(gender)")
            hasData = true
        }
        
        // Если нет данных для обновления, возвращаем ошибку
        if !hasData {
            print("Ошибка: нет данных для обновления")
            completion(false, NSError(domain: "AuthService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Нет данных для обновления"]))
            return
        }
        
        print("Попытка сохранения данных в Firestore для пользователя с uid: \(uid)")
        print("Данные для сохранения: \(userData)")
        
        // Используем простое обновление документа вместо транзакции
        let userRef = db.collection("users").document(uid)
        
        // Сначала проверяем, существует ли документ
        userRef.getDocument { (document, error) in
            if let error = error {
                print("Ошибка при проверке документа: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            // Если документ не существует, добавляем email
            if document == nil || !document!.exists {
                print("Документ пользователя не существует, создаем новый")
                if userData["email"] == nil, let email = Auth.auth().currentUser?.email {
                    userData["email"] = email
                    print("Добавлен email из текущего пользователя: \(email)")
                }
                
                // Создаем новый документ
                userRef.setData(userData) { error in
                    if let error = error {
                        print("Ошибка при создании документа: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("Документ успешно создан")
                        completion(true, nil)
                    }
                }
            } else {
                // Обновляем существующий документ
                userRef.updateData(userData) { error in
                    if let error = error {
                        print("Ошибка при обновлении документа: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        print("Документ успешно обновлен")
                        
                        // Проверяем, что данные действительно сохранились
                        userRef.getDocument { (document, error) in
                            if let error = error {
                                print("Ошибка при проверке сохраненных данных: \(error.localizedDescription)")
                                completion(false, error)
                            } else if let document = document, document.exists {
                                print("Проверка подтвердила сохранение данных: \(document.data() ?? [:])")
                                completion(true, nil)
                            } else {
                                print("Ошибка: документ не найден после сохранения")
                                completion(false, NSError(domain: "AuthService", code: 3, userInfo: [NSLocalizedDescriptionKey: "Документ не найден после сохранения"]))
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// Метод получения данных профиля пользователя из Google аккаунта
    public func fetchGoogleUserProfileData(completion: @escaping (UserProfileData?, Error?) -> Void) {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            completion(nil, NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован через Google"]))
            return
        }
        
        let profile = user.profile
        let firstName = profile?.givenName
        let lastName = profile?.familyName
        let email = profile?.email
        
        let profileData = UserProfileData(
            firstName: firstName,
            lastName: lastName,
            email: email,
            birthDate: nil,
            gender: nil
        )
        
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            var userData: [String: Any] = [:]
            
            if let firstName = firstName { userData["firstName"] = firstName }
            if let lastName = lastName { userData["lastName"] = lastName }
            if let email = email { userData["email"] = email }
            
            db.collection("users").document(uid).setData(userData, merge: true) { error in
                if let error = error {
                    print("Ошибка при сохранении данных Google профиля: \(error)")
                }
                completion(profileData, nil)
            }
        } else {
            completion(profileData, nil)
        }
    }
}
