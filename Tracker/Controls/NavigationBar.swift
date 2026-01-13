//
//  NavigationBar.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class NavigationBar: UIView {
    let searchBar = SearchBar()
    let addButton = NavigationBarButtons.add.button
    let datePicker = NavigationBarButtons.date.picker
    private let titleLabel = NavigationBarLabels.title.label
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}

private extension NavigationBar {
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addButton)
        self.addSubview(datePicker)
        self.addSubview(titleLabel)
        self.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            addButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 6),
            datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 44),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 92),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            bottomAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 10)
        ])
    }
}
