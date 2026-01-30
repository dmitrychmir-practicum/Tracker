//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 13.01.2026.
//

import UIKit

final class ColorCollectionView: UICollectionView {
    private let presenter: TrackerEditPresenterProtocol?
    
    // MARK: - Ctor
    
    init(presenter: TrackerEditPresenterProtocol?) {
        self.presenter = presenter
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        updateColors()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func updateColors() {
        self.reloadData()
    }
}

// MARK: - Setup
private extension ColorCollectionView {
    func setupView() {
        self.backgroundColor = .Colors.backgroundView
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(ColorCell.self, forCellWithReuseIdentifier: Constants.colorCellReuseIdentifier)
        self.register(TrackerEditHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.trackerEditHeaderReuseIdentifier)
        self.delegate = self
        self.dataSource = self
        self.allowsMultipleSelection = true
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 222)
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension ColorCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach { cell in
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }

        if let cell = collectionView.cellForItem(at: indexPath) {
            let color = Colors.allCases[indexPath.row].uiColor
            cell.contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        }
        
        guard let presenter else { return }
        presenter.update(color: Colors.allCases[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
        }
        
        guard let presenter else { return }
        presenter.update(color: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: Constants.TrackerEditCollections.heightHeader)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 24, left: Constants.TrackerEditCollections.leftInset, bottom: 0, right: Constants.TrackerEditCollections.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.TrackerEditCollections.cellSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: Constants.TrackerEditCollections.cellWidth, height: Constants.TrackerEditCollections.cellHeight)
    }
}

// MARK: - UICollectionViewDataSource
extension ColorCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Colors.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.colorCellReuseIdentifier, for: indexPath) as? ColorCell else {
            fatalError("Не удалось создать ячейку")
        }
        
        cell.color = Colors.allCases[indexPath.item].uiColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.trackerEditHeaderReuseIdentifier, for: indexPath) as? TrackerEditHeaderCell else {
            fatalError("Не удалось переиспользовать TrackerEditHeaderCell")
        }
        
        header.configureCell(title: Constants.colorCollectionTitle)
        return header
    }
}
