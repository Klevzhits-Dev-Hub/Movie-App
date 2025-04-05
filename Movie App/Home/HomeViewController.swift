//
//  HomeViewController.swift
//  Movie App
//
//  Created by Dmitry Volkov on 31/03/2025.
//

import UIKit

final class HomeViewController: UICollectionViewController {
    let cellId = "cell"
    let categoryCell = "categoryCell"
    
    let categories = ["All", "Action", "Adventure", "Drama", "Comedy", "Biography"]
    var popularMovies = [Movie]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CarouselHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CarouselHeaderView.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCell)
        collectionView.register(BoxOfficeMovieCell.self, forCellWithReuseIdentifier: BoxOfficeMovieCell.identifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: HomeViewController.categoryHeaderId, withReuseIdentifier: headerId)
        collectionView.register(BoxOfficeHeaderView.self, forSupplementaryViewOfKind: HomeViewController.boxOfficeHeaderId, withReuseIdentifier: boxOfficeId)
        
        setupNavigationBar()
        setupLargeNavBar()

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        
        collectionView.contentInset.top = 25
        
        NetworkManager.shared.fetchPopularMovies { result in
            switch result {
            case .success(let movieResponse):
                self.popularMovies = movieResponse.docs
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("Error fetching movies: \(error)")
            }
        }
        
    }
        
    init() {
        super.init(collectionViewLayout: HomeViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateVisibleCellsColor() {
        for cell in collectionView.visibleCells {
            cell.backgroundColor = .green
        }
    }
    
    let headerId = "headerId"
    static let categoryHeaderId = "categoryHeaderId"
    
    let boxOfficeId = "boxOfficeId"
    static let boxOfficeHeaderId = "boxOfficeHeaderId"
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == HomeViewController.categoryHeaderId {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        } else if kind == HomeViewController.boxOfficeHeaderId {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: boxOfficeId, for: indexPath)
        } else if kind == UICollectionView.elementKindSectionHeader, indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: CarouselHeaderView.reuseIdentifier,
                                                                        for: indexPath) as! CarouselHeaderView
            return header
        }
        fatalError("Unexpected element kind")
    }
    
    private func setupNavigationBar() {
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = .clear
        
        let imageView = UIImageView(image: UIImage(named: "logoMock"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true

        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        imageView.layer.cornerRadius = 25
        
        let label = UILabel()
        label.text = "Hi, Andy"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let description = UILabel()
        description.text = "only streaming movie lovers"
        description.font = UIFont.systemFont(ofSize: 16)
        description.textColor = .systemGray
        description.translatesAutoresizingMaskIntoConstraints = false
        
        let textStackView = UIStackView(arrangedSubviews: [label, description])
        textStackView.axis = .vertical
        textStackView.spacing = 4
        textStackView.alignment = .leading
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [imageView, textStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        let leftItem = UIBarButtonItem(customView: titleView)
        navigationItem.leftBarButtonItem = leftItem
    }

    private func setupLargeNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let customNavBarBackground = UIView()
        customNavBarBackground.backgroundColor = .white
        customNavBarBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customNavBarBackground)

        NSLayoutConstraint.activate([
            customNavBarBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarBackground.topAnchor.constraint(equalTo: view.topAnchor),
            customNavBarBackground.heightAnchor.constraint(equalToConstant: 120) // Высота навбара
        ])
        
        view.bringSubviewToFront(navigationController!.navigationBar)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else if section == 1 {
            return categories.count
        }
        return popularMovies.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .lightGray
            
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCell, for: indexPath) as! CategoryCell
            cell.configure(with: categories[indexPath.item])
            return cell
        }
        let movie = popularMovies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxOfficeMovieCell.identifier, for: indexPath) as! BoxOfficeMovieCell
        cell.configure(with: movie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return createSection(for: sectionIndex, layoutEnvironment: layoutEnvironment)
        }
    }

    private static func createSection(for sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        if sectionIndex == 0 {
            let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(0) // Заменяем ячейки заголовком
                        )
                    )

                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(0) // Нет ячеек, только заголовок
                        ),
                        subitems: [item]
                    )

                    let section = NSCollectionLayoutSection(group: group)
                    //section.contentInsets.top = 30
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .absolute(300) // Высота заголовка с каруселью
                            ),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                    ]
                    return section
        
        } else if sectionIndex == 1 {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .absolute(60)))
            //item.contentInsets.trailing = 20
            item.contentInsets.bottom = 16
        
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
            
            group.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: categoryHeaderId, alignment: .topLeading)]
            return section
            
        } else {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)))
            item.contentInsets.bottom = 16
        
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150 * 5 + 16 * 4)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 20
            section.contentInsets.trailing = 20
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: boxOfficeHeaderId, alignment: .topLeading)]
            return section
        }
    }
}


