//
//  StoryLineView.swift
//  Movie App
//
//  Created by Artem Kriukov on 02.04.2025.
//

import UIKit

final class StoryLineView: UIView {
    
    private let collapsedLines: Int
    private var isExpanded = false
    private var fullText: String = ""
    
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
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
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
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        self.fullText = description
        updateTextDisplay()
    }
    
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
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let text = descriptionLabel.text else { return }
        
        let trailingText = isExpanded ? TrailingContent.readless.text : TrailingContent.readmore.text
        if let range = text.range(of: trailingText) {
            let nsRange = NSRange(range, in: text)
            let location = gesture.location(in: descriptionLabel)
            
            if isTapInRange(location: location, range: nsRange) {
                isExpanded.toggle()
                updateTextDisplay()
            }
        }
    }
    
    private func isTapInRange(location: CGPoint, range: NSRange) -> Bool {
        guard let attributedText = descriptionLabel.attributedText else { return false }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: descriptionLabel.bounds.size)
        let textStorage = NSTextStorage(attributedString: attributedText)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
        let characterIndex = layoutManager.characterIndexForGlyph(at: glyphIndex)
        
        return NSLocationInRange(characterIndex, range)
    }
    
    private func updateTextDisplay() {
        if isExpanded {
            showFullText()
        } else {
            showCollapsedText()
        }
    }
    
    private func showFullText() {
        let trailing = TrailingContent.readless
        let fullString = fullText + trailing.text
        let attributedString = NSMutableAttributedString(string: fullString)
        
        if let range = fullString.range(of: trailing.text) {
            let nsRange = NSRange(range, in: fullString)
            attributedString.addAttribute(.foregroundColor, value: trailing.color, range: nsRange)
        }
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = attributedString
    }
    
    private func showCollapsedText() {
        DispatchQueue.main.async {
            let trailing = TrailingContent.readmore
            let maxLines = self.collapsedLines
            
            let tempLabel = UILabel()
            tempLabel.font = self.descriptionLabel.font
            tempLabel.numberOfLines = maxLines
            tempLabel.lineBreakMode = .byTruncatingTail
            tempLabel.frame.size.width = self.descriptionLabel.bounds.width
            
            let avgCharsPerLine = Int(self.descriptionLabel.bounds.width / 7)
            let maxChars = avgCharsPerLine * maxLines
            
            let truncatedText = String(self.fullText.prefix(maxChars)) + trailing.text
            tempLabel.text = truncatedText
            
            let textSize = tempLabel.sizeThatFits(CGSize(width: tempLabel.bounds.width, height: .greatestFiniteMagnitude))
            let lineHeight = self.descriptionLabel.font.lineHeight
            let maxHeight = lineHeight * CGFloat(maxLines)
            
            let finalText: String
            if textSize.height <= maxHeight {
                finalText = truncatedText
            } else {
                let adjustedChars = Int(Double(maxChars) * 0.9)
                finalText = String(self.fullText.prefix(adjustedChars)) + trailing.text
            }
            
            let attributedString = NSMutableAttributedString(string: finalText)
            if let range = finalText.range(of: trailing.text) {
                let nsRange = NSRange(range, in: finalText)
                attributedString.addAttribute(.foregroundColor, value: trailing.color, range: nsRange)
            }
            
            self.descriptionLabel.numberOfLines = maxLines
            self.descriptionLabel.attributedText = attributedString
        }
    }
}
