//
//  TrackerSelectTypeViewController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

final class TrackerSelectTypeViewController: UIViewController {
    // MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

private extension TrackerSelectTypeViewController {
    func setupView() {
        view.backgroundColor = .Colors.backgroundView
        setupTitle()
        setupButtons()
    }
    
    func setupTitle() {
        TitleLabels.typeSelector.addLabelToView(controller: self)
    }
    
    func setupButtons() {
        let regularButton = TrackerType.regular.makeButton(action: UIAction(handler: {_ in
            self.createNewTracker(TrackerType.regular)
        }))
        let notRegularButton = TrackerType.notRegular.makeButton(action: UIAction(handler: {_ in
            self.createNewTracker(TrackerType.notRegular)
        }))
        
        view.addSubview(regularButton)
        view.addSubview(notRegularButton)
        
        NSLayoutConstraint.activate([
            regularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            regularButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            regularButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
            regularButton.heightAnchor.constraint(equalToConstant: 60),
            notRegularButton.leadingAnchor.constraint(equalTo: regularButton.leadingAnchor, constant: 0),
            notRegularButton.trailingAnchor.constraint(equalTo: regularButton.trailingAnchor, constant: 0),
            notRegularButton.topAnchor.constraint(equalTo: regularButton.bottomAnchor, constant: 16),
            notRegularButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

// MARK: - Actions
private extension TrackerSelectTypeViewController {
    func createNewTracker(_ trackerType: TrackerType) {
        let controller = TrackerEditViewController(trackerType: trackerType, presenter: TrackerEditPresenter(trackerService: TrackerCoreDataService.shared))
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true)
    }
}
