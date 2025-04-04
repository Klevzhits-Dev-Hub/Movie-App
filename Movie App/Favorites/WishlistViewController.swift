//
//  WishlistViewController.swift
//  Movie App
//
//  Created by Анна on 31.03.2025.
//

import UIKit

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
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - Private methods
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        
        setupConstraints()
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WishlistViewCell", for: indexPath) as! WishlistViewCell
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension WishlistViewController: UICollectionViewDelegate {
    
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
