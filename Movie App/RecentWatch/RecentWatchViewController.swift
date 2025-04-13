//
//  RecentWatchViewController.swift
//  Movie App
//
//  Created by Анна on 01.04.2025.
//

import UIKit

protocol RecentWatchViewProtocol: AnyObject {
  func reloadCollectionView()
  func showCategories(_ categories: [String])
  func showMovies(_ movies: [Movie])
  func navigateToMovieDetail(movieId: Int) 
}

class RecentWatchViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Recent Watch"
        label.font =  UIFont(name: Fonts.PlusJakartaSans.extraBold.rawValue, size: 18)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
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
    private let presenter: RecentWatchPresenterProtocol
    private var categories: [String] = []
    private var displayedMovies = [Movie]()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUI()
        presenter.viewDidLoad()
    }
    
    init(presenter: RecentWatchPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        if let recentWatchPresenter = presenter as? RecentWatchPresenter {
            recentWatchPresenter.setupView(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    presenter.viewWillAppear()
  }
    
  //MARK: - Methods
  func selectCategoryIfNeeded() {
    guard let selectedCategoryIndex = presenter.selectedCategoryIndex else { return }
       categoryCollectionView.selectItem(at: selectedCategoryIndex, animated: true, scrollPosition: .centeredHorizontally)
   }
  
    //MARK: - Private methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(categoryCollectionView)
        view.addSubview(moviesCollectionView)
        
        setupConstraints()
    }
  
  private func setupNavigationBar() {
    navigationController?.isNavigationBarHidden = true
  }
    
    private func  setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        moviesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 19),
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 34),
            
            moviesCollectionView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 20),
            moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension RecentWatchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return collectionView == categoryCollectionView ? categories.count : presenter.getNumberOfItems()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == categoryCollectionView {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryViewCell", for: indexPath) as! CategoryViewCell
          let category = categories[indexPath.item]
            cell.configure(for: category)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistViewCell", for: indexPath) as! WishlistViewCell
            cell.configure(for: presenter.getRecentMovies(at: indexPath.row))
          
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate
extension RecentWatchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == categoryCollectionView {
      presenter.didSelectCategory(at: indexPath)
    } else {
      presenter.didSelectMovie(at: indexPath)
    }
  }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension RecentWatchViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - RecentWatchViewProtocol
extension RecentWatchViewController: RecentWatchViewProtocol {
  func showCategories(_ categories: [String]) {
    self.categories = categories
    
    DispatchQueue.main.async {
      self.categoryCollectionView.reloadData()
      self.selectCategoryIfNeeded()
    }
  }
  
  func reloadCollectionView() {
    moviesCollectionView.reloadData()
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
