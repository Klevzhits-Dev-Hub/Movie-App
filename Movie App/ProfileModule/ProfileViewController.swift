//
//  ProfileViewController.swift
//  Movie App
//
//  Created by Екатерина Орлова on 01.04.2025.
//

import UIKit

protocol ProfileViewProtocol: AnyObject {
    
}

final class ProfileViewController: UIViewController {
    //MARK: - Properties
    private let presenter: ProfilePresenterProtocol
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Profile"
        element.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 18)
        element.textColor = .black
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "arrow.left"), for: .normal)
        //        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editAvatar: UIButton = {
        let button = UIButton(type: .system)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        
        button.setImage(imageView.image, for: .normal)
//        button.addTarget(self, action: #selector(changeAvatarButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Labels
    private lazy var firstNameLabel = UILabel.makeCustomLabel(text: "First Name")
    private lazy var lastNameLabel = UILabel.makeCustomLabel(text: "Last Name")
    private lazy var emailLabel = UILabel.makeCustomLabel(text: "E-mail")
    private lazy var dateOfBirthLabel = UILabel.makeCustomLabel(text: "Date of Birth")
    private lazy var genderLabel = UILabel.makeCustomLabel(text: "Gender")
    private lazy var locationLabel = UILabel.makeCustomLabel(text: "Location")
    
    //MARK: - TextFields
    private lazy var firstNameTextField = UITextField.makeTextField(withPlaceholder: "Andy")
    private lazy var lastNameTextField = UITextField.makeTextField(withPlaceholder: "Lexsian")
    private lazy var emailTextField = UITextField.makeTextField(withPlaceholder: "Andylexian22@gmail.com")
    private lazy var dateOfBirthTextField = UITextField.makeTextFieldWithCalendar(withPlaceholder: "24 february 1996")
    private lazy var locationTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .lightGray
        textView.layer.cornerRadius = 24
        textView.layer.borderWidth = 1
        textView.layer.borderColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.font = UIFont.systemFont(ofSize: 16)
        //           textView.delegate = self
        textView.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: - Buttons
    private lazy var maleButton = GenderCustomButton(type: .male) {
        print("maleButtonTapped")
    }
    private lazy var femaleButton = GenderCustomButton(type: .female) {
        print("femaleButtonTapped")
    }
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 16)
        button.setTitleColor( .grayText, for: .normal)
        button.layer.cornerRadius = 24
        button.backgroundColor = .grayButtonProfileScreen
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "unavailable")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProfileViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(backButton)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(editAvatar)
        scrollView.addSubview(firstNameLabel)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameLabel)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(dateOfBirthLabel)
        scrollView.addSubview(dateOfBirthTextField)
        scrollView.addSubview(genderLabel)
        scrollView.addSubview(maleButton)
        scrollView.addSubview(femaleButton)
        scrollView.addSubview(locationLabel)
        scrollView.addSubview(locationTextView)
        scrollView.addSubview(saveButton)
    }
    func setupConstraints() {
        let scrollContentGuide = scrollView.contentLayoutGuide
        let scrollFrameGuide = scrollView.frameLayoutGuide
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: scrollContentGuide.topAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            editAvatar.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            editAvatar.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -28),
            editAvatar.widthAnchor.constraint(equalToConstant: 32),
            editAvatar.heightAnchor.constraint(equalToConstant: 32),
            
            firstNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            firstNameLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 8),
            firstNameTextField.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            firstNameTextField.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 52),
            
            lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 16),
            lastNameLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 8),
            lastNameTextField.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            lastNameTextField.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 52),
            
            emailLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16),
            emailLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 8),
            emailTextField.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            emailTextField.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            emailTextField.heightAnchor.constraint(equalToConstant: 52),
            
            dateOfBirthLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
            dateOfBirthLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            dateOfBirthTextField.topAnchor.constraint(equalTo: dateOfBirthLabel.bottomAnchor, constant: 8),
            dateOfBirthTextField.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            dateOfBirthTextField.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            dateOfBirthTextField.heightAnchor.constraint(equalToConstant: 52),
            
            genderLabel.topAnchor.constraint(equalTo: dateOfBirthTextField.bottomAnchor, constant: 16),
            genderLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            maleButton.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            femaleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 8),
            femaleButton.leadingAnchor.constraint(equalTo: maleButton.trailingAnchor, constant: 16),
            femaleButton.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            
            maleButton.widthAnchor.constraint(equalTo: femaleButton.widthAnchor, multiplier: 1, constant: .zero),
            
            locationLabel.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            
            locationTextView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            locationTextView.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            locationTextView.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            locationTextView.heightAnchor.constraint(equalToConstant: 132),
            
            saveButton.topAnchor.constraint(equalTo: locationTextView.bottomAnchor, constant: 64),
            saveButton.leadingAnchor.constraint(equalTo: scrollFrameGuide.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: scrollFrameGuide.trailingAnchor, constant: -24),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -34),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            profileImageView.image = image
            profileImageView.layer.cornerRadius = 48
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.clipsToBounds = true
            
            // Здесь  сохранять изображение
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ProfileViewProtocol
extension ProfileViewController: ProfileViewProtocol {
    
}

