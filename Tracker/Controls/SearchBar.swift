//
//  SearchBar.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class SearchBar: UISearchBar {
    init() {
        super.init(frame: .infinite)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.searchBarStyle = .minimal
        self.placeholder = Constants.searchBarPlaceholder
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
}
