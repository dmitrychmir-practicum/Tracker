//
//  TrackerDataService.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 14.01.2026.
//

import Foundation
import CoreData

final class TrackerDataService {
    static let shared = TrackerDataService()
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "TrackerDB")
        container.loadPersistentStores { _, _ in }
        context = container.newBackgroundContext()
    }
    
    @MainActor
    deinit {
        saveContext()
        cleanDS()
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
            }
        }
    }
    
    func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T : NSFetchRequestResult {
        return try context.fetch(request)
    }
    
    func count<T>(for request: NSFetchRequest<T>) throws -> Int where T : NSFetchRequestResult {
        return try context.count(for: request)
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
    }
    
    func createCategory() -> TrackerCategoryCD {
        return TrackerCategoryCD(context: context)
    }
    
    func createTracker() -> TrackerCD {
        return TrackerCD(context: context)
    }
    
    func createRecord() -> TrackerRecordCD {
        return TrackerRecordCD(context: context)
    }
}

private extension TrackerDataService {
    func cleanDS() {
        context.performAndWait {
            let coordinator = container.persistentStoreCoordinator
            try? coordinator.persistentStores.forEach(coordinator.remove)
        }
    }
}
