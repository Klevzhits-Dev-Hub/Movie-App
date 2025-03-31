import UIKit
final class SettingViewController: UIViewController {
    //MARK: - Properties
    private let presenter: SettingPresenterProtocol
    
    private lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.text = "Setting"
        element.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        element.textColor = .black
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var profileStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Andy Lexsian"
        label.font = label.font.withSize(18)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "@Andy1999"
        label.font = label.font.withSize(14)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Personal Info"
        label.textColor = .black
        label.font =  UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var profileButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "person")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("   Profile", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        //            button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "next")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        //            button.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var securityInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Security"
        label.textColor = .black
        label.font =  UIFont.systemFont(ofSize: 12, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "lock")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("   Change Password", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        //       button.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "unlock")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.setTitle("   Forgot Password", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.tintColor = .black
        //       button.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var darkModeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "activity")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        //       button.addTarget(self, action: #selector(darkModeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let darkModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Dark Mode"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var customSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = false
        uiSwitch.onTintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        // uiSwitch.addTarget(self, action: #selector(darkModeButtonTapped), for: .valueChanged)
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        return uiSwitch
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .none
        button.tintColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        button.layer.cornerRadius = 32
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.3176470588, green: 0.3058823529, blue: 0.7137254902, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        //       button.addTarget(self, action: #selector(logOutButtonTaped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
