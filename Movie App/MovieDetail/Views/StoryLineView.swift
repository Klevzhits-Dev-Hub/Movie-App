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
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard isExpandable else { return }
        
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
    }
    
    private func updateTextDisplay() {
        if isExpanded {
            showFullText()
        } else {
            showCollapsedText()
        }
    }
    
    private func showFullText() {
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = fullText
    }
    
    private func showCollapsedText() {
        guard isExpandable else {
            descriptionLabel.numberOfLines = 0
            descriptionLabel.text = fullText
            return
        }
        
        let trailing = TrailingContent.readmore
        let maxLines = self.collapsedLines
        
        // Create full attributed string
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: descriptionLabel.font!]
        )
        
        // Add "Show more" at the end
        let readMoreString = NSAttributedString(
            string: trailing.text,
            attributes: [.foregroundColor: trailing.color]
        )
        attributedString.append(readMoreString)
        
        // Calculate text container
        let textStorage = NSTextStorage(attributedString: attributedString)
        let textContainer = NSTextContainer(size: CGSize(
            width: descriptionLabel.bounds.width,
            height: .greatestFiniteMagnitude
        ))
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Find the truncation point
        var lineCount = 0
        var index = 0
        var range = NSRange(location: 0, length: 0)
        
        while index < layoutManager.numberOfGlyphs && lineCount < maxLines {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &range)
            index = NSMaxRange(range)
            lineCount += 1
        }
        
        // Create truncated string
        let truncatedString = NSMutableAttributedString()
        if range.location > 0 {
            truncatedString.append(attributedString.attributedSubstring(from: NSRange(location: 0, length: range.location)))
        }
        truncatedString.append(readMoreString)
        
        // Apply to label
        descriptionLabel.numberOfLines = maxLines
        descriptionLabel.attributedText = truncatedString
    }
}
