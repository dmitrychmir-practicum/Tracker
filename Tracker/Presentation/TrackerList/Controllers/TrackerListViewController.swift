//
//  TrackerListViewController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

final class TrackerListViewController: UIViewController, TrackerListViewProtocol {
    var presenter: TrackerListPresenterProtocol?
    private(set) var topNavigationBar = NavigationBar()
    private(set) var trackerCollectionView: TrackerCollectionView = TrackerCollectionView()
    private(set) var imageView: StarImageView
    
    // MARK: - Ctor
    
    init() {
        imageView = StarImageView(labelText: Constants.starImageLabelInTrackerList)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Config
    
    func configure(_ presenter: TrackerListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.viewDidLoad()
    }
    
    func showSelectTypeView(controller: UIViewController) {
        present(controller, animated: true)
    }
}

// MARK: - Setup functions
private extension TrackerListViewController {
    func setupView() {
        view.backgroundColor = .Colors.backgroundView
        setupTopBar()
        setupImageView()
        setupCollectionView()
        presenter?.configure()
    }
    
    func setupTopBar() {
        view.addSubview(topNavigationBar)
        
        NSLayoutConstraint.activate([
            topNavigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        topNavigationBar.addButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter?.addNewTracker()
        }), for: .touchUpInside)
        topNavigationBar.datePicker.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter?.changeDate()
        }), for: .valueChanged)
    }
    
    func setupImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topNavigationBar.bottomAnchor,constant: 220),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupCollectionView() {
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
        view.addSubview(trackerCollectionView)
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: topNavigationBar.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        .init(width: collectionView.frame.width, height: Constants.CollectionView.heightCategory)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.CollectionView.leftInset, bottom: 0, right: Constants.CollectionView.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView,
            layout collectionViewLayout: UICollectionViewLayout,
            sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let widthCollection = collectionView.frame.width
        let withCells = widthCollection - Constants.CollectionView.leftInset - Constants.CollectionView.rightInset - Constants.CollectionView.cellSpacing
        return CGSize(width: Int(withCells) / Constants.CollectionView.cellCount, height: Constants.CollectionView.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.CollectionView.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let tracker = self.presenter?.categories[indexPath.section].trackers[indexPath.row] else { return }
        
        self.presenter?.pressCheckButton(tracker: tracker)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let tracker = self.presenter?.categories[indexPath.section].trackers[indexPath.row] else { return }
        
        self.presenter?.pressCheckButton(tracker: tracker)
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let presenter = self.presenter, !presenter.categories.isEmpty else { return 0 }
        
        return presenter.categories[section].trackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let presenter = self.presenter else { return 0 }
        
        return presenter.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.trackerListCellReuseIdentifier, for: indexPath) as? TrackerCell else {
            fatalError("Не удалось создать ячейку")
        }
        
        guard let tracker = self.presenter?.categories[indexPath.section].trackers[indexPath.row], let presenter else { return cell }
        let totalCountDays = presenter.getTotalFinishedCountByTracker(tracker)
        let isCheckToDay = presenter.trackerRecords.contains(where: {$0.trackerId == tracker.id})
        cell.configureCell(tracker: tracker, daysTotal: totalCountDays, isCheckToDay: isCheckToDay)
        cell.isSelected = isCheckToDay
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: Constants.headerReuseIdentifier,
            for: indexPath
        ) as? HeaderCell else {
            fatalError("Не удалось переиспользовать HeaderCell")
        }
        header.configureCell(title: self.presenter?.categories[indexPath.section].title ?? "")
        return header
    }
}
