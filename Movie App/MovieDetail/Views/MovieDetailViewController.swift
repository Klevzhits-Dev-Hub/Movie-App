//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Artem Kriukov on 31.03.2025.
//

import UIKit

protocol MovieDetailViewProtocol: AnyObject {
    func displayMovieDetails(_ movie: Movie)
    func reloadActorsCollection()
}

final class MovieDetailViewController: UIViewController {
    
    // MARK: - Private Properties
    private let presenter: MovieDetailPresenterProtocol
    
    private let movieDescriptionText = ""
    
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
        element.contentMode = .scaleAspectFill
        element.layer.cornerRadius = 16
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
        element.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 24)
        element.textAlignment = .center
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieAboutStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 24
        element.distribution = .equalCentering
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
    
    private lazy var starRatingView: StarRatingView = {
        let view = StarRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var movieSummaryStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 16
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var movieDescriptionView: StoryLineView = {
        let view = StoryLineView(collapsedLines: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var actorCollectionContainer: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        element.backgroundColor = .clear
        element.clipsToBounds = false
        return element
    }()
    
    private lazy var actorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 180, height: 41)
        
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
        element.addTarget(self, action: #selector(watchNowButtonTapped), for: .touchUpInside)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    lazy var timeElements = makeStackView(image: UIImage(named: "timeImage"), view: timeLabel)
    lazy var dataElements = makeStackView(image: UIImage(named: "dataImage"), view: dataLabel )
    lazy var genreElements = makeStackView(image: UIImage(named: "filmIconImage"), view: genreLabel)
    
    
    init(movieId: Int) {
        self.presenter = MovieDetailPresenter(movieId: movieId)
        super.init(nibName: nil, bundle: nil)
        self.presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundColor")
        presenter.viewDidLoad()
        setupViews()
        setupConstraints()
        configureDescription()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupShadow()
    }
    
    // MARK: - Private Methods
    private func configureDescription() {
        movieDescriptionView.configure(
            title: "Story Line",
            description: movieDescriptionText
        )
    }
    
    private func makeStackView(image: UIImage?, view: UIView) -> UIStackView {
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
    
    private func setupShadow() {
        actorCollectionContainer.layer.shadowColor = UIColor.black.cgColor
        actorCollectionContainer.layer.shadowOpacity = 1
        actorCollectionContainer.layer.shadowRadius = 60
        
        let shadowHeight = actorCollectionContainer.bounds.height * 0.5
        
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: actorCollectionContainer.bounds.height - shadowHeight))
        shadowPath.addLine(to: CGPoint(x: actorCollectionContainer.bounds.width, y: actorCollectionContainer.bounds.height - shadowHeight))
        shadowPath.addLine(to: CGPoint(x: actorCollectionContainer.bounds.width, y: actorCollectionContainer.bounds.height))
        shadowPath.addLine(to: CGPoint(x: 0, y: actorCollectionContainer.bounds.height))
        shadowPath.close()
        
        actorCollectionContainer.layer.shadowPath = shadowPath.cgPath
        actorCollectionContainer.layer.shadowOffset = CGSize(width: 40, height: 0)
        actorCollectionContainer.layer.shouldRasterize = true
        actorCollectionContainer.layer.rasterizationScale = UIScreen.main.scale
    }
    
    @objc private func watchNowButtonTapped() {
        guard let url = presenter.getTrailerURL() else {
            showNoTrailerAlert()
            return
        }
        let webVC = WebViewController(url: url)
        present(webVC, animated: true)
    }
    
    private func showNoTrailerAlert() {
        let alert = UIAlertController(
            title: "No Trailer Available",
            message: "There is no trailer available for this movie.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - MovieDetailViewProtocol
extension MovieDetailViewController: MovieDetailViewProtocol {
    func displayMovieDetails(_ movie: Movie) {
        movieNameLabel.text = movie.name ?? movie.alternativeName
        timeLabel.text = movie.durationString
        
        if let premiereDate = movie.premiere?.world {
            dataLabel.text = formatDate(premiereDate)
        }
        
        genreLabel.text = movie.genres?.map { $0.name }.joined(separator: ", ")
        
        if let rating = movie.rating?.kp {
            let ratingValue = Float(rating) / 2.0
            starRatingView.updateRating(value: ratingValue)
        }
        
        movieDescriptionView.configure(
            title: "Story Line",
            description: movie.description ?? movie.shortDescription ?? ""
        )
        
        if let posterUrl = movie.poster?.url ?? movie.poster?.previewUrl {
            ImageLoader.shared.loadImage(from: posterUrl) { [weak self] image in
                DispatchQueue.main.async {
                    self?.movieImageView.image = image
                }
            }
        }
    }
    
    
    func reloadActorsCollection() {
        actorCollectionView.reloadData()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }
        return dateString
    }
}

// MARK: - UICollectionViewDataSource
extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getActorsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = actorCollectionView.dequeueReusableCell(
            withReuseIdentifier: ActorsCollectionViewCell.identifier,
            for: indexPath
        ) as? ActorsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let actor = presenter.getActor(at: indexPath.item) {
            cell.configure(with: actor)
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
        
        ratingContainerView.addSubview(starRatingView)
        
        movieSummaryStackView.addArrangedSubview(movieDescriptionView)
        
        actorStackView.addArrangedSubview(actorLabel)
        actorStackView.addArrangedSubview(actorCollectionContainer)
        actorCollectionContainer.addSubview(actorCollectionView)
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
            
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            movieImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 300),
            movieImageView.widthAnchor.constraint(equalToConstant: 224),
            
            movieDetailStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 24),
            movieDetailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 42),
            movieDetailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
            
            dataElements.heightAnchor.constraint(equalToConstant: 19),
            timeElements.heightAnchor.constraint(equalToConstant: 19),
            genreElements.heightAnchor.constraint(equalToConstant: 19),
            
            ratingContainerView.heightAnchor.constraint(equalToConstant: 16),
            starRatingView.centerXAnchor.constraint(equalTo: ratingContainerView.centerXAnchor),
            starRatingView.centerYAnchor.constraint(equalTo: ratingContainerView.centerYAnchor),
            
            movieSummaryStackView.topAnchor.constraint(equalTo: movieDetailStackView.bottomAnchor, constant: 32),
            movieSummaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            movieSummaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            actorStackView.topAnchor.constraint(equalTo: movieSummaryStackView.bottomAnchor, constant: 24),
            actorStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            actorStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            actorCollectionView.topAnchor.constraint(equalTo: actorCollectionContainer.topAnchor),
            actorCollectionView.leadingAnchor.constraint(equalTo: actorCollectionContainer.leadingAnchor),
            actorCollectionView.trailingAnchor.constraint(equalTo: actorCollectionContainer.trailingAnchor),
            actorCollectionView.bottomAnchor.constraint(equalTo: actorCollectionContainer.bottomAnchor),
            
            actorCollectionContainer.heightAnchor.constraint(equalToConstant: 41),
            
            watchNowButton.topAnchor.constraint(equalTo: actorStackView.bottomAnchor, constant: 24),
            watchNowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            watchNowButton.widthAnchor.constraint(equalToConstant: 181),
            watchNowButton.heightAnchor.constraint(equalToConstant: 56),
            watchNowButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -22)
        ])
    }
}
