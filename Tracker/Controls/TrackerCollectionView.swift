//
//  TrackerCollectionView.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class TrackerCollectionView: UICollectionView {
    
    //MARK: - Ctor
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        updateCategories()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func updateCategories() {
        self.reloadData()
    }
}

// MARK: - Setup
private extension TrackerCollectionView {
    func setupView() {
        self.backgroundColor = .Colors.backgroundView
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(TrackerCell.self, forCellWithReuseIdentifier: Constants.trackerListCellReuseIdentifier)
        self.register(HeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.headerReuseIdentifier)
    }
    
}
