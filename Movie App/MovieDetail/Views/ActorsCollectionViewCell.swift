//
//  ActorsCollectionViewCell.swift
//  Movie App
//
//  Created by Artem Kriukov on 31.03.2025.
//

import UIKit

class ActorsCollectionViewCell: UICollectionViewCell {
    static let identifier = "ActorsCollectionViewCell"
    
    private lazy var actorsStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 8
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(named: "MockActor")
        element.contentMode = .scaleAspectFill
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.distribution = .fillEqually
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorNameLabel: UILabel = {
        let element = UILabel()
        element.text = "Actor Name"
        element.font = UIFont(
            name: Fonts.PlusJakartaSans.semiBold.rawValue,
            size: 14
        )
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var actorRoleLabel: UILabel = {
        let element = UILabel()
        element.text = "Actor Role"
        element.font = UIFont(
            name: Fonts.PlusJakartaSans.medium.rawValue,
            size: 10
        )
        element.textColor = UIColor(named: "GrayText")
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        addSubview(actorsStackView)
        
        actorsStackView.addArrangedSubview(actorImageView)
        actorsStackView.addArrangedSubview(actorInfoStackView)
        
        actorInfoStackView.addArrangedSubview(actorNameLabel)
        actorInfoStackView.addArrangedSubview(actorRoleLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
