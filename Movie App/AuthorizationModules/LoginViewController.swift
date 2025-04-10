//
//  LoginViewController.swift
//  Movie App
//
//  Created by Екатерина Орлова on 06.04.2025.
//
import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Login"
        element.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        element.textColor = .black
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    //MARK: - Labels
    private lazy var emailLabel = UILabel.makeCustomLabel(text: "Email")
    private lazy var passwordLabel = UILabel.makeCustomLabel(text: "Password")
    
    private lazy var emailTextField = UITextField.makeAuthTextField(withPlaceholder: " Enter your email adress")
    private lazy var passwordTextField = UITextField.makeAuthTextField(withPlaceholder: " Enter your password")
    
    private let rememberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Remember Me"
        return label
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "⎯⎯⎯⎯  Or continue with  ⎯⎯⎯⎯"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.onTintColor = .selected
        toggle.thumbTintColor = .white
        toggle.backgroundColor = .systemGray4
        toggle.layer.cornerRadius = 16
        toggle.addTarget(self, action: #selector(didChangeSwitch), for: .valueChanged)
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let stackField: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let stackButton: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let downStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var forgotButton : UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.selected, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(forgotButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dontLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t have an account?"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.selected, for: .normal)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signInButton = UIButton.makeCustomButton(title: "Sign in", target: self, action: #selector(signInButtonTapped))
    
    private lazy var loginGoogleButton = UIButton.makeGoogleButton(title: "Continue with Google", target: self, action: #selector(googleButtonTapped))
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    @objc func didChangeSwitch() {
        if toggleSwitch.isOn {
            guard let email = emailTextField.text, !email.isEmpty,
                  let password = passwordTextField.text, !password.isEmpty else { return }
//           добавить сохранение и удаление
        }
    }
    @objc func signInButtonTapped() {
        print("Sign In button tapped!")
        
        let loginRequest = LoginUserRequest(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        
        if !Validator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        if !Validator.isValidPassword(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthService.shared.signIn(with: loginRequest) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            // Перенаправление на домашний экран
            self.openVC()
        }
    }
    
    @objc func googleButtonTapped() {
        print("Google button tapped!")
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Создание конфигурации для Google Sign In
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let _ = result, error == nil else { return }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            self?.signInWithGoogle(idToken: idToken, accessToken: user.accessToken.tokenString)
        }
    }
    func signInWithGoogle(idToken: String, accessToken: String ) {
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            // Перенаправление на домашний экран
            self.openVC()
        }
    }
    private func openVC() {
        //        let vc = HomeViewController()
        //        self.navigationController?.pushViewController(vc, animated: true)
        let vc = ProfileFactory.makeProfileModule()
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @objc func forgotButtonTapped() {
        print("forgot button tapped!")
        let vc = RessetViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func signUpButtonTapped() {
        print("sign in button tapped!")
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - Setup ui and constraints
private extension LoginViewController {
    func setupUI() {
        stackField.addArrangedSubview(emailLabel)
        stackField.addArrangedSubview(emailTextField)
        stackField.addArrangedSubview(passwordLabel)
        stackField.addArrangedSubview(passwordTextField)
        
        horizontalStack.addArrangedSubview(toggleSwitch)
        horizontalStack.addArrangedSubview(rememberLabel)
        horizontalStack.addArrangedSubview(forgotButton)
        
        stackButton.addArrangedSubview(signInButton)
        stackButton.addArrangedSubview(orLabel)
        stackButton.addArrangedSubview(loginGoogleButton)
        
        downStack.addArrangedSubview(dontLabel)
        downStack.addArrangedSubview(signUpButton)
        
        view.addSubview(stackField)
        view.addSubview(horizontalStack)
        view.addSubview(stackButton)
        view.addSubview(downStack)
        
        NSLayoutConstraint.activate([
            stackField.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            horizontalStack.topAnchor.constraint(equalTo: stackField.bottomAnchor, constant: 20),
            horizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            horizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            stackButton.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 40),
            stackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            stackButton.bottomAnchor.constraint(equalTo: downStack.topAnchor, constant: 50),
            
            downStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
