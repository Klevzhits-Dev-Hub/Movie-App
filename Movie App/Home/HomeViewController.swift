//
//  HomeViewController.swift
//  Movie App
//
//  Created by Dmitry Volkov on 31/03/2025.
//

import UIKit

enum ReuseIdentifier {
    static let defaultCell = "DefaultCell"
}

enum SectionKind {
    static let categoryHeader = "categoryHeaderId"
    static let boxOfficeHeader = "boxOfficeHeaderId"
}

protocol HomeViewProtocol: AnyObject {
    func showMovies(_ movies: [Movie])
    func showCategories(_ categories: [String])
    func showBoxOfficeMovies(_ movies: [Movie])
    func highlightSelectedCategory(_ category: String)
    func navigateToMovieDetail(movieId: Int)
}

final class HomeViewController: UICollectionViewController{
    //MARK: - Properties
    private let presenter: HomePresenterProtocol
    private var displayedMovies = [Movie]()
    private var carouselMovies: [Movie] = []
    private var categories = [String]()
    private var selectedCategoryIndex: IndexPath?
    private var didReceiveCategories = false
    private var didReceiveMovies = false
    
    private let loader = UIActivityIndicatorView(style: .large)
    private var isInitialDataLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLargeNavBar()
        setupCollectionVIew()
        setupLoader()
        presenter.fetchCategories()
        
        collectionView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.highlightCurrentCategory()
    
        
        //collectionView.alpha = 0
        //collectionView.isHidden = true
        //loader.startAnimating()

        //didReceiveCategories = false
        //didReceiveMovies = false

        //presenter.fetchCategories()
        
    }
            
    init(presenter: HomePresenterProtocol) {
        self.presenter = presenter
        super.init(collectionViewLayout: HomeViewController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Protocol Methods
extension HomeViewController: HomeViewProtocol {
    func showCategories(_ categories: [String]) {
        self.categories = categories
        didReceiveCategories = true
        DispatchQueue.main.async {
            self.collectionView.reloadData()

            let selectedCategory = self.presenter.getSelectedCategory()
            let itemIndex = selectedCategory.flatMap { categories.firstIndex(of: $0) } ?? 0
            let indexPath = IndexPath(item: itemIndex, section: 1)

            self.selectedCategoryIndex = indexPath
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self.collectionView.delegate?.collectionView?(self.collectionView, didSelectItemAt: indexPath)
            
            self.checkIfLoadingCompleted()
        }
    }
    
    func showMovies(_ movies: [Movie]) {
        self.displayedMovies = movies
        
        if carouselMovies.isEmpty {
            carouselMovies = Array(displayedMovies
                .filter { $0.poster?.url != nil }
                .shuffled()
                .prefix(10))
        }
    
        didReceiveMovies = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.collectionView.numberOfSections > 2 {
                self.collectionView.reloadSections(IndexSet([0, 2]))
                self.collectionView.reloadSections(IndexSet(integer: 2))
            } else {
                self.collectionView.reloadData()
            }
            self.checkIfLoadingCompleted()
        }
    }
    
    func showBoxOfficeMovies(_ movies: [Movie]) {
        self.displayedMovies = movies
        didReceiveMovies = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if self.collectionView.numberOfSections > 2 {
                self.collectionView.reloadSections(IndexSet(integer: 2))
            } else {
                self.collectionView.reloadData()
            }
            self.checkIfLoadingCompleted()
        }
    }
    
    func highlightSelectedCategory(_ category: String) {
        guard let index = categories.firstIndex(of: category) else { return }
           let indexPath = IndexPath(item: index, section: 1)

           DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
               self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
               self.collectionView.delegate?.collectionView?(self.collectionView, didSelectItemAt: indexPath)
               self.selectedCategoryIndex = indexPath
           }
    }
    
    func navigateToMovieDetail(movieId: Int) {
        let detailVC = MovieDetailViewController(movieId: movieId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - CollectionVIew Settings
extension HomeViewController {
    func setupCollectionVIew() {
        collectionView.register(CarouselHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: CarouselHeaderView.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.register(BoxOfficeMovieCell.self, forCellWithReuseIdentifier: BoxOfficeMovieCell.identifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: SectionKind.categoryHeader, withReuseIdentifier: CategoryHeaderView.identifier)
        collectionView.register(BoxOfficeHeaderView.self, forSupplementaryViewOfKind: SectionKind.boxOfficeHeader, withReuseIdentifier: BoxOfficeHeaderView.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 250)
    }
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return createSection(for: sectionIndex, layoutEnvironment: layoutEnvironment)
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        } else if section == 1 {
            return categories.count
        }
        return displayedMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedCategoryIndex = indexPath
            let category = categories[indexPath.item]
            presenter.categoryTapped(category: category)
        } else if indexPath.section == 2 {
            //collectionView.isHidden = true
            presenter.movieTapped(selectedMovie: displayedMovies[indexPath.item])
        }
    }
}

