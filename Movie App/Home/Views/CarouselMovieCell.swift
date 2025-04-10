//
//  CarouselMovieCell.swift
//  Movie App
//
//  Created by Dmitry Volkov on 01/04/2025.
//
import UIKit

class CarouselMovieCell: UICollectionViewCell {
    static let identifier = "CarouselMovieCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "movieMock")
        return iv
    }()
    
    // Добавим замыкание
    var didTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        
        // Gesture recognizer
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tap)
        contentView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTap() {
        didTap?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    func configure(with movie: Movie) {
        if let urlString = movie.poster?.url {
            ImageLoader.shared.loadImage(from: urlString) { [weak self] img in
                DispatchQueue.main.async {
                    self?.imageView.image = img
                }
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        didTap = nil
    }
}
