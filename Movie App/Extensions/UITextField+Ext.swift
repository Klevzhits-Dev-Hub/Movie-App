//
//  UITextField+Ext.swift
//  Movie App
//
//  Created by Екатерина Орлова on 02.04.2025.
//

import UIKit

extension UITextField {
    static func makeTextField(withPlaceholder text: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.borderWidth = 1.0
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.layer.cornerRadius = 24
        textField.layer.borderColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1)
        textField.placeholder = text
        textField.textColor = .blackText
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static  func makeTextFieldWithCalendar(withPlaceholder text: String, actionDate: Selector, action: Selector, target: Any) -> UITextField {
        let textField = makeTextField(withPlaceholder: text)
        
        let calendarButton = UIButton(type: .system)
        calendarButton.setImage(#imageLiteral(resourceName: "calendar"), for: .normal)
        calendarButton.tintColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1)
        calendarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        textField.rightView = calendarButton
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        textField.inputView = datePicker
        
        let toolBar = UIToolbar().toolbarPicker(action)
        textField.inputAccessoryView = toolBar
        
        calendarButton.addTarget(target, action: #selector(ProfileViewController.showDatePicker(_:)), for: .touchUpInside)
        
        return textField
    }
    
    
    static  func makeAuthTextField(withPlaceholder text: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .authTextField
        textField.layer.cornerRadius = 25
        textField.placeholder = text
        textField.textColor = .grayText
        
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        //        textField.widthAnchor.constraint(equalToConstant: 327).isActive = true
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    static  func makePasswordTextField(withPlaceholder text: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .authTextField
        textField.layer.cornerRadius = 25
        textField.placeholder = text
        textField.textColor = .grayText
        
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        //        textField.widthAnchor.constraint(equalToConstant: 327).isActive = true
        
        textField.isUserInteractionEnabled = true
        textField.isSecureTextEntry = true
        textField.textContentType = .newPassword
        
        let showPasswordButton = UIButton(type: .custom)
        showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        showPasswordButton.tintColor = UIColor.systemGray
        
        let padding: CGFloat = 10
        
        showPasswordButton.frame = CGRect(x: 0, y: 0, width: 24 + padding, height: 24)
        showPasswordButton.tintColor = UIColor.systemGray
        let iconContainerView = UIView(frame: CGRect(x: padding, y: 0, width: showPasswordButton.frame.width + padding, height: showPasswordButton.frame.height))
        iconContainerView.addSubview(showPasswordButton)
        iconContainerView.bringSubviewToFront(showPasswordButton)
        showPasswordButton.addTarget(textField, action: #selector(UITextField.togglePasswordVisibility(_:)), for: .touchUpInside)
        
        textField.rightView = iconContainerView
        textField.rightViewMode = .always
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        guard let container = sender.superview,
              let textField = container.superview as? UITextField else { return }
        textField.isSecureTextEntry.toggle()
        let buttonImage = textField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        sender.setImage(buttonImage, for: .normal)
    }
}

private extension UIToolbar {
    func toolbarPicker(_ target: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: target)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
}

