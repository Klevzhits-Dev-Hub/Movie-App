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
          textField.translatesAutoresizingMaskIntoConstraints = false
          return textField
      }
    
    static  func makeTextFieldWithCalendar(withPlaceholder text: String) -> UITextField {
            let textField = makeTextField(withPlaceholder: text)
            
            let calendarButton = UIButton(type: .system)
            calendarButton.setImage(#imageLiteral(resourceName: "сalendar"), for: .normal)
            calendarButton.tintColor = #colorLiteral(red: 0.3179999888, green: 0.3059999943, blue: 0.7139999866, alpha: 1)
            calendarButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            calendarButton.translatesAutoresizingMaskIntoConstraints = true
            textField.rightView = calendarButton
            textField.rightViewMode = .always
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            
//            datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
//            textField.inputView = datePicker
//            
//            let toolBar = UIToolbar().toolBarPicker(#selector(doneButtonPressed))
//            textField.inputAccessoryView = toolBar

            return textField
        }
}
