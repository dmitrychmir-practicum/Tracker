//
//  TrackerCoreDataService.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 14.01.2026.
//

import UIKit

final class TrackerCoreDataService {
    static let shared: TrackerServiceProtocol = TrackerCoreDataService()
    
    private var categories: [TrackerCategory] = []
    private var trackerRecords: [TrackerRecord] = []
    private var observerCategoryStoreChanged: NSObjectProtocol?
    private var observerRecordStoreChanged: NSObjectProtocol?
    
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore()
    
    private let queue = DispatchQueue(label: "tracker.service.queue", attributes: .concurrent)

    // MARK: - Ctor
    
    private init () {
        setCategoryObserver()
        setRecordsObserver()
    }
    
    @MainActor
    deinit {
        unsetCategoryObserver()
        unsetRecordsObserver()
    }
}

extension TrackerCoreDataService: TrackerServiceProtocol {
    func loadData() {
        queue.async(flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.categories = self.trackerCategoryStore.getAllCategories()
                if self.categories.isEmpty {
                    self.categories.append(TrackerCategory(title: Constants.defaultTrackerCategoryTitle, trackers: []))
                }
                self.trackerRecords = self.trackerRecordStore.getAllRecords()
                self.pushCategoriesNotification(self.categories)
                self.pushRecordsNotification(self.trackerRecords)
            }
        }
    }
    
    // MARK: - Categories
    
    func insertCategory(_ category: TrackerCategory) {
        queue.async(flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.trackerCategoryStore.insertCategory(title: category.title)
            }
        }
    }
    
    func updateCategory(_ category: TrackerCategory) {
        queue.async(flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                self.trackerCategoryStore.updateCategory(category)
            }
        }
    }
    
    func getCategoryByIndex(_ index: Int) -> TrackerCategory? {
        guard !categories.isEmpty && (index >= 0 && index < categories.count) else { return nil }
        
        return categories[index]
    }
    
    func getCategoryByTitle(_ title: String) -> TrackerCategory? {
        guard let category = categories.first(where: {$0.title == title}) else { return nil }
        
        return category
    }
    
    func getAllCategories(schedule day: Schedule?) -> [TrackerCategory] {
        guard let day else { return categories }
        
        return queue.sync {
            return categories.compactMap{ category in
                let filtred = category.trackers.filter { tracker in
                    guard let schedule = tracker.schedule, !schedule.isEmpty else {
                        let complited = trackerRecords.contains { record in
                            record.trackerId == tracker.id
                        }
                        return !complited
                    }
                    
                    return schedule.contains(day)
                }
                return filtred.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filtred)
            }
        }
    }
    
    func getCategoriesByDate(_ date: Date) -> [TrackerCategory] {
        let day = Schedule.dayOfWeek(for: date)
        return queue.sync {
            return categories.compactMap{ category in
                let filtred = category.trackers.filter { tracker in
                    let schedule = tracker.schedule ?? []
                    
                    if schedule.isEmpty {
                        if recordExist(tracker, date: date) {
                            return true
                        } else {
                            return !trackerRecords.contains { record in
                                return record.trackerId == tracker.id
                            }
                        }
                    } else {
                        return schedule.contains(day)
                    }
                }
                return filtred.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filtred)
            }
        }
    }
    
    // MARK: - Trackers
    
    func trackersExist(schedule day: Schedule) -> Bool {
        queue.sync {
            return categories.contains { category in
                category.trackers.contains { tracker in
                    guard let schedule = tracker.schedule, !schedule.isEmpty else {
                        let complited = trackerRecords.contains { record in
                            record.trackerId == tracker.id
                        }
                        return !complited
                    }
                    
                    return schedule.contains(day)
                }
            }
        }
    }
    
    func insertTracker(_ categoryTitle: String, tracker: Tracker) {
        if let idx = categories.firstIndex(where: {$0.title == categoryTitle}) {
            insertTracker(idx, tracker: tracker)
        } else {
            insertCategory(TrackerCategory(title: categoryTitle, trackers: [tracker]))
        }
    }
    
    func insertTracker(_ categoryIndex: Int, tracker: Tracker) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                var trackers = self.categories[categoryIndex].trackers
                let categoryTitle = self.categories[categoryIndex].title
                trackers.append(tracker)
                let category = TrackerCategory(title: categoryTitle, trackers: trackers)
                self.updateCategory(category)
            }
        }
    }
    
    func checkTracker(_ tracker: Tracker, date: Date) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                if !self.recordExist(tracker, date: date) {
                    self.trackerRecordStore.insertRecord(tracker.id, date: date)
                }
            }
        }
    }
    
    func uncheckTracker(_ tracker: Tracker, date: Date) {
        queue.async(flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                guard let self else { return }
                if self.recordExist(tracker, date: date) {
                    self.trackerRecordStore.deleteRecord(tracker, date: date)
                }
            }
        }
    }
    
    func toggleCheckTracker(_ tracker: Tracker, date: Date) {
        if (recordExist(tracker, date: date)) {
            uncheckTracker(tracker, date: date)
        } else {
            checkTracker(tracker, date: date)
        }
    }
    
    func recordExist(_ tracker: Tracker, date: Date) -> Bool {
        return trackerRecords.contains { $0.trackerId == tracker.id &&
            Calendar.current.isDate($0.date.localDate().onlyDate, inSameDayAs: date.localDate().onlyDate) }
    }
    
    func getRecordsByDate(date: Date) -> [TrackerRecord] {
        trackerRecords.filter {
            Calendar.current.isDate($0.date.localDate().onlyDate, inSameDayAs: date.localDate().onlyDate)
        }
    }
    
    func getAllRecordsByTracker(_ tracker: Tracker) -> [TrackerRecord] {
        trackerRecords.filter {
            $0.trackerId == tracker.id
        }
    }
}

// MARK: - Private methods
private extension TrackerCoreDataService {
    func setCategoryObserver() {
        observerCategoryStoreChanged = NotificationCenter.default.addObserver(
            forName: TrackerCategoryStore.didCategoryStoreChanged, object: nil, queue: .main) { [weak self] notification in
                let categories = notification.object as? [TrackerCategory] ?? []
                DispatchQueue.main.async {
                    self?.categories = categories
                    self?.pushCategoriesNotification(categories)
            }
        }
    }
    
    func unsetCategoryObserver() {
        guard let observerCategoryStoreChanged else { return }
        
        NotificationCenter.default.removeObserver(observerCategoryStoreChanged)
    }
    
    func setRecordsObserver() {
        observerRecordStoreChanged = NotificationCenter.default.addObserver(
            forName: Constants.didRecordStoreChanged, object: nil, queue: .main) { [weak self] notification in
                let records = notification.object as? [TrackerRecord] ?? []
                DispatchQueue.main.async {
                    self?.trackerRecords = records
                    self?.pushRecordsNotification(records)
                }
            }
    }
    
    func unsetRecordsObserver() {
        guard let observerRecordStoreChanged else { return }
        
        NotificationCenter.default.removeObserver(observerRecordStoreChanged)
    }
    
    func pushCategoriesNotification(_ categories: [TrackerCategory]) {
        NotificationCenter.default.post(name: Constants.didCategoryInsertedNotification, object: categories)
    }

    func pushRecordsNotification(_ records: [TrackerRecord]) {
        NotificationCenter.default.post(name: Constants.didRecordInsertedNotification, object: records)
    }
}
