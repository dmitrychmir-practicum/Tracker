//
//  TrackerCategoryMap+Extension.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 23.01.2026.
//

import CoreData

extension TrackerCategory {
    func mapToEntity() -> TrackerCategoryCD {
        let trackerDataService = TrackerDataService.shared
        let entity = trackerDataService.createCategory()
        entity.title = title
        
        return entity
    }
}

extension TrackerCategoryCD {
    func mapToModel() -> TrackerCategory {
        
        var trackers: [Tracker] = []
        
        if let trackersCD = self.trackers as? Set<TrackerCD> {
            trackersCD.forEach {
                trackers.append($0.mapToModel())
            }
        }
        let category = TrackerCategory(title: title ?? "", trackers: trackers)
        
        return category
    }
}
