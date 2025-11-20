//
//  TrackerListViewController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 20.11.2025.
//

import UIKit

final class TrackerListViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup functions
    
    private func setupView() {
        setupNavigationBar()
        setupTitle()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTracker))
//        let datePickButton = UIButton(type: .system)
//        datePickButton.backgroundColor = .Colors.datePickerButtonBackground
//        datePickButton.configuration = .filled()
//        datePickButton.layer.cornerRadius = 8
//        datePickButton.layer.masksToBounds = true
//        datePickButton.setTitle("21.11.25", for: .normal)
//        datePickButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
//        datePickButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        let rightBarButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 77, height: 34))
//        rightBarButtonView.addSubview(datePickButton)
//        
//        datePickButton.widthAnchor.constraint(equalToConstant: 77).isActive = true
//        datePickButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
//        
//        let rightBarButton = UIBarButtonItem(customView: rightBarButtonView)
//
//        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupTitle() {
        let title = UILabel()
        title.text = TrackerConstants.trackersListTitle
        title.textColor = .Colors.foregroundText
        title.font = UIFont.systemFont(ofSize: 31, weight: .bold)
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            title.heightAnchor.constraint(equalToConstant: 41),
            title.widthAnchor.constraint(equalToConstant: 254)
            
        ])
    }
    
    // MARK: - Actions
    
    @objc func addNewTracker() {
        
    }
}
