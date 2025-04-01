//
//  StarRatingView.swift
//  Movie App
//
//  Created by Artem Kriukov on 01.04.2025.
//

import UIKit

final class StarRatingView: UIView {
    // MARK: - Properties
    private let starSize: CGFloat = 16
    private let starSpacing: CGFloat = 6
    
    // MARK: - UI
    private lazy var starsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = starSpacing
        stack.distribution = .equalCentering
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addStarImage() {
        for _ in 0..<5 {
            let starImage = UIImageView(image: UIImage(named: "starFilled"))
            starImage.contentMode = .scaleAspectFit
            starImage.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                starImage.widthAnchor.constraint(equalToConstant: starSize),
                starImage.heightAnchor.constraint(equalToConstant: starSize)
            ])
            starsStackView.addArrangedSubview(starImage)
        }
    }
}

private extension StarRatingView {
    func setupView() {
        
        addSubview(starsStackView)
        addStarImage()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            starsStackView.topAnchor.constraint(equalTo: topAnchor),
            starsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            starsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
