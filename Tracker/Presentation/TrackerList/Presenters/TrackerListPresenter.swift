//
//  TrackerListPresenter.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class TrackerListPresenter: TrackerListPresenterProtocol {
    
    var view: TrackerListViewProtocol?
    
    private var trackerService: TrackerServiceProtocol?
    private var observerCategoryInserted: NSObjectProtocol?
    private var observerRecordInserted: NSObjectProtocol?
    private(set) var categories: [TrackerCategory] = []
    private(set) var trackerRecords: [TrackerRecord] = []
    private var datePicker: UIDatePicker?
    
    
    // MARK: - Ctor
    init(trackerService: TrackerServiceProtocol? = TrackerService.shared) {
        self.trackerService = trackerService
        setObserverCategoryInserted()
        setObserverRecordInserted()
    }
    
    @MainActor
    deinit {
        unsetObserverCategoryInserted()
        unsetObserverRecordInserted()
    }
    
    func viewDidLoad() {
        self.datePicker = view?.topNavigationBar.datePicker
    }
    
    func configure() {
        toggleImageAndCollection()
    }
    
    func updateCollectionView() {
        toggleImageAndCollection()
        guard let collectionView = view?.trackerCollectionView else { return }
        collectionView.reloadData()
    }
    
    func addNewTracker() {
        let controller = TrackerSelectTypeViewController()
        controller.modalPresentationStyle = .pageSheet
        view?.showSelectTypeView(controller: controller)
    }
    
    func changeDate() {
        guard let datePicker, let trackerService else { return }
        categories = trackerService.getCategoriesByDate(datePicker.date)
        trackerRecords = trackerService.getRecordsByDate(date: datePicker.date)
        toggleImageAndCollection()
        updateCollectionView()
    }
    
    private func toggleImageAndCollection() {
        if categories.isEmpty {
            view?.imageView.isHidden = false
            view?.trackerCollectionView.isHidden = true
        } else {
            view?.imageView.isHidden = true
            view?.trackerCollectionView.isHidden = false
        }
    }
    
    func pressCheckButton(tracker: Tracker) {
        trackerService?.toggleCheckTracker(tracker, date: datePicker?.date ?? Date.now)
        //updateCollectionView()
    }
    
    func getTotalFinishedCountByTracker(_ tracker: Tracker) -> Int {
        return trackerService?.getAllRecordsByTracker(tracker).count ?? 0
    }
}

// MARK: - Observers
private extension TrackerListPresenter {
    // Подписываемся на изминение списка категорий
    func setObserverCategoryInserted() {
        observerCategoryInserted = NotificationCenter.default.addObserver(
            forName: TrackerService.didCategoryInsertedNotification, object: nil, queue: .main) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self,
                      let trackerService = self.trackerService,
                      let date = self.datePicker?.date
                else { return }
                // получаем обновлённый список для выбранной даты
                self.categories = trackerService.getCategoriesByDate(date)
                self.updateCollectionView()
            }
        }
    }
    
    func unsetObserverCategoryInserted() {
        guard let observerCategoryInserted else { return }
        
        NotificationCenter.default.removeObserver(observerCategoryInserted)
    }
    
    func setObserverRecordInserted() {
        observerRecordInserted = NotificationCenter.default.addObserver(
            forName: TrackerService.didRecordInsertedNotification, object: nil, queue: .main) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self,
                        let trackerService = self.trackerService,
                        let date = self.datePicker?.date else { return }
                    
                self.trackerRecords = trackerService.getRecordsByDate(date: date)
                self.updateCollectionView()
            }
        }
    }
    
    func unsetObserverRecordInserted() {
        guard let observerRecordInserted else { return }
        
        NotificationCenter.default.removeObserver(observerRecordInserted)
    }
}
