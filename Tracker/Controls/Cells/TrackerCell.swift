//
//  TrackerCell.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class TrackerCell: UICollectionViewCell {
    private let container = UIView()
    private let card = UIView()
    private let cardEmoji = UILabel()
    private let cardTitle = UILabel()
    private let daysTotalLabel = UILabel()
    private let checkButton = UIButton()
    private var tracker: Tracker?
    private var daysCount: Int = 0
    private var isCheckToDay: Bool = false
    private var action: UIAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configureCell(tracker: Tracker, daysTotal count: Int, isCheckToDay: Bool, action: UIAction)
    {
        self.tracker = tracker
        self.daysCount = count
        self.isCheckToDay = isCheckToDay
        self.action = action
        
        setupCell()
    }
}

// MARK: - Setup
private extension TrackerCell {
    func setupCell() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 148),
            contentView.widthAnchor.constraint(equalToConstant: 167),
        ])
        
        setupContainer()
        setupCard()
        setupCardEmoji()
        setupCardTitle()
        setupDaysTotalLabel()
        setupCheckButton()
    }
    
    func setupContainer() {
        container.backgroundColor = .clear
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func setupCard() {
        card.translatesAutoresizingMaskIntoConstraints = false
        card.layer.cornerRadius = 16
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.Colors.trackerCellBorder.cgColor
        card.backgroundColor = tracker?.color.uiColor
        container.addSubview(card)
        
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            card.topAnchor.constraint(equalTo: container.topAnchor),
            card.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            card.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    func setupCardEmoji() {
        cardEmoji.translatesAutoresizingMaskIntoConstraints = false
        cardEmoji.text = tracker?.emoji.rawValue
        cardEmoji.backgroundColor = .Colors.emojiBackground
        cardEmoji.layer.cornerRadius = 12
        cardEmoji.layer.masksToBounds = true
        cardEmoji.textAlignment = .center
        cardEmoji.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        card.addSubview(cardEmoji)
        
        NSLayoutConstraint.activate([
            cardEmoji.heightAnchor.constraint(equalToConstant: 24),
            cardEmoji.widthAnchor.constraint(equalToConstant: 24),
            cardEmoji.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            cardEmoji.topAnchor.constraint(equalTo: card.topAnchor, constant: 12)
        ])
    }
    
    func setupCardTitle() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        
        cardTitle.translatesAutoresizingMaskIntoConstraints = false
        cardTitle.text = tracker?.name
        cardTitle.numberOfLines = 3
        cardTitle.lineBreakMode = .byWordWrapping
        cardTitle.textColor = .white
        cardTitle.font = .systemFont(ofSize: 12, weight: .medium)
        stack.addSubview(cardTitle)
        
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalToConstant: 34),
            stack.widthAnchor.constraint(equalToConstant: 143),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            cardTitle.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
            cardTitle.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            cardTitle.widthAnchor.constraint(equalToConstant: 143)
        ])
    }
    
    func setupDaysTotalLabel() {
        daysTotalLabel.translatesAutoresizingMaskIntoConstraints = false
        daysTotalLabel.text = "\(daysCount) \(daysCount.dayString())"
        daysTotalLabel.textColor = .Colors.text
        daysTotalLabel.font = .systemFont(ofSize: 12, weight: .medium)
        container.addSubview(daysTotalLabel)
        
        NSLayoutConstraint.activate([
            daysTotalLabel.heightAnchor.constraint(equalToConstant: 18),
            daysTotalLabel.widthAnchor.constraint(equalToConstant: 101),
            daysTotalLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            daysTotalLabel.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 16)
        ])
    }
    
    func setupCheckButton() {
        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.layer.cornerRadius = 16
        checkButton.backgroundColor = .Colors.checkButtonBackground
        checkButton.layer.opacity = isCheckToDay ? 0.3 : 1
        checkButton.tintColor = .Colors.buttonDefaultText
        if isCheckToDay {
            checkButton.setImage(Constants.checkButtonTrackerCellCheckmark, for: .normal)
        } else {
            checkButton.setImage(Constants.checkButtonTrackerCellPlus, for: .normal)
        }
        container.addSubview(checkButton)
        
        NSLayoutConstraint.activate([
            checkButton.heightAnchor.constraint(equalToConstant: 34),
            checkButton.widthAnchor.constraint(equalToConstant: 34),
            checkButton.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 8),
            checkButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
        ])
        
        guard let action else { return }
            
        checkButton.addAction(action, for: .touchUpInside)
    }
}

private extension Int {
    func dayString() -> String {
        if self % 10 == 1 { return "день" }
        if self % 10 >= 2 && self % 10 <= 4 { return "дня" }
        if self % 100 >= 11 && self % 100 <= 20 { return "дней" }
        return "дней"
    }
}
