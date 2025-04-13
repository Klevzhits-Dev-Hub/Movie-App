//
//  WishlistViewController.swift
//  Movie App
//
//  Created by Анна on 31.03.2025.
//

import UIKit

protocol WishlistViewProtocol: AnyObject {
  func reloadCollectionView()
  func navigateToMovieDetail(movieId: Int) 
}

class WishlistViewController: UIViewController {
    // MARK: - GUI Variables
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Favorites"
        label.font = UIFont(name: Fonts.PlusJakartaSans.extraBold.rawValue, size: 18)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
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
  private let presenter: WishlistViewPresenterProtocol
  
  //MARK: - Initialization
  init() {
      self.presenter = WishlistViewPresenter()
      super.init(nibName: nil, bundle: nil)
      self.presenter.view = self
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
      setupNavigationBar()
        setupUI()
    }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
       presenter.viewWillAppear()
  }
    
    //MARK: - Private methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        setupConstraints()
    }
  
  private func setupNavigationBar() {
    navigationController?.isNavigationBarHidden = true
  }
    
    private func  setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 19),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 23),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - UICollectionViewDataSource
extension WishlistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistViewCell", for: indexPath) as! WishlistViewCell
      let movies = presenter.getWishlistMovies(at: indexPath.row)
        cell.configure(for: movies)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension WishlistViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMovie(at: indexPath.row)
   }
}

//MARK: -  UICollectionViewDelegateFlowLayout
extension WishlistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.size.width)
        return CGSize(width: width, height: 160)
    }
}

//MARK: - WishlistViewProtocol
extension WishlistViewController: WishlistViewProtocol {
  func reloadCollectionView() {
    collectionView.reloadData()
  }
  
  func navigateToMovieDetail(movieId: Int) {
      let detailVC = MovieDetailViewController(movieId: movieId)
      navigationController?.pushViewController(detailVC, animated: true)
  }
}
