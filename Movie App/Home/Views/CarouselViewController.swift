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
    var onMovieTapped: ((Movie) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 220, height: 300)
        layout.sectionInset = UIEdgeInsets(top: 0, left: -140, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 15
        
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
        if !movies.isEmpty {
            return movies.count
        } else {
            return 9
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselMovieCell.identifier, for: indexPath) as! CarouselMovieCell
        
        if !movies.isEmpty {
            let movie = movies[indexPath.item]
            cell.configure(with: movie)
                
            cell.didTap = { [weak self] in
                print("Tapped movie: \(movie.name ?? "Unknown") at index \(indexPath.item)")
                self?.onMovieTapped?(movie)
            }
        }
        
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

        let maxRotationAngle: CGFloat = 10.0
        let maxScale: CGFloat = 1.0
        let minScale: CGFloat = 0.85

        var closestCell: UICollectionViewCell?
        var minDistance: CGFloat = CGFloat.greatestFiniteMagnitude

        for cell in collectionView!.visibleCells {
            guard let indexPath = collectionView!.indexPath(for: cell),
                  let attributes = collectionView!.layoutAttributesForItem(at: indexPath) else { continue }

            let distanceFromCenter = abs(centerX - attributes.frame.midX)

            if distanceFromCenter < minDistance {
                minDistance = distanceFromCenter
                closestCell = cell
            }
        }

        for cell in collectionView!.visibleCells {
            guard let indexPath = collectionView!.indexPath(for: cell),
                  let attributes = collectionView!.layoutAttributesForItem(at: indexPath) else { continue }

            let distanceFromCenter = centerX - attributes.frame.midX
            let normalizedDistance = distanceFromCenter / collectionView!.frame.width

            let rotationAngle = -normalizedDistance * maxRotationAngle
            let scale = abs(normalizedDistance) < 0.27 ? maxScale : minScale

            if let movieCell = cell as? CarouselMovieCell {
                let isCentered = cell == closestCell
                movieCell.setLabelsVisible(isCentered)
            }

            cell.transform = CGAffineTransform(scaleX: scale, y: scale)
                .rotated(by: rotationAngle * .pi / 180)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = scrollView.contentOffset.x + (scrollView.frame.width / 2)

        let maxRotationAngle: CGFloat = 10.0 // Максимальный угол поворота в градусах
        let maxScale: CGFloat = 1.0
        let minScale: CGFloat = 0.85  // Уменьшение

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

            // 👇 Показываем/скрываем лейблы только у центральной ячейки
            if let movieCell = cell as? CarouselMovieCell {
                let isCentered = cell == closestCell
                movieCell.setLabelsVisible(isCentered)
            }

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
    }
    
    func configure(with movies: [Movie]) {
        self.movies = movies
        collectionView?.reloadData()
    }
}
