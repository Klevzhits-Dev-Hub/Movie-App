//
//  BoxOfficeMovieCell.swift
//  Movie App
//
//  Created by Dmitry Volkov on 31/03/2025.
//

import UIKit

class BoxOfficeMovieCell: UICollectionViewCell {
    
    let identifier = "BoxOfficeMovieCell"
    
    let movieImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "movieMock")
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Name of the movie"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.text = "Action"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clockIcon")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let starImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "star.fill")
        iv.tintColor = .systemYellow
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let durationLabel: UILabel = {
        let label = UILabel()
        label.text = "148 minutes"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.text = "4.4"
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rewiewNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "(55)"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favourtiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let horizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let infoStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let durationStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let ratingHorizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(movieImageView)
        horizontalStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(genreLabel)
        infoStackView.addArrangedSubview(titleLabel)
        durationStackView.addArrangedSubview(timeImageView)
        durationStackView.addArrangedSubview(durationLabel)
        infoStackView.addArrangedSubview(durationStackView)
        contentView.addSubview(favourtiteButton)
        ratingHorizontalStackView.addArrangedSubview(starImageView)
        ratingHorizontalStackView.addArrangedSubview(ratingLabel)
        ratingHorizontalStackView.addArrangedSubview(rewiewNumberLabel)
        contentView.addSubview(ratingHorizontalStackView)
        setConstraints()
        
        favourtiteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.widthAnchor.constraint(equalToConstant: 100),
            movieImageView.heightAnchor.constraint(equalToConstant: 100),
            timeImageView.widthAnchor.constraint(equalToConstant: 20),
            timeImageView.heightAnchor.constraint(equalToConstant: 20),
            favourtiteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            favourtiteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ratingHorizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            ratingHorizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    @objc func toggleFavourite() {
        print("tapped")
    }
    
    func configure(with category: String) {
        
    }
}
