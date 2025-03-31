//
//  MovieDetailView.swift
//  Movie App
//
//  Created by Artem Kriukov on 31.03.2025.
//

import UIKit

final class MovieDetailView: UIView {
    
    // MARK: - UI
    
    private lazy var scrollView: UIScrollView = {
        let element = UIScrollView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var contentView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "MockImage")
        element.contentMode = .scaleAspectFit
        element.clipsToBounds = true
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieDetailStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieNameLabel: UILabel = {
        let element = UILabel()
        element.text = "Movie Name"
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieAboutStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 24
        element.distribution = .fillEqually
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
#warning("movieAboutStackView")
    private lazy var view1: UIView = {
        let element = UIView()
        element.backgroundColor = .red
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var view2: UIView = {
        let element = UIView()
        element.backgroundColor = .blue
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var view3: UIView = {
        let element = UIView()
        element.backgroundColor = .black
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var ratingContainerView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
#warning("raiting")
    private lazy var ratingView: UIView = {
        let element = UIView()
        element.backgroundColor = .black
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieSummaryStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieSummaryLabel: UILabel = {
        let element = UILabel()
        element.text = "Story Line"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieDescrLabel: UILabel = {
        let element = UILabel()
        element.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
        element.numberOfLines = 0
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
#warning("Кнопка show more")
    
    private lazy var actorStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorLabel: UILabel = {
        let element = UILabel()
        element.text = "Cast and Crew"
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
#warning("collection view?")
    
    private lazy var watchNowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Watch now", for: .normal)
        element.layer.cornerRadius = 24
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Set Views and Setup Constraints
private extension MovieDetailView {
    func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieDetailStackView)
        contentView.addSubview(movieSummaryStackView)
        contentView.addSubview(actorStackView)
        contentView.addSubview(watchNowButton)
        
        movieDetailStackView.addArrangedSubview(movieNameLabel)
        movieDetailStackView.addArrangedSubview(movieAboutStackView)
        movieDetailStackView.addArrangedSubview(ratingContainerView)
        
        movieAboutStackView.addArrangedSubview(view1)
        movieAboutStackView.addArrangedSubview(view2)
        movieAboutStackView.addArrangedSubview(view3)
        
        ratingContainerView.addSubview(ratingView)
        
        movieSummaryStackView.addArrangedSubview(movieSummaryLabel)
        movieSummaryStackView.addArrangedSubview(movieDescrLabel)
        
        actorStackView.addArrangedSubview(actorLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                
                movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                movieImageView.heightAnchor.constraint(equalToConstant: 300),
                movieImageView.widthAnchor.constraint(equalToConstant: 224),
                
                movieDetailStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 24),
                movieDetailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 42),
                movieDetailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
                
                view1.heightAnchor.constraint(equalToConstant: 19),
                view2.heightAnchor.constraint(equalToConstant: 19),
                view3.heightAnchor.constraint(equalToConstant: 19),
                ratingContainerView.heightAnchor.constraint(equalToConstant: 40),
                ratingView.centerXAnchor.constraint(equalTo: ratingContainerView.centerXAnchor),
                ratingView.heightAnchor.constraint(equalToConstant: 19),
                ratingView.widthAnchor.constraint(equalToConstant: 104),
                
                movieSummaryStackView.topAnchor.constraint(equalTo: movieDetailStackView.bottomAnchor, constant: 32),
                movieSummaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 42),
                movieSummaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
                
                actorStackView.topAnchor.constraint(equalTo: movieSummaryStackView.bottomAnchor, constant: 24),
                actorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 42),
                actorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
                
                watchNowButton.topAnchor.constraint( equalTo: actorStackView.bottomAnchor, constant: 24),
                watchNowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                watchNowButton.widthAnchor.constraint(equalToConstant: 181),
                watchNowButton.heightAnchor.constraint(equalToConstant: 56),
                watchNowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
            ]
        )
    }
}
