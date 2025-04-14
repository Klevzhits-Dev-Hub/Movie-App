//
//  EditAvatarViewController.swift
//  Movie App
//
//  Created by Екатерина Орлова on 03.04.2025.
//
import UIKit

class EditAvatarViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.systemChromeMaterialDark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        return blurEffectView
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change your picture"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .blackText
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "camera")?.withRenderingMode(.automatic)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 160)
        button.setTitle("Take a photo", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 14)
        button.setTitleColor(.blackText, for: .normal)
        button.backgroundColor = .grayButtonProfileScreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var photoLibraryButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "file")?.withRenderingMode(.automatic)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 100)
        button.setTitle("Choose from your file", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 14)
        button.setTitleColor(.blackText, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = .grayButtonProfileScreen
        button.addTarget(self, action: #selector(photoLibraryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 160)
        button.setTitle("Delete photo", for: .normal)
        button.backgroundColor = .grayButtonProfileScreen
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 14)
        button.setTitleColor(.redForProfile, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Setup
    private func setupView() {
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(photoLibraryButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            containerView.heightAnchor.constraint(equalToConstant: 340),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cameraButton.topAnchor.constraint(equalTo: photoLibraryButton.bottomAnchor, constant: 10),
            cameraButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cameraButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cameraButton.heightAnchor.constraint(equalToConstant: 60),
            
            photoLibraryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            photoLibraryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            photoLibraryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            photoLibraryButton.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.topAnchor.constraint(equalTo: cameraButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        
        ])
    }
    
    // MARK: - Actions
    @objc private func cameraButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.editAvatarViewController(self, didSelectOption: .camera)
        }
    }
    
    @objc private func photoLibraryButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.editAvatarViewController(self, didSelectOption: .photoLibrary)
        }
    }

    @objc private func cancelButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.editAvatarViewControllerDidCancel(self)
        }
    }
    
    // MARK: - Delegate
    weak var delegate: EditAvatarViewControllerDelegate?
}

// MARK: - EditAvatarViewControllerDelegate
protocol EditAvatarViewControllerDelegate: AnyObject {
    func editAvatarViewController(_ viewController: EditAvatarViewController, didSelectOption option: EditAvatarOption)
    func editAvatarViewControllerDidCancel(_ viewController: EditAvatarViewController)
}

// MARK: - EditAvatarOption
enum EditAvatarOption {
    case photoLibrary
    case camera
}
