//
//  FilterSheetViewController.swift
//  Movie App
//
//  Created by Анна on 07.04.2025.
//

import UIKit

final class FilterSheetViewController: UIViewController {
    //MARK: - UI Variables
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration( weight: .bold))
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeFilter), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Filter"
        label.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 18)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Reset Filters", for: .normal)
        button.setTitleColor(.selected, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 14)
        
        return button
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Categories"
        label.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 16)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: "CategoryViewCell")
        
        return collectionView
    }()
    
    private lazy var starRatingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Star Rating"
        label.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 16)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var starRatingStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    
    private lazy var applyButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Apply Filters", for: .normal)
        button.setTitleColor(.background, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.bold.rawValue, size: 14)
        button.backgroundColor = .selected
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        
        return button
    }()
    
    //MARK: - Properties
    var categories: [String] = ["All", "Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy", "Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy","Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy"]
    
    private var starButtons = [UIButton]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSheet()
        isModalInPresentation = true
        
        configureStarRatingButtons()
        
        setupUI()
    }
    
    //MARK: - Private Methods
    private func setupSheet() {
        view.backgroundColor = .white
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 24
        }
    }
    
    private func setupUI() {
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(resetButton)
        view.addSubview(categoryLabel)
        view.addSubview(categoryCollectionView)
        view.addSubview(starRatingLabel)
        view.addSubview(starRatingStackView)
        view.addSubview(applyButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        starRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        starRatingStackView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29),
            closeButton.heightAnchor.constraint(equalToConstant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: 15),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 10),
            
            resetButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 83),
            
            starRatingLabel.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 21),
            starRatingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            
            starRatingStackView.topAnchor.constraint(equalTo: starRatingLabel.bottomAnchor, constant: 16),
            starRatingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            starRatingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            starRatingStackView.heightAnchor.constraint(equalToConstant: 100),
            
            applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            applyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            applyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func configureStarRatingButtons() {
        var firstRowButtons = [UIButton]()
        var secondRowButtons = [UIButton]()
        
        for i in 1...5 {
            let button = UIButton(type: .system)
            
            button.setTitle(String(repeating: "★", count: i), for: .normal)
            button.setTitleColor(.star, for: .normal)
            button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 18) ?? .systemFont(ofSize: 18)
            
            button.backgroundColor = .background
            button.layer.cornerRadius = 20
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.grayText.cgColor
            button.layer.masksToBounds = true
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            
            button.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
            button.tag = i
            
            if i <= 3 {
                firstRowButtons.append(button)
            } else {
                secondRowButtons.append(button)
            }
            
            starButtons.append(button)
            starRatingStackView.addArrangedSubview(button)
        }
        
        let firstRowStackView = UIStackView(arrangedSubviews: firstRowButtons)
        firstRowStackView.axis = .horizontal
        firstRowStackView.spacing = 12
        firstRowStackView.alignment = .leading
        firstRowStackView.distribution = .equalSpacing
        
        let secondRowStackView = UIStackView(arrangedSubviews: secondRowButtons)
        secondRowStackView.axis = .horizontal
        secondRowStackView.spacing = 12
        secondRowStackView.alignment = .leading
        secondRowStackView.distribution = .equalSpacing
        
        starRatingStackView.addArrangedSubview(firstRowStackView)
        starRatingStackView.addArrangedSubview(secondRowStackView)
    }
    
    @objc private func starButtonTapped(sender: UIButton) {
        starButtons.forEach { button in
            button.layer.borderColor = UIColor.systemGray.cgColor
        }
        
        sender.layer.borderColor = UIColor.selected.cgColor
    }
    
    @objc private func closeFilter() {
        dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDataSource
extension FilterSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
        cell.configure(for: categories[indexPath.row])
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension FilterSheetViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FilterSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = categories[indexPath.item]
        let font = UIFont(name: Fonts.PlusJakartaSans.regular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold)
        
        let textWidth = text.size(withAttributes: [.font: font]).width
        let padding: CGFloat = 48
        let minWidth: CGFloat = 62
        
        let cellWidth = max(textWidth + padding, minWidth)
        
        return CGSize(width: cellWidth, height: 34)
    }
}
