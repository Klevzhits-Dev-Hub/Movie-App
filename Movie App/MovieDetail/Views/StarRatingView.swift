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
    
    private var starImageViews: [UIImageView] = []
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addStarImage() {
        starImageViews.removeAll()
        for _ in 0..<5 {
            let starImage = UIImageView()
            starImage.contentMode = .scaleAspectFit
            starImage.translatesAutoresizingMaskIntoConstraints = false
            starImage.image = UIImage(named: "starEmpty")
            
            NSLayoutConstraint.activate([
                starImage.widthAnchor.constraint(equalToConstant: starSize),
                starImage.heightAnchor.constraint(equalToConstant: starSize)
            ])
            
            starsStackView.addArrangedSubview(starImage)
            starImageViews.append(starImage)
        }
    }
    
    func updateRating(value: Float) {
        let maxStars: Float = 5.0
        let normalizedValue = min(max(value, 0), maxStars)
        
        for (index, starImageView) in starImageViews.enumerated() {
            let starPosition = Float(index) + 1.0
            
            if normalizedValue >= starPosition {
                starImageView.image = UIImage(named: "starFilled")
            } else if normalizedValue > starPosition - 1.0 {
                let fillAmount = normalizedValue - (starPosition - 1.0)
                starImageView.image = partiallyFilledStarImage(fillPercentage: fillAmount)
            } else {
                starImageView.image = UIImage(named: "starEmpty")
            }
        }
    }
    
    private func partiallyFilledStarImage(fillPercentage: Float) -> UIImage? {
        guard fillPercentage > 0 else { return UIImage(named: "starEmpty") }
        guard fillPercentage < 1 else { return UIImage(named: "starFilled") }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: starSize, height: starSize))
        
        return renderer.image { context in
            UIImage(named: "starEmpty")?.draw(in: CGRect(origin: .zero, size: CGSize(width: starSize, height: starSize)))
            
            let fillWidth = starSize * CGFloat(fillPercentage)
            let fillRect = CGRect(x: 0, y: 0, width: fillWidth, height: starSize)
            
            context.cgContext.saveGState()
            context.cgContext.clip(to: fillRect)
            UIImage(named: "starFilled")?.draw(in: CGRect(origin: .zero, size: CGSize(width: starSize, height: starSize)))
            context.cgContext.restoreGState()
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
