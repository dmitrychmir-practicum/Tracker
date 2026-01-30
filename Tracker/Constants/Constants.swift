//
//  Constants.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

enum Constants {
    // MARK: - Strings
    static let trackersListTitle: String = "Трекеры"
    static let searchBarPlaceholder: String = "Поиск"
    static let tabBarTrackerItem: String = "Трекеры"
    static let tabBarStatisticsItem: String = "Статистика"
    static let trackerTypeButtonTitleRegular: String = "Привычка"
    static let trackerTypeButtonTitleNotRegular: String = "Нерегулярное событие"
    static let buttonSelectCategory: String = "Категория"
    static let buttonSelectSchedule: String = "Расписание"
    static let colorCollectionTitle: String = "Цвет"
    static let emojisCollectionTitle: String = "Emoji"
    static let buttonCreate: String = "Создать"
    static let buttonCancel: String = "Отменить"
    static let buttonOk: String = "Готово"
    static let trackerNamePlaceholder: String = "Введите название трекера"
    static let defaultTrackerCategoryTitle: String = "Без категории"
    static let starImageLabelInTrackerList: String = "Что будем отслеживать?"
    
    // MARK: - Images
    static let tabBarTrackerItemImage: UIImage = makeImage(named: "record.circle.fill")
    static let tabBarStatisticsItemImage: UIImage = makeImage(named: "hare.fill")
    static let buttonSelectsArrow: UIImage = makeImage(named: "chevron.right")
    static let checkButtonTrackerCellPlus: UIImage = makeImage(named: "plus")
    static let checkButtonTrackerCellCheckmark: UIImage = makeImage(named: "checkmark")
    
    // MARK: - Reusable Identifiers
    static let buttonCellReuseIdentifier = "button.cell.identifier"
    static let scheduleCellReuseIdentifier = "schedule.cell.identifier"
    static let trackerListCellReuseIdentifier = "tracker.list.cell.identifier"
    static let headerReuseIdentifier = "header.identifier"
    static let trackerEditHeaderReuseIdentifier = "tracker.edit.header.identifier"
    static let colorCellReuseIdentifier: String = "color.cell.identifier"
    static let emojiCellReuseIdentifier: String = "emoji.cell.identifier"
    
    static let didCategoryInsertedNotification = Notification.Name("didCategoryInsertedNotification")
    static let didRecordInsertedNotification = Notification.Name("didRecordInsertedNotification")
    static let didRecordStoreChanged = Notification.Name("didRecordStoreChanged")
    
    // MARK: - Constants for collection view
    enum CollectionView {
        static let cellCount: Int = 2
        static let leftInset: CGFloat = 16
        static let rightInset: CGFloat = 16
        static let cellSpacing: CGFloat = 9
        static let cellHeight: Int = 148
        static let heightCategory: CGFloat = 54
    }
    
    enum TrackerEditCollections {
        static let cellCount: Int = 6
        static let leftInset: CGFloat = 18
        static let rightInset: CGFloat = 19
        static let cellSpacing: CGFloat = 5
        static let cellHeight: Int = 52
        static let cellWidth: Int = 52
        static let heightHeader: CGFloat = 18
    }
    
    // MARK: - Magic
    
    static let maxNameSymbols = 38
    
    // MARK: - Private utils
    private static func makeImage(named: String) -> UIImage {
        guard let image = UIImage(systemName: named) else {
            return UIImage()
        }
            
        return image
    }
}
