//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import Foundation

extension Date {
    var dateTimeString: String {
        DateFormatter.defaultDateTime.string(from: self)
    }
    var datePickerString: String {
        DateFormatter.datePickerFormatter.string(from: self)
    }
    
    func localDate() -> Date {
            let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: self))
            guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else {return self}
        
            return localDate
        }
    
    var onlyDate: Date {
        let proxy = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: proxy)?.localDate() ?? Date()
    }
}

private extension DateFormatter {
    private static var formatter = DateFormatter()
    
    static let defaultDateTime: DateFormatter = {
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    } ()
    
    static let datePickerFormatter: DateFormatter = {
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    } ()
}
