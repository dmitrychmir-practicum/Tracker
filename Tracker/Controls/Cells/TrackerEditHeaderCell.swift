//
//  TrackerEditHeaderCell.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 14.01.2026.
//

import UIKit

final class TrackerEditHeaderCell: UICollectionReusableView {
    private var titleLabel = UILabel()
    
    func configureCell(title: String) {
        setupCell()
        titleLabel.text = title
    }
}

private extension TrackerEditHeaderCell {
    func setupCell() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 19, weight: .bold)
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
