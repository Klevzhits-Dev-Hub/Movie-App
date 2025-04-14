//
//  WishlistViewCell.swift
//  Movie App
//
//  Created by Анна on 31.03.2025.
//

import UIKit

class WishlistViewCell: UICollectionViewCell {
    // MARK: - GUI Variables
    private lazy var filmImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Luck"
        label.textColor = .blackText
        label.font = UIFont(name: Fonts.PlusJakartaSans.extraBold.rawValue, size: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "148 Minutes"
        label.font = UIFont(name: Fonts.Montserrat.medium.rawValue, size: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var dataLabel: UILabel = {
        let label = UILabel()
        label.text = "17 Sep 2021"
        label.font = UIFont(name: Fonts.Montserrat.medium.rawValue, size: 12)
        label.textColor = .gray
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.filled()
        config.title = "Action"
        config.baseBackgroundColor = .selected
        config.baseForegroundColor = .white
        
        config.attributedTitle = AttributedString("Action", attributes: AttributeContainer([.font: UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 10) ?? UIFont.systemFont(ofSize: 10, weight: .medium)]))
        config.contentInsets = NSDirectionalEdgeInsets(top: 7, leading: 16, bottom: 7, trailing: 16)
        
        button.configuration = config
        button.layer.cornerRadius = 5
        
        return button
    }()
    
    lazy var timeElements = makeStackView(image: UIImage(named: "timeImage"), view: timeLabel)
    lazy var dataElements = makeStackView(image: UIImage(named: "dataImage"), view: dataLabel)
    lazy var filmElements = makeStackView(image: UIImage(named: "filmIconImage"), view: actionButton)
    
    private lazy var filmIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "filmIconImage")
        
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "likeButton"), for: .normal)
        
        return button
    }()
  
  // MARK: - Properties
  private var movie: Movie?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
  func configure(for model: WishlistMovie) {
    movie = model.movie
    titleLabel.text = model.movie.name
    timeLabel.text = model.movie.durationString
    if let date = model.releaseDate {
      dataLabel.text = formatDate(date.ISO8601Format())
    }
    if let firstGenre = model.movie.genres?.first {
      actionButton.setTitle(firstGenre.name, for: .normal)
    }
    
    setLikeButtonColor(with: model.movie)
    
    if let posterUrl = model.movie.poster?.url ?? model.movie.poster?.previewUrl {
        ImageLoader.shared.loadImage(from: posterUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.filmImageView.image = image
            }
        }
    }
  }
  
    // MARK: - Private Methods
    @objc private func likeButtonTapped() {
      if let movie {
        CoreDataManager.shared.toggleLike(movie: movie)
        setLikeButtonColor(with: movie)
      }
    }
  
  private func setLikeButtonColor(with movie: Movie) {
      if CoreDataManager.shared.containsMovie(withId: movie.id) {
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = UIColor(named: "AccentColor")
      } else {
        likeButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
      }
  }
    
    private func makeStackView(image: UIImage?, view: UIView) -> UIStackView {
        let imageView = UIImageView()
        imageView.image = image
        
        let view = UIStackView(arrangedSubviews: [imageView, view])
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private func setupUI() {
        addSubview(filmImageView)
        addSubview(titleLabel)
        addSubview(likeButton)
        addSubview(stackView)
        stackView.addArrangedSubview(timeElements)
        stackView.addArrangedSubview(dataElements)
        stackView.addArrangedSubview(filmElements)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        filmImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        timeElements.translatesAutoresizingMaskIntoConstraints = false
        dataElements.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: topAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            filmImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filmImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -14),
            filmImageView.widthAnchor.constraint(equalToConstant: 120),
            filmImageView.trailingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: -14),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: 5),
            
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            likeButton.widthAnchor.constraint(equalToConstant: 24),
            likeButton.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
        ])
    }
}
