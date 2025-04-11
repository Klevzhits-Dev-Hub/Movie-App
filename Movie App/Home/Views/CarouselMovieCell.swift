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
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let genreLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Genre", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var didTap: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(imageView)
        imageView.addSubview(gradientView)
        imageView.addSubview(genreLabel)
        imageView.addSubview(titleLabel)
        setConstraints()

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

        // Обновляем градиент после layout
        DispatchQueue.main.async { [weak self] in
            self?.addBottomToTopGradient(to: self?.gradientView ?? UIView())
        }
    }
    
    func configure(with movie: Movie) {
        if let urlString = movie.poster?.url {
            ImageLoader.shared.loadImage(from: urlString) { [weak self] img in
                DispatchQueue.main.async {
                    self?.imageView.image = img
                }
            }
        }
        genreLabel.setTitle(movie.genres?.first?.name.uppercased() ?? "", for: .normal)
        titleLabel.text = movie.name
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        didTap = nil
    }
    
    private func addBottomToTopGradient(to view: UIView) {
        view.layer.sublayers?.removeAll(where: { $0.name == "bottomGradient" })

        let gradientLayer = CAGradientLayer()
        gradientLayer.name = "bottomGradient"
        gradientLayer.frame = view.bounds

        let baseColor = UIColor(named: "AccentColor") ?? UIColor.purple

        gradientLayer.colors = [
            baseColor.cgColor,
            baseColor.withAlphaComponent(0.0).cgColor
        ]

        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setLabelsVisible(_ visible: Bool) {
        genreLabel.isHidden = !visible
        titleLabel.isHidden = !visible
        gradientView.isHidden = !visible // если хочешь скрыть и градиент
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            gradientView.topAnchor.constraint(equalTo: imageView.topAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -20),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -20),

            genreLabel.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8),
            genreLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 20),
            genreLabel.heightAnchor.constraint(equalToConstant: 24),
            genreLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
    }
}
