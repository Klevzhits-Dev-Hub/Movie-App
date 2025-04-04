//
//  UILabel+Ext.swift
//  Movie App
//
//  Created by Екатерина Орлова on 02.04.2025.
//

import UIKit

extension UILabel {
    static func makeCustomLabel(
        text: String) -> UILabel
    {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 14)
        label.textColor = .grayText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
