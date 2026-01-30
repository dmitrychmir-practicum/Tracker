//
//  TrackerService.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import Foundation

final class TrackerService {
    static let shared: TrackerServiceProtocol = TrackerService()
    
    private var categories: [TrackerCategory] = []
    private var trackerRecords: [TrackerRecord] = []
    private var observerCategoryInserted: NSObjectProtocol?
    private var observerRecordInserted: NSObjectProtocol?
    
    private let queue = DispatchQueue(label: "tracker.service.queue", attributes: .concurrent)
    
    // MARK: - Ctor
    
    init () {
        setObserverCategoryInserted()
        setObserverRecordInserted()
    }
    
    @MainActor
    deinit {
        unsetObserverCategoryInserted()
        unsetObserverRecordInserted()
    }
}

extension TrackerService: TrackerServiceProtocol {
    
    // MARK: - Loader
    
    func loadData() {
        //TODO: Реализовать загрузку данных из базы
        //      Заготовка на следующий спринт
        categories.append(TrackerCategory(title: Constants.defaultTrackerCategoryTitle, trackers: []))
    }
    
    // MARK: - Categories
    
    //Добавление категории
    func insertCategory(_ category: TrackerCategory) {
        queue.async(flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                var categories = self?.categories ?? []
                categories.append(category)
                self?.pushCategoriesNotification(categories)
            }
        }
    }
    
    //Обновление категории
    func updateCategory(_ category: TrackerCategory) {
        queue.async(flags: .barrier) { [weak self] in
            DispatchQueue.main.async {
                guard var categories = self?.categories, let categoryIdx = categories.firstIndex(where: { $0.title == category.title
                }) else {
                    self?.insertCategory(category)
                    return
                }
                
                categories[categoryIdx] = category
                self?.pushCategoriesNotification(categories)
            }
        }
    }
    
    //Получение категории по индексу в списке
    func getCategoryByIndex(_ index: Int) -> TrackerCategory? {
        guard !categories.isEmpty && (index >= 0 && index < categories.count) else { return nil }
        
        return categories[index]
    }
    
    //Получение категории по заголовку
    func getCategoryByTitle(_ title: String) -> TrackerCategory? {
        guard let category = categories.first(where: {$0.title == title}) else { return nil }
        
        return category
    }
    
    //Получение всех категорий, с фильтрацией по дню, если указан nil возвращается весь список
    func getAllCategories(schedule day: Schedule? = nil) -> [TrackerCategory] {
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
    
    //Получение категорий для даты
    func getCategoriesByDate(_ date: Date) -> [TrackerCategory] {
        let schedule = Schedule.dayOfWeek(for: date)
        
        return getAllCategories(schedule: schedule)
    }
    
    // MARK: - Tracker
    
    //Проверяет, есть ли трекеры на определённый день
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
    
    //Добавляет новый трекер в список
    func insertTracker(_ categoryTitle: String, tracker: Tracker) {
        if let idx = categories.firstIndex(where: {$0.title == categoryTitle}) {
            insertTracker(idx, tracker: tracker)
        } else {
            insertCategory(TrackerCategory(title: categoryTitle, trackers: [tracker]))
        }
    }
    
    //Добавляет новый трекер в список
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
    
    // MARK: - Records
    
    //Установить трекер как выполненый
    func checkTracker(_ tracker: Tracker, date: Date) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                if !self.recordExist(tracker, date: date) {
                    var records = self.trackerRecords
                    let record = TrackerRecord(trackerId: tracker.id, date: date)
                    records.append(record)
                    self.pushRecordsNotification(records)
                }
            }
            
        }
    }
    
    //Убрать выполнение трекера
    func uncheckTracker(_ tracker: Tracker, date: Date) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                if self.recordExist(tracker, date: date) {
                    let didUncheckedRecords = self.trackerRecords.filter { $0.trackerId == tracker.id && Calendar.current.isDate($0.date, inSameDayAs: date)}
                    guard let record = didUncheckedRecords.first else { return }
                    var records =  self.trackerRecords
                    guard let recordIndex = self.trackerRecords.firstIndex(of: record) else { return }
                    records.remove(at: recordIndex)
                    self.pushRecordsNotification(records)
                }
            }
        }
    }
    
    //Переключение состояния выполнения
    func toggleCheckTracker(_ tracker: Tracker, date: Date) {
        if Calendar.current.isDate(date, inSameDayAs: Date.now) {
            if recordExist(tracker, date: date) {
                uncheckTracker(tracker, date: date)
            } else {
                checkTracker(tracker, date: date)
            }
        }
    }
    
    //Проверка помечен ли трекер как выполненый
    func recordExist(_ tracker: Tracker, date: Date) -> Bool {
        return trackerRecords.contains { $0.trackerId == tracker.id &&
            Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    //Получение списка отметок о завершении трекера
    func getRecordsByDate(date: Date) -> [TrackerRecord] {
        return trackerRecords.filter {
            Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    func getAllRecordsByTracker(_ tracker: Tracker) -> [TrackerRecord] {
        return trackerRecords.filter {
            $0.trackerId == tracker.id
        }
    }
}

// MARK: - Observers
private extension TrackerService {
    func setObserverCategoryInserted() {
        observerCategoryInserted = NotificationCenter.default.addObserver(forName: Constants.didCategoryInsertedNotification, object: nil, queue: .main) { [weak self] notification in
            let categories = notification.object as? [TrackerCategory] ?? []
            DispatchQueue.main.async {
                self?.categories = categories
            }
        }
    }
    
    func pushCategoriesNotification(_ categories: [TrackerCategory]) {
        NotificationCenter.default.post(name: Constants.didCategoryInsertedNotification, object: categories)
    }
    
    func unsetObserverCategoryInserted() {
        guard let observerCategoryInserted else { return }
        
        NotificationCenter.default.removeObserver(observerCategoryInserted)
    }
    
    func setObserverRecordInserted() {
        observerRecordInserted = NotificationCenter.default.addObserver(forName: Constants.didRecordInsertedNotification, object: nil, queue: .main) { [weak self] notification in
            let records = notification.object as? [TrackerRecord] ?? []
            DispatchQueue.main.async {
                self?.trackerRecords = records
            }
        }
    }
    
    func pushRecordsNotification(_ records: [TrackerRecord]) {
        NotificationCenter.default.post(name: Constants.didRecordInsertedNotification, object: records)
    }
    
    
    func unsetObserverRecordInserted() {
        guard let observerRecordInserted else { return }
        
        NotificationCenter.default.removeObserver(observerRecordInserted)
    }
}
