//
//  Header.swift
//  Movie App
//
//  Created by Dmitry Volkov on 31/03/2025.
//

import UIKit

final class CategoryHeaderView: UICollectionReusableView {
    static let identifier = "CategoryHeaderView"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.text = "Category"
        label.textColor = .blackText
        label.font = .boldSystemFont(ofSize: 18)
        addSubview(label)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
