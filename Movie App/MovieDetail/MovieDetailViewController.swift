//
//  MovieDetailViewController.swift
//  Movie App
//
//  Created by Artem Kriukov on 31.03.2025.
//

import UIKit

final class MovieDetailViewController: UIViewController {

    private let detailView = MovieDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = detailView
        
    }
    
}


