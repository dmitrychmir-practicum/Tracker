//
//  StarImageView.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

final class StarImageView: UIView {
    private let imageView = UIImageView()
    private let label = UILabel()
    
    // MARK: - Ctor
    init(labelText: String) {
        label.text = labelText
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension StarImageView {
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupImage()
        setupLabel()
        setupConstraints()
    }
    
    func setupImage() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .Images.noTrackers)
        self.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func setupLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .Colors.text
        label.textAlignment = .center
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18),
            label.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
}
