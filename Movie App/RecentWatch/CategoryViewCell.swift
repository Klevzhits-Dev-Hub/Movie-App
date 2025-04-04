//
//  CategoryViewCell.swift
//  Movie App
//
//  Created by Анна on 01.04.2025.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    // MARK: - GUI Variables
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("All", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .background
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.regular.rawValue, size: 12)
        
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Methods
    func configure(for text: String) {
        categoryButton.setTitle(text, for: .normal)
    }
    
    //MARK: - Private Methods
    @objc private func categoryButtonTapped() {
        let isSelected = categoryButton.backgroundColor == .background
        categoryButton.backgroundColor = isSelected ? .selected : .background
        categoryButton.setTitleColor(isSelected ? .background : .grayText, for: .normal)
    }
    
    private func setupUI() {
        contentView.addSubview(categoryButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoryButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
