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
        DateFormatter.datePickerFormater.string(from: self)
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
    
    static let datePickerFormater: DateFormatter = {
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    } ()
}
