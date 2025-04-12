//
//  SearchViewController.swift
//  Movie App
//
//  Created by Анна on 05.04.2025.
//

import UIKit

class SearchViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Search"
        label.font =  UIFont(name: Fonts.PlusJakartaSans.extraBold.rawValue, size: 18)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.selected.cgColor
        view.backgroundColor = .background
        
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Search"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = .white
        textField.textColor = .black
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.layer.cornerRadius = 22
        textField.layer.masksToBounds = true
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 44))
        imageView.center = paddingView.center
        paddingView.addSubview(imageView)
        
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton()
    
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let image = UIImage(systemName: "slider.horizontal.3", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        
        return button
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: "CategoryViewCell")
        
        return collectionView
    }()
    
    private lazy var moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 24
        layout.sectionInset = UIEdgeInsets(top: 19, left: 22, bottom: 19, right: 22)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(WishlistViewCell.self, forCellWithReuseIdentifier: "WishlistViewCell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    
    //MARK: - Properties
    var categories: [String] = ["All", "Action", "Adventure", "Criminal", "Drama", "Mystery", "Fantasy"]
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        searchTextField.delegate = self
        
        keyBoard()
        setupUI()
    }
    
    //MARK: - Private Methods
    private func keyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)
        containerView.addSubview(searchTextField)
        containerView.addSubview(filterButton)
        view.addSubview(categoryCollectionView)
        view.addSubview(moviesCollectionView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.heightAnchor.constraint(equalToConstant: 52),
            
            searchTextField.topAnchor.constraint(equalTo: containerView.topAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            searchTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: filterButton.leadingAnchor, constant: -8),
            
            filterButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            filterButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 20),
            filterButton.heightAnchor.constraint(equalToConstant: 20),
            
            categoryCollectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 24),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 34),
            
            moviesCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 24),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Action
    @objc
    func filterButtonTapped() {
        let filterVC = FilterSheetViewController()
        present(filterVC, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
}

//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else {
            return  6
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == categoryCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
            cell.configure(for: categories[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistViewCell", for: indexPath) as! WishlistViewCell
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let text = categories[indexPath.item]
            let font = UIFont(name: Fonts.PlusJakartaSans.regular.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold)
            
            let textWidth = text.size(withAttributes: [.font: font]).width
            let padding: CGFloat = 48
            let minWidth: CGFloat = 62
            
            let cellWidth = max(textWidth + padding, minWidth)
            
            return CGSize(width: cellWidth, height: 34)
        } else {
            let width = (UIScreen.main.bounds.size.width)
            return CGSize(width: width, height: 160)
        }
    }
}

//MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
