//
//  TrackerRecord+Extension.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 25.01.2026.
//

extension TrackerRecordCD {
    func toModel() -> TrackerRecord {
        guard let date, let trackerId = tracker?.id else {
            fatalError("Can't create TrackerRecord from TrackerRecordCD")
        }
        return TrackerRecord(trackerId: trackerId, date: date)
    }
}

extension TrackerRecord {
    func toEntity() -> TrackerRecordCD {
        let trackerDataService = TrackerDataService.shared
        let trackerStore = TrackerStore.shared
        let entity = trackerDataService.createRecord()
        entity.date = date
        entity.tracker = trackerStore.getTrackerById(trackerId)
        
        return entity
    }
}
