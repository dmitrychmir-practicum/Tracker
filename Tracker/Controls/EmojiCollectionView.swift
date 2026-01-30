//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 13.01.2026.
//

import UIKit

final class EmojiCollectionView: UICollectionView {
    private let presenter: TrackerEditPresenterProtocol?
    
    // MARK: - Ctor
    
    init(presenter: TrackerEditPresenterProtocol?) {
        self.presenter = presenter
        super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        setupView()
        updateEmojis()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    func updateEmojis() {
        self.reloadData()
    }
}

private extension EmojiCollectionView {
    func setupView() {
        self.backgroundColor = .Colors.backgroundView
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(EmojiCell.self, forCellWithReuseIdentifier: Constants.emojiCellReuseIdentifier)
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
extension EmojiCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.visibleCells.forEach {
            $0.contentView.backgroundColor = .clear
        }

        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .Colors.emojiSelectedBackground
        }
        guard let presenter else { return }
        presenter.update(emoji: Emojis.allCases[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }

        guard let presenter else { return }
        presenter.update(emoji: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .init(width: collectionView.frame.width, height: Constants.TrackerEditCollections.heightHeader)
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
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
extension EmojiCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Emojis.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.emojiCellReuseIdentifier, for: indexPath) as? EmojiCell else {
            fatalError("Не удалось создать ячейку")
        }
        
        cell.configureCell(Emojis.allCases[indexPath.row].rawValue)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.trackerEditHeaderReuseIdentifier, for: indexPath) as? TrackerEditHeaderCell else {
            fatalError("Не удалось переиспользовать TrackerEditHeaderCell")
        }
        
        header.configureCell(title: Constants.emojisCollectionTitle)
        return header
    }
}
