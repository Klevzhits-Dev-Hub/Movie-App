//
//  Fonts.swift
//  Movie App
//
//  Created by Игорь Клевжиц on 01.04.2025.
//

enum Fonts {
    enum PlusJakartaSans: String {
        case medium = "PlusJakartaSans-Medium"
        case regular = "PlusJakartaSans-Regular"
        case semiBold = "PlusJakartaSans-SemiBold"
        case bold = "PlusJakartaSans-Bold"
        case extraBold = "PlusJakartaSans-ExtraBold"
    }
    
    enum Montserrat: String {
        case medium = "Montserrat-Medium"
    }
}

// MARK: - Пример использования

//UIFont(name: Fonts.PlusJakartaSans.regular.rawValue, size: 18)
