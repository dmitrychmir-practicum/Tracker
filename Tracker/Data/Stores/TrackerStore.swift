//
//  TrackerStore.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 14.01.2026.
//

import CoreData

final class TrackerStore {
    static let shared = TrackerStore()
    
    private let trackerDataService = TrackerDataService.shared
    private let categoryStore = TrackerCategoryStore.shared
    
    private init() {}
    
    func insertTracker(_ tracker: Tracker, categoryTitle: String) {
        guard let categoryCD = categoryStore.getCategoryByTitle(categoryTitle) else {
            return
        }
        
        let entity = tracker.mapToEntity()
        
        categoryCD.addToTrackers(entity)
        trackerDataService.saveContext()
    }
    
    func deleteTracker(_ tracker: Tracker) {
        guard let trackerCD = getTrackerById(tracker.id) else {
            return
        }
        
        trackerDataService.delete(trackerCD)
    }
    
    func getTrackerById(_ id: UUID) -> TrackerCD? {
        let request: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        return try? trackerDataService.fetch(request).first
    }
}
