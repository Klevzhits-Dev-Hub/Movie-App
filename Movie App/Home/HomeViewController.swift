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
    let movieCell = "movieCell"
    
    let categories = ["All", "Action", "Adventure", "Drama", "Comedy"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: categoryCell)
        collectionView.register(BoxOfficeMovieCell.self, forCellWithReuseIdentifier: movieCell)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: HomeViewController.categoryHeaderId, withReuseIdentifier: headerId)
        collectionView.register(BoxOfficeHeaderView.self, forSupplementaryViewOfKind: HomeViewController.boxOfficeHeaderId, withReuseIdentifier: boxOfficeId)
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
        }
        fatalError("Unexpected element kind")
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
        return 10
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCell, for: indexPath)
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
                    widthDimension: .fractionalWidth(0.33),
                    heightDimension: .absolute(300)
                )
            )
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(300)
                ),
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .paging
            
            section.visibleItemsInvalidationHandler = { (visibleItems, contentOffset, environment) in
                let collectionViewWidth = environment.container.contentSize.width
                let centerX = contentOffset.x + (collectionViewWidth / 2) // Центр экрана

            
                for item in visibleItems {
                    let distanceFromCenter = centerX - item.frame.midX
                    let normalizedDistance = distanceFromCenter / collectionViewWidth

                    // Увеличиваем порог для определения центрального элемента
                    let threshold: CGFloat = 0.30  // Увеличили порог для центрального элемента

                    let scale: CGFloat
                    let maxScale: CGFloat = 0.6  // Центральный элемент (уменьшен на 20%)
                    let minScale: CGFloat = 1.0  // Боковые элементы (нормальные)

                    // Если расстояние от центра меньше порога, это центральный элемент
                    print("DEBUG \(abs(normalizedDistance))")
                    
                    if abs(normalizedDistance) < threshold {
                        scale = maxScale
                        print("MAXSCALE \(scale)")
                    } else {
                        scale = minScale
                        print("MINSCALE \(scale)")
                    }
                    
                    // масштабирвоание ячейки
                }
            }

            return section
        
        } else if sectionIndex == 1 {
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .absolute(60)))
            item.contentInsets.trailing = 20
            item.contentInsets.bottom = 16
        
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(70)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
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


