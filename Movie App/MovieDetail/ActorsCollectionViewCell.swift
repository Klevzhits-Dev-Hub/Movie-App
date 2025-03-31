//
//  ActorsCollectionViewCell.swift
//  Movie App
//
//  Created by Artem Kriukov on 31.03.2025.
//

import UIKit

class ActorsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ActorsCollectionViewCell"
    
    private lazy var label: UILabel = {
        let element = UILabel()
        element.text = "Actors"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        addSubview(label)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
