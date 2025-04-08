//
//  CarouselViewController.swift
//  Movie App
//
//  Created by Dmitry Volkov on 01/04/2025.
//

import UIKit

class CarouselViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var movies = [Movie]()
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView?.register(CarouselMovieCell.self, forCellWithReuseIdentifier: CarouselMovieCell.identifier)
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        guard let myCollection = collectionView else { return }
        view.addSubview(myCollection)
        
        myCollection.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myCollection.topAnchor.constraint(equalTo: view.topAnchor),
            myCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 300).integral
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselMovieCell.identifier, for: indexPath) as! CarouselMovieCell
        //cell.configure(with: movies[indexPath.item])
        return cell
    }
    
    // Применение эффекта трансформации при первом появлении экрана
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        applyCellTransformations()
    }
    
    // Применяем трансформацию ко всем ячейкам
    func applyCellTransformations() {
        let centerX = collectionView!.contentOffset.x + (collectionView!.frame.width / 2)

        let maxRotationAngle: CGFloat = 10.0 // Максимальный угол поворота в градусах
        let maxScale: CGFloat = 1.0
        let minScale: CGFloat = 0.75  // Уменьшение

        for cell in collectionView!.visibleCells {
            guard let indexPath = collectionView!.indexPath(for: cell),
                  let attributes = collectionView!.layoutAttributesForItem(at: indexPath) else { continue }

            let distanceFromCenter = centerX - attributes.frame.midX
            let normalizedDistance = distanceFromCenter / collectionView!.frame.width

            let rotationAngle = -normalizedDistance * maxRotationAngle
            let scale = abs(normalizedDistance) < 0.27 ? maxScale : minScale

            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
                .rotated(by: rotationAngle * .pi / 180)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + (scrollView.frame.width / 2)

        let maxRotationAngle: CGFloat = 10.0 // Максимальный угол поворота в градусах
        let maxScale: CGFloat = 1.0
        let minScale: CGFloat = 0.75  // Уменьшение

        var closestCell: UICollectionViewCell?
        var minDistance: CGFloat = CGFloat.greatestFiniteMagnitude

        // Определяем ближайшую к центру ячейку
        for cell in collectionView!.visibleCells {
            guard let indexPath = collectionView!.indexPath(for: cell),
                  let attributes = collectionView!.layoutAttributesForItem(at: indexPath) else { continue }

            let distanceFromCenter = abs(centerX - attributes.frame.midX)

            if distanceFromCenter < minDistance {
                minDistance = distanceFromCenter
                closestCell = cell
            }
        }

        // Применяем трансформацию для всех видимых ячеек
        for cell in collectionView!.visibleCells {
            guard let indexPath = collectionView!.indexPath(for: cell),
                  let attributes = collectionView!.layoutAttributesForItem(at: indexPath) else { continue }

            let distanceFromCenter = centerX - attributes.frame.midX
            let normalizedDistance = distanceFromCenter / scrollView.frame.width

            // Устанавливаем угол поворота
            let rotationAngle = -normalizedDistance * maxRotationAngle

            // Определяем масштаб для ячейки
            let scale = abs(normalizedDistance) > 0.30 ? minScale : maxScale

            // Если ячейка является ближайшей к центру, увеличиваем ее до максимума, остальные — уменьшаем
            if cell == closestCell {
                UIView.animate(withDuration: 0.3) {
                    cell.transform = CGAffineTransform(scaleX: maxScale, y: maxScale)
                        .rotated(by: rotationAngle * .pi / 180)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    cell.transform = CGAffineTransform(scaleX: minScale, y: minScale)
                        .rotated(by: rotationAngle * .pi / 180)
                }
            }
        }
        
        func configure(with movies: [Movie]) {
            self.movies = movies
            collectionView?.reloadData()
        }
    }
}
