//
//  TrackerListViewProtocol.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

protocol TrackerListViewProtocol: AnyObject {
    var presenter: TrackerListPresenterProtocol? { get set }
    var trackerCollectionView: TrackerCollectionView { get }
    var imageView: StarImageView { get }
    var topNavigationBar: NavigationBar { get }
    
    func showSelectTypeView(controller: UIViewController)
}
