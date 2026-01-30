//
//  TrackerServiceProtocol.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import Foundation

protocol TrackerServiceProtocol {
    func loadData()
    
    func insertCategory(_ category: TrackerCategory)
    func updateCategory(_ category: TrackerCategory)
    func getCategoryByIndex(_ index: Int) -> TrackerCategory?
    func getCategoryByTitle(_ title: String) -> TrackerCategory?
    func getAllCategories(schedule day: Schedule?) -> [TrackerCategory]
    func getCategoriesByDate(_ date: Date) -> [TrackerCategory]
    
    func trackersExist(schedule day: Schedule) -> Bool
    func insertTracker(_ categoryTitle: String, tracker: Tracker)
    func insertTracker(_ categoryIndex: Int, tracker: Tracker)
    
    func checkTracker(_ tracker: Tracker, date: Date)
    func uncheckTracker(_ tracker: Tracker, date: Date)
    func toggleCheckTracker(_ tracker: Tracker, date: Date)
    func recordExist(_ tracker: Tracker, date: Date) -> Bool
    func getRecordsByDate(date: Date) -> [TrackerRecord]
    func getAllRecordsByTracker(_ tracker: Tracker) -> [TrackerRecord]
}
