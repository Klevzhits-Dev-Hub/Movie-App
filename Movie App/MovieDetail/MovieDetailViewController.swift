//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Artem Kriukov on 31.03.2025.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    private let collapsedLines = 6
    private var isExpanded = false
    
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
        element.image = UIImage(named: "Image")
        element.contentMode = .scaleAspectFit
        element.layer.cornerRadius = 16
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
        element.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 24)
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieAboutStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 24
        element.distribution = .fillProportionally
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var timeLabel: UILabel = {
        let element = UILabel()
        element.text = "148 Minutes"
        element.font = UIFont(name: Fonts.Montserrat.medium.rawValue, size: 12)
        element.textColor = .gray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var dataLabel: UILabel = {
        let element = UILabel()
        element.text = "17 Sep 2021"
        element.font = UIFont(name: Fonts.Montserrat.medium.rawValue, size: 12)
        element.textColor = .gray
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var genreLabel: UILabel = {
        let element = UILabel()
        element.text = "Action"
        element.font = UIFont(name: Fonts.Montserrat.medium.rawValue, size: 12)
        element.textColor = .gray
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
        element.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 16)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieDescrLabel: UILabel = {
        let element = UILabel()
        element.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen bookLorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book"
        element.numberOfLines = 6
        element.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 14)
        element.textColor = UIColor(named: "GrayText")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
#warning("Кнопка show more")
    private lazy var showMoreButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Show More", for: .normal)
        element.addTarget(self, action: #selector(toggleText), for: .touchUpInside)
        element.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 14)
        element.titleLabel?.textColor = UIColor(named: "SelectedColor")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorLabel: UILabel = {
        let element = UILabel()
        element.text = "Cast and Crew"
        element.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 16)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 150, height: 41)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.register(
            ActorsCollectionViewCell.self,
            forCellWithReuseIdentifier: ActorsCollectionViewCell.identifier
        )
        return collectionView
    }()
    
    private lazy var watchNowButton: UIButton = {
        let element = UIButton(type: .system)
        element.setTitle("Watch now", for: .normal)
        element.setTitleColor(
                UIColor(red: 254/255, green: 254/255, blue: 254/255, alpha: 1),
                for: .normal
            )
        element.backgroundColor = UIColor(named: "SelectedColor")
        element.layer.cornerRadius = 24
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    lazy var timeElements = makeStackView(image: UIImage(named: "timeImage"), view: timeLabel)
    lazy var dataElements = makeStackView(image: UIImage(named: "dataImage"), view: dataLabel )
    lazy var genreElements = makeStackView(image: UIImage(named: "filmIconImage"), view: genreLabel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    @objc private func toggleText() {
        isExpanded.toggle()
        movieDescrLabel.numberOfLines = isExpanded ? 0 : 6
        showMoreButton.setTitle(isExpanded ? "Show Less" : "Show More", for: .normal)
    }
    
    func makeStackView(image: UIImage?, view: UIView) -> UIStackView {
        let imageView = UIImageView()
        
        imageView.image = image
        
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let view = UIStackView(arrangedSubviews: [imageView, view])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 4
        return view
    }
    
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = actorCollectionView.dequeueReusableCell(
            withReuseIdentifier: ActorsCollectionViewCell.identifier,
            for: indexPath
        ) as? ActorsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
}

// MARK: - Set Views and Setup Constraints
private extension MovieDetailViewController {
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieDetailStackView)
        contentView.addSubview(movieSummaryStackView)
        contentView.addSubview(actorStackView)
        contentView.addSubview(watchNowButton)
        
        movieDetailStackView.addArrangedSubview(movieNameLabel)
        movieDetailStackView.addArrangedSubview(movieAboutStackView)
        movieDetailStackView.addArrangedSubview(ratingContainerView)
        
        movieAboutStackView.addArrangedSubview(dataElements)
        movieAboutStackView.addArrangedSubview(timeElements)
        movieAboutStackView.addArrangedSubview(genreElements)
        
        ratingContainerView.addSubview(ratingView)
        
        movieSummaryStackView.addArrangedSubview(movieSummaryLabel)
        movieSummaryStackView.addArrangedSubview(movieDescrLabel)
        movieSummaryStackView.addArrangedSubview(showMoreButton)
        
        actorStackView.addArrangedSubview(actorLabel)
        actorStackView.addArrangedSubview(actorCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            
            dataElements.heightAnchor.constraint(equalToConstant: 19),
            timeElements.heightAnchor.constraint(equalToConstant: 19),
            genreElements.heightAnchor.constraint(equalToConstant: 19),
            ratingContainerView.heightAnchor.constraint(equalToConstant: 40),
            ratingView.centerXAnchor.constraint(equalTo: ratingContainerView.centerXAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 19),
            ratingView.widthAnchor.constraint(equalToConstant: 104),
            
            movieSummaryStackView.topAnchor.constraint(equalTo: movieDetailStackView.bottomAnchor, constant: 32),
            movieSummaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 42),
            movieSummaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
            
            showMoreButton.trailingAnchor.constraint(equalTo: movieSummaryStackView.trailingAnchor),
            
            actorStackView.topAnchor.constraint(equalTo: movieSummaryStackView.bottomAnchor, constant: 24),
            actorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 42),
            actorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
            
            actorCollectionView.heightAnchor.constraint(equalToConstant: 41),
            
            watchNowButton.topAnchor.constraint( equalTo: actorStackView.bottomAnchor, constant: 24),
            watchNowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchNowButton.widthAnchor.constraint(equalToConstant: 181),
            watchNowButton.heightAnchor.constraint(equalToConstant: 56),
            watchNowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22),
        ])
    }
}



