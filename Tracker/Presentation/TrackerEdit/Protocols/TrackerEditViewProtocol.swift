//
//  TrackerEditViewProtocol.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

protocol TrackerEditViewProtocol: AnyObject {
    var presenter: TrackerEditPresenterProtocol? { get set }
    var trackerType: TrackerType { get }
    var table: UITableView { get }
    var nameField: CustomTextField { get }
    var nameFieldHeightConstraint: NSLayoutConstraint? { get set }
    var scrollView: UIScrollView { get }
    
    func toggleCreateButtonEnable(_ isEnable: Bool)
}
