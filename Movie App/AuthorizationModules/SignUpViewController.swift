//
//  SignUpViewController.swift
//  Movie App
//
//  Created by Екатерина Орлова on 07.04.2025.
//

import UIKit

final class SignUpViewController: UIViewController {
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Sign Up"
        element.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        element.textColor = .black
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    private lazy var stackField: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.isUserInteractionEnabled = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - Labels
    private lazy var firstNameLabel = UILabel.makeCustomLabel(text: "First Name")
    private lazy var lastNameLabel = UILabel.makeCustomLabel(text: "Last Name")
    private lazy var emailLabel = UILabel.makeCustomLabel(text: "E-mail")
    private lazy var passwordLabel = UILabel.makeCustomLabel(text: "Password")
    private lazy var confirmPasswordLabel = UILabel.makeCustomLabel(text: "Confirm Password")
    
    
    // MARK: - TextFields
    private lazy var firstNameTextField = UITextField.makeAuthTextField(withPlaceholder: "  Enter your name")
    private lazy var lastNameTextField = UITextField.makeAuthTextField(withPlaceholder: "  Enter your last name")
    private lazy var emailTextField = UITextField.makeAuthTextField(withPlaceholder: "  Enter your email adress")
    private lazy var passwordTextField = UITextField.makePasswordTextField(withPlaceholder: "  Enter your password")
    private lazy var confirmPasswordTextField = UITextField.makePasswordTextField(withPlaceholder: "  Enter your password")
    
    private let downStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let alreadyLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.selected, for: .normal)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signUpButton = UIButton.makeCustomButton(title: "Sign up", target: self, action: #selector(signUpTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.titleView = titleLabel
        
        setupUI()
        setupConstraints()
    }
    
    @objc func signUpTapped() {
        print("Sign Up button tapped!")
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            AlertManager.showBasicAlert(on: self, title: "Missing Fields", message: "Please fill in all fields.")
            return
        }
        
        if password != confirmPassword {
            AlertManager.showBasicAlert(on: self, title: "Password Mismatch", message: "Passwords do not match.")
            return
        }
        
        if !Validator.isValidUserName(for: firstName) {
            AlertManager.showInvalidUserNameAlert(on: self)
            return
        }
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !Validator.isValidPassword(for: password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        let registerUserRequest = RegisterUserRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password
        )
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
    }
    
    @objc func loginButtonTapped() {
        print("forgotButton tapped!")
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

private extension SignUpViewController {
    func setupUI() {
        view.addSubview(scrollView)
        
        stackField.addArrangedSubview(firstNameLabel)
        stackField.addArrangedSubview(firstNameTextField)
        stackField.addArrangedSubview(lastNameLabel)
        stackField.addArrangedSubview(lastNameTextField)
        stackField.addArrangedSubview(emailLabel)
        stackField.addArrangedSubview(emailTextField)
        stackField.addArrangedSubview(passwordLabel)
        stackField.addArrangedSubview(passwordTextField)
        stackField.addArrangedSubview(confirmPasswordLabel)
        stackField.addArrangedSubview(confirmPasswordTextField)
        
        scrollView.addSubview(signUpButton)
        
        downStack.addArrangedSubview(alreadyLabel)
        downStack.addArrangedSubview(loginButton)
        
        scrollView.addSubview(stackField)
        scrollView.addSubview(downStack)
    }
    
    func setupConstraints() {
        let scrollContentGuide = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackField.topAnchor.constraint(equalTo: scrollContentGuide.topAnchor, constant: 35),
            stackField.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 30),
            stackField.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -30),
            
            signUpButton.topAnchor.constraint(equalTo: stackField.bottomAnchor, constant: 26),
            signUpButton.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 30),
            signUpButton.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -30),
            
            downStack.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 40),
            downStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            
        ])
    }
}
