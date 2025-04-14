//
//  CategoryViewCell.swift
//  Movie App
//
//  Created by Анна on 01.04.2025.
//

import UIKit

class CategoryViewCell: UICollectionViewCell {
    // MARK: - GUI Variables
  private lazy var categoryLabel: UILabel = {
      let label = UILabel()
      
      label.text = "All"
      label.textColor = .grayText
      label.backgroundColor = .background
      label.layer.cornerRadius = 18
      label.layer.borderWidth = 1
      label.layer.borderColor = UIColor.grayText.cgColor
      label.font = UIFont(name: Fonts.PlusJakartaSans.regular.rawValue, size: 12)
      label.textAlignment = .center
      label.clipsToBounds = true
      
      return label
  }()

    //MARK: - Properties
  
  override var isSelected: Bool {
      didSet {        
        categoryLabel.backgroundColor = isSelected ? .selected : .systemBackground
          categoryLabel.textColor = isSelected ? .white : .grayText
        categoryLabel.layer.borderColor = isSelected ? UIColor.selected.cgColor : UIColor.grayText.cgColor
      }
  }
  
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configure(for text: String) {
      categoryLabel.text = text
    }
    
    //MARK: - Private Methods
    private func setupUI() {
        contentView.addSubview(categoryLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
      categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
          categoryLabel.topAnchor.constraint(equalTo: topAnchor),
          categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
          categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
          categoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
          categoryLabel.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
}
