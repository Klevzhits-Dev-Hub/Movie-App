//
//  UIButton+Ext.swift
//  Movie App
//
//  Created by Екатерина Орлова on 07.04.2025.
//

import UIKit

extension UIButton {
    static func makeCustomButton(title: String, target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.backgroundColor = .selected
        button.layer.cornerRadius = 25
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 16)
        
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        button.addTarget(target, action: action, for: .touchUpInside)
        button.addTarget(button, action: #selector(UIButton.buttonTouchedDown(_:)), for: .touchDown)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func makeGoogleButton(title: String,target: Any?, action: Selector) -> UIButton {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 25
        button.clipsToBounds = false
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 0.8
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let containerStackView = UIStackView()
        containerStackView.axis = .horizontal
        containerStackView.alignment = .center
        containerStackView.spacing = 10
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.isUserInteractionEnabled = false
        
        let imageView = UIImageView(image: UIImage(named: "google"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 16)
        titleLabel.textColor = .blackText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(titleLabel)
        
        button.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            containerStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor),

            button.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        button.addTarget(target, action: action, for: .touchUpInside)
        button.addTarget(button, action: #selector(UIButton.buttonTouchedDown(_:)), for: .touchDown)
  
        return button
    }
    
    @objc private func buttonTouchedDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.alpha = 0.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UIView.animate(withDuration: 0.1) {
                sender.alpha = 1.0
            }
        }
    }
}
