//
//  RessetViewController.swift
//  Movie App
//
//  Created by Екатерина Орлова on 08.04.2025.
//

import UIKit

final class RessetViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Forgot your password?"
        element.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        element.textColor = .black
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var emailLabel = UILabel.makeCustomLabel(text: "E-mail")
    private lazy var emailTextField = UITextField.makeAuthTextField(withPlaceholder: "  Enter your email adress")
    private lazy var submitButton = UIButton.makeCustomButton(title: "Submit", target: self, action: #selector(submitButtonTapped))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageBack = UIImage(systemName: "arrow.backward")?.withTintColor(.label, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: imageBack, style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = titleLabel
        
        setupUI()
    }
    
    @objc private func submitButtonTapped() {
        print("Submit button tapped!")
        let email = self.emailTextField.text ?? ""
        
        if !Validator.isValidEmail(for: email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else {return}
            if let error = error {
                AlertManager.showForgotPasswordErrorSending(on: self, with: error)
                return
            }
            AlertManager.showPasswordResetSent(on: self)
        }
    }
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}

private extension RessetViewController {
    func  setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            
            emailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 138),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 18),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 52),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -52),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
}
