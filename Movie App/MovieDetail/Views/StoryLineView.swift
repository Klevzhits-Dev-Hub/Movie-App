//
//  StoryLineView.swift
//  Movie App
//
//  Created by Artem Kriukov on 02.04.2025.
//

import UIKit

final class StoryLineView: UIView {
    
    // MARK: - Properties
    private let collapsedLines: Int
    private var isExpanded = false
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Story Line"
        label.font = UIFont(name: Fonts.PlusJakartaSans.semiBold.rawValue, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = collapsedLines
        label.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 14)
        label.textColor = UIColor(named: "GrayText")
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show More", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 14)
        button.setTitleColor(UIColor(named: "SelectedColor"), for: .normal)
        button.addTarget(self, action: #selector(toggleText), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, showMoreButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Initialization
    init(collapsedLines: Int = 6) {
        self.collapsedLines = collapsedLines
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            showMoreButton.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleText))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleText() {
        isExpanded.toggle()
        updateUI()
    }
    
    private func updateUI() {
        descriptionLabel.numberOfLines = isExpanded ? 0 : collapsedLines
        showMoreButton.setTitle(isExpanded ? "Show Less" : "Show More", for: .normal)
    }
}
