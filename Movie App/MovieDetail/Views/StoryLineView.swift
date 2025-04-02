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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
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
        self.fullText = description
        updateTextDisplay()
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
        ])
    }
    
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        isExpanded.toggle()
        updateTextDisplay()
    }
    
    private func updateTextDisplay() {
        if isExpanded {
            showFullText()
        } else {
            showCollapsedTextWithButton()
        }
    }
    
    
    private func showFullText() {
        descriptionLabel.numberOfLines = 0
        let trailing = TrailingContent.readless
        let fullString = fullText + trailing.text
        
        let attributedString = NSMutableAttributedString(string: fullString)
        let range = NSRange(location: fullText.count, length: trailing.text.count)
        attributedString.addAttribute(.foregroundColor, value: trailing.color, range: range)
        
        descriptionLabel.attributedText = attributedString
    }
    
    private func showCollapsedTextWithButton() {
        descriptionLabel.numberOfLines = collapsedLines
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let label = self.descriptionLabel
            let trailing = TrailingContent.readmore
            let font = label.font ?? UIFont.systemFont(ofSize: 14)
            
            let truncatedText = self.truncateText(
                text: self.fullText,
                maxWidth: label.bounds.width,
                font: font,
                maxLines: self.collapsedLines,
                trailingText: trailing.text
            )
            
            let attributedString = NSMutableAttributedString(string: truncatedText)
            if let range = truncatedText.range(of: trailing.text) {
                let nsRange = NSRange(range, in: truncatedText)
                attributedString.addAttribute(.foregroundColor, value: trailing.color, range: nsRange)
            }
            
            self.descriptionLabel.attributedText = attributedString
        }
    }
    
    private func truncateText(text: String, maxWidth: CGFloat, font: UIFont, maxLines: Int, trailingText: String) -> String {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        var truncatedText = ""
        var currentLineCount = 1
        
        for word in words {
            let testText = truncatedText.isEmpty ? word : "\(truncatedText) \(word)"
            let testWidth = testText.width(withConstrainedHeight: .greatestFiniteMagnitude, font: font)
            
            if testWidth > maxWidth || currentLineCount >= maxLines {
                if currentLineCount < maxLines {
                    truncatedText += "\n\(word)"
                    currentLineCount += 1
                } else {
                    let withTrailing = "\(truncatedText)\(trailingText)"
                    if withTrailing.width(withConstrainedHeight: .greatestFiniteMagnitude, font: font) <= maxWidth {
                        return withTrailing
                    }
                    break
                }
            } else {
                truncatedText = truncatedText.isEmpty ? word : "\(truncatedText) \(word)"
            }
        }
        
        return "\(truncatedText)\(trailingText)"
    }
}
