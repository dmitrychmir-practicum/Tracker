//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 14.01.2026.
//

import CoreData

final class TrackerCategoryStore {
    private let trackerDataService = TrackerDataService.shared
    static let shared = TrackerCategoryStore()
    
    static let didCategoryStoreChanged: Notification.Name = .init("TrackerCategoryStore.didCategoryStoreChanged")

    private init() {
    }
    
    @discardableResult
    func insertCategory(title: String) -> TrackerCategoryCD? {
        let request: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            if try trackerDataService.fetch(request).first == nil {
                let categoryCD = trackerDataService.createCategory()
                categoryCD.title = title
                
                trackerDataService.saveContext()
                pushCategoriesNotification()
                return categoryCD
            }
        } catch {
            assertionFailure("не удалось добавить категорию в базу данных")
        }
        
        return nil
    }
    
    func updateCategory(_ category: TrackerCategory) {
        guard let categoryCD = getCategoryByTitle(category.title) else {
            return
        }
        
        if let trackers = categoryCD.trackers as? Set<TrackerCD> {
            var ids: [UUID] = []
            trackers.forEach {
                if let id = $0.id {
                    ids.append(id)
                }
            }
            
            category.trackers.forEach {
                if !ids.contains($0.id) {
                    categoryCD.addToTrackers($0.mapToEntity())
                }
            }
            
            trackerDataService.saveContext()
        }

        pushCategoriesNotification()
    }
    
    func getAllCategories() -> [TrackerCategory] {
        let request: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        var result: [TrackerCategory] = []
        
        do {
            let categoriesCD = try trackerDataService.fetch(request)
            categoriesCD.forEach {
                result.append($0.mapToModel())
            }
        } catch {
            return []
        }
        
        return result
    }
    
    func getCategoryByTitle(_ title: String) -> TrackerCategoryCD? {
        let request: NSFetchRequest<TrackerCategoryCD> = TrackerCategoryCD.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        let categoryCD = try? trackerDataService.fetch(request).first ?? insertCategory(title: title)
        
        return categoryCD
    }
}

// MARK: - Privates
private extension TrackerCategoryStore {
    func pushCategoriesNotification(){
        let categories = getAllCategories()
        NotificationCenter.default.post(name: Self.didCategoryStoreChanged, object: categories)
    }
}
