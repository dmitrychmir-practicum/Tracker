//
//  ColorCell.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 13.01.2026.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    private let view = UIView()
    var color : UIColor? {
        didSet {
            view.backgroundColor = color
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
}

// MARK: - Setup
private extension ColorCell {
    func setupView() {
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 3
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.addSubview(view)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40),
            view.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