// MARK: - Cells & Sections
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.defaultCell, for: indexPath)
            cell.backgroundColor = .lightGray
            
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
            cell.configure(with: categories[indexPath.item])
            return cell
        }
        let movie = displayedMovies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxOfficeMovieCell.identifier, for: indexPath) as! BoxOfficeMovieCell
        cell.configure(with: movie)
        return cell
    }
    
    private static func createSection(for sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
        if sectionIndex == 0 {
            let item = NSCollectionLayoutItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(0)
                        )
                    )

                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(0)
                        ),
                        subitems: [item]
                    )

                    let section = NSCollectionLayoutSection(group: group)
    
                    section.boundarySupplementaryItems = [
                        NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: NSCollectionLayoutSize(
                                widthDimension: .fractionalWidth(1),
                                heightDimension: .absolute(300)
                            ),
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top
                        )
                    ]
                    return section
        
        } else if sectionIndex == 1 {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(1), heightDimension: .absolute(60)))
            item.contentInsets.bottom = 16
        
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
            
            group.interItemSpacing = .fixed(15)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: SectionKind.categoryHeader, alignment: .topLeading)]
            return section
            
        } else {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150)))
            item.contentInsets.bottom = 16
        
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150 * 5 + 16 * 4)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets.leading = 20
            section.contentInsets.trailing = 20
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: SectionKind.boxOfficeHeader, alignment: .topLeading)]
            return section
        }
    }
}

// MARK: - CollectionVIew Header Settings
extension HomeViewController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == SectionKind.categoryHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CategoryHeaderView.identifier, for: indexPath)
        } else if kind == SectionKind.boxOfficeHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BoxOfficeHeaderView.identifier, for: indexPath)
        } else if kind == UICollectionView.elementKindSectionHeader, indexPath.section == 0 {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                        withReuseIdentifier: CarouselHeaderView.reuseIdentifier,
                                                                         for: indexPath) as! CarouselHeaderView
            // фильмы для карусели
            header.configure(with: self.carouselMovies) { [weak self] movie in
                self?.presenter.movieTapped(selectedMovie: movie)
            }
            return header
        }
        fatalError("Unexpected element kind")
    }

}

// MARK: - NavBar Settings
extension HomeViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .white
        
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
            customNavBarBackground.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        view.bringSubviewToFront(navigationController!.navigationBar)
    }
}
// MARK: - UI helpers
extension HomeViewController {
    func updateVisibleCellsColor() {
        for cell in collectionView.visibleCells {
            cell.backgroundColor = .green
        }
    }
    
    private func selectPreviouslySelectedCategoryIfNeeded() {
        guard !categories.isEmpty else { return }

        let selectedCategory = presenter.getSelectedCategory()
        let itemIndex = selectedCategory.flatMap { categories.firstIndex(of: $0) } ?? 0
        let indexPath = IndexPath(item: itemIndex, section: 1)

        selectedCategoryIndex = indexPath

        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        collectionView.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
    }
    
    private func setupLoader() {
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        view.addSubview(loader)

        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loader.startAnimating()
        collectionView.isHidden = true
    }
    
    private func showLoader() {
        loader.startAnimating()
        collectionView.isHidden = true
    }

    private func hideLoader() {
        loader.stopAnimating()
        collectionView.isHidden = false
    }
    
    private func checkIfLoadingCompleted() {
        guard didReceiveCategories && didReceiveMovies else { return }

        loader.stopAnimating()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.curveEaseInOut]) {
            self.collectionView.alpha = 1
        }
    }
}



