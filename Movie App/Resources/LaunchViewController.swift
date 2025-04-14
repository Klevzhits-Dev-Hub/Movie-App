//
//  LaunchViewController.swift
//  Movie App
//
//  Created by Екатерина Орлова on 14.04.2025.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class LaunchViewController: UIViewController {
    
    //    MARK: - Properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "launch")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loadingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "load")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //    MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        darkMode()
        setUI()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadingImage.startRotating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        loadingImage.stopRotating()
    }
    
    
    //    MARK: - Methods
    
    private func setUI() {
        view.backgroundColor = .launchBack
        view.addSubview(imageView)
        view.addSubview(loadingImage)
    }
    
}

//    private func darkMode() {
//        let isSwitchOn: Bool = {
//            if let darkMode = StorageManager.shared.loadUser()?.darkMode {
//                return darkMode == .dark
//            } else {
//                return UITraitCollection.current.userInterfaceStyle == .dark
//            }
//        }()
//
//        let style: UIUserInterfaceStyle = isSwitchOn ? .dark : .light
//
//        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
//        let window = windowScene?.windows.first
//
//        window?.overrideUserInterfaceStyle = style
//    }


//    MARK: - Extensions UIView Rotating

extension UIView {
    func startRotating(duration: Double = 1.0, clockwise: Bool = true) {
        let direction: CGFloat = clockwise ? 1.0 : -1.0
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = CGFloat.pi * 2 * direction
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .linear)
    
        layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotating() {
        layer.removeAnimation(forKey: "rotationAnimation")
    }
}

//    MARK: - Extensions LaunchViewController

private extension LaunchViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 213),
            
            loadingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -74),
            loadingImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImage.widthAnchor.constraint(equalToConstant: 70),
            loadingImage.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}

