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
    private var isExpandable = false
    private var fullText: String = ""
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var readMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.PlusJakartaSans.medium.rawValue, size: 14)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization
    init(collapsedLines: Int = 6) {
        self.collapsedLines = collapsedLines
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(title: String, description: String) {
        titleLabel.text = title
        self.fullText = description
        calculateExpandability()
        updateTextDisplay()
    }
    
    // MARK: - Setup
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(readMoreButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            readMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            readMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            readMoreButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func toggleExpand() {
        isExpanded.toggle()
        UIView.animate(withDuration: 0.3) {
            self.updateTextDisplay()
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Text Display Logic
    private func calculateExpandability() {
        let testLabel = UILabel()
        testLabel.font = descriptionLabel.font
        testLabel.numberOfLines = 0
        testLabel.text = fullText
        
        let maxWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width - 32
        let requiredHeight = testLabel.sizeThatFits(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        ).height
        
        let collapsedHeight = descriptionLabel.font.lineHeight * CGFloat(collapsedLines)
        isExpandable = requiredHeight > collapsedHeight
        readMoreButton.isHidden = !isExpandable
    }
    
    private func updateTextDisplay() {
        if isExpanded {
            showFullText()
        } else {
            showCollapsedText()
        }
        updateReadMoreButton()
    }
    
    private func showFullText() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = fullText
    }
    
    private func showCollapsedText() {
        descriptionLabel.numberOfLines = collapsedLines
        descriptionLabel.text = fullText
    }
    
    private func updateReadMoreButton() {
        readMoreButton.setTitle(isExpanded ? "Show less" : "Show more", for: .normal)
    }
}
