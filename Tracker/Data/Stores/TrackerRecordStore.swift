//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 23.01.2026.
//

import CoreData

final class TrackerRecordStore {
    private let trackerDataService = TrackerDataService.shared
    
    func insertRecord(_ trackerId: UUID, date: Date) {
        let request: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date = %@", trackerId as CVarArg, date.onlyDate as CVarArg)
        request.fetchLimit = 1
        
        var isNew = false
        do {
            isNew = (try trackerDataService.count(for: request)) == 0
        } catch {
            isNew = true
        }
        
        if isNew {
            let request: NSFetchRequest<TrackerCD> = TrackerCD.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
            
            do {
                if let trackerCD = try trackerDataService.fetch(request).first {
                    let proxy = trackerDataService.createRecord()
                    proxy.date = date.onlyDate
                    proxy.tracker = trackerCD
                    
                    trackerDataService.saveContext()

                    pushRecordStoreChanged()
                }
            } catch {}
        }
    }
    
    func deleteRecord(_ tracker: Tracker, date: Date) {
        let request: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date = %@", tracker.id as CVarArg, date.onlyDate as CVarArg)
        
        do {
            if let record = try trackerDataService.fetch(request).first {
                trackerDataService.delete(record)
                trackerDataService.saveContext()
                pushRecordStoreChanged()
            }
        } catch {}
    }
    
    func recordExist(_ tracker: Tracker, date: Date) -> Bool {
        let request: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@ AND date = %@", tracker.id as CVarArg, date.onlyDate as CVarArg)
        request.fetchLimit = 1
        
        return (try? trackerDataService.count(for: request)) ?? 0 > 0
    }
    
    func getAllRecords(for tracker: Tracker? = nil, date: Date? = nil) -> [TrackerRecord] {
        var records : [TrackerRecord] = []
        let request: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        
        if let tracker {
            request.predicate = NSPredicate(format: "tracker.id == %@", tracker.id as CVarArg)
        } else if let date {
            request.predicate = NSPredicate(format: "date == %@", date as CVarArg)
        }
        
        do {
            let fetchedRecords = try trackerDataService.fetch(request)
            for fetchedRecord in fetchedRecords {
                records.append(fetchedRecord.toModel())
            }
        } catch {
            
        }
        
        return records
    }
    
    func getRecordsCountByTrackerID(_ id: UUID) -> Int {
        let request: NSFetchRequest<TrackerRecordCD> = TrackerRecordCD.fetchRequest()
        request.predicate = NSPredicate(format: "tracker.id == %@", id as CVarArg)
        request.resultType = .countResultType
        
        do {
            return try trackerDataService.count(for: request)
        } catch {
            return 0
        }
    }
}

// MARK: - Privates
private extension TrackerRecordStore {
    func pushRecordStoreChanged() {
        let records = getAllRecords()
        NotificationCenter.default.post(name: Constants.didRecordStoreChanged, object: records)
    }
}
