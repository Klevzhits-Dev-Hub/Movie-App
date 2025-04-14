//
//  SearchViewController.swift
//  Movie App
//
//  Created by Анна on 05.04.2025.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
  func showCategories(_ categories: [String])
  func showMovies(_ movies: [Movie])
  func dismissKeyboardSearch()
  func showFilterSheet()
  func navigateToMovieDetail(movieId: Int)
}

class SearchViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Search"
        label.font =  UIFont(name: Fonts.PlusJakartaSans.extraBold.rawValue, size: 18)
        label.textAlignment = .center
        label.textColor = .blackText
        
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
        textField.backgroundColor = .systemBackground
        textField.textColor = .blackText
        textField.clearButtonMode = .whileEditing
        textField.borderStyle = .none
        textField.layer.cornerRadius = 22
        textField.layer.masksToBounds = true
        
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .blackText
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
        button.tintColor = .blackText
        
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
        
        return collectionView
    }()
    
    
    //MARK: - Properties
  private var categories: [String] = []
  private var displayedMovies = [Movie]()
  private let presenter: SearchPresenterProtocol
  
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        OnboardingManager.shared.resetOnboardingStatus()
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        searchTextField.delegate = self
        moviesCollectionView.delegate = self
        categoryCollectionView.delegate = self
        
        setupNavigationBar()
        keyBoard()
        setupUI()
        presenter.viewDidLoad()
    }
  
  init(presenter: SearchPresenterProtocol) {
      self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
    (presenter as? SearchPresenter)?.setupView(self)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Methods
  func selectCategoryIfNeeded() {
    guard let selectedCategoryIndex = presenter.selectedCategoryIndex else { return }
       categoryCollectionView.selectItem(at: selectedCategoryIndex, animated: true, scrollPosition: .centeredHorizontally)
   }
  
    //MARK: - Private Methods
    private func keyBoard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
  
  private func setupNavigationBar() {
    navigationController?.isNavigationBarHidden = true
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
      presenter.filterButtonTapped()
    }
    
    @objc func dismissKeyboard() {
      view.endEditing(true)
    }
}

//MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return collectionView == categoryCollectionView ? categories.count : displayedMovies.count
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
            let category = categories[indexPath.item]
            cell.configure(for: category)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistViewCell", for: indexPath) as! WishlistViewCell
          
            cell.configure(for: WishlistMovie(movie: displayedMovies[indexPath.row], releaseDate: nil, isLike: false))
            
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == categoryCollectionView {
      presenter.didSelectCategory(at: indexPath)
    } else {
      presenter.didSelectMovie(at: indexPath)
    }
  }
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

//MARK: - WishlistViewProtocol
extension SearchViewController: SearchViewProtocol {
  func dismissKeyboardSearch() {
    searchTextField.resignFirstResponder()
  }
  
  func showFilterSheet() {
    present(FilterSheetViewController(), animated: true)
  }
  
  func showCategories(_ categories: [String]) {
    self.categories = categories
    
    DispatchQueue.main.async {
        self.categoryCollectionView.reloadData()
        self.selectCategoryIfNeeded()
    }
  }
  
  func showMovies(_ movies: [Movie]) {
      self.displayedMovies = movies
    DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
    }
  }
  
  func navigateToMovieDetail(movieId: Int) {
      let detailVC = MovieDetailViewController(movieId: movieId)
      navigationController?.pushViewController(detailVC, animated: true)
  }
}
