//
//  CarouselHeaderView.swift
//  Movie App
//
//  Created by Dmitry Volkov on 01/04/2025.
//

import UIKit

class CarouselHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CarouselHeaderView"
    
    let carouselVC = CarouselViewController()
    private var isConfigured = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(carouselVC.view)
        carouselVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            carouselVC.view.topAnchor.constraint(equalTo: topAnchor),
            carouselVC.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselVC.view.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselVC.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            carouselVC.view.heightAnchor.constraint(equalToConstant: 300) // Высота карусели
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with movies: [Movie], onMovieTapped: @escaping (Movie) -> Void) {
        carouselVC.configure(with: movies)
        carouselVC.onMovieTapped = onMovieTapped
    }
}
