//
//  EmojiCell.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 13.01.2026.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    private let label = UILabel()
    private var emojiBackground: UIColor = .clear {
        didSet {
            label.backgroundColor = emojiBackground
        }
    }
    
    // MARK: - Ctor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func configureCell(_ emoji: String, backgroundColor: UIColor = .clear) {
        label.text = emoji
        emojiBackground = backgroundColor
    }
}

private extension EmojiCell {
    func setupView() {
        contentView.layer.cornerRadius = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 31)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.widthAnchor.constraint(equalToConstant: 32),
            label.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
}
