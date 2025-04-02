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
    private var fullText: String = ""
    
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
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(collapsedLines: Int = 3) {
        self.collapsedLines = collapsedLines
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(title: String, description: String) {
        titleLabel.text = title
        self.fullText = description
        updateText()
    }
    
    // MARK: - Private Methods
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleButtonTap))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func handleButtonTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: descriptionLabel)
        
        // Проверяем, было ли нажатие на "Read More/Less"
        if let text = descriptionLabel.text,
           let attributedText = descriptionLabel.attributedText,
           let range = text.range(of: isExpanded ? "Read Less" : "Read More") {
            
            let nsRange = NSRange(range, in: text)
            let layoutManager = NSLayoutManager()
            let textContainer = NSTextContainer(size: descriptionLabel.bounds.size)
            let textStorage = NSTextStorage(attributedString: attributedText)
            
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            
            let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
            let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
            
            if NSLocationInRange(characterIndex, nsRange) {
                isExpanded.toggle()
                updateText()
            }
        }
    }
    
    private func updateText() {
        if isExpanded {
            showFullText()
        } else {
            showCollapsedText()
        }
    }
    
    private func showFullText() {
        let text = fullText + " Read Less"
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Read Less")
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = attributedString
    }
    
    private func showCollapsedText() {
        let text = String(fullText.prefix(150)) + "... Read More"
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: "Read More")
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemBlue, range: range)
        
        descriptionLabel.numberOfLines = collapsedLines
        descriptionLabel.attributedText = attributedString
    }
}
