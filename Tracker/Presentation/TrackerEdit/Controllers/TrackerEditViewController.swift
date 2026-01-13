//
//  TrackerEditViewController.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 12.01.2026.
//

import UIKit

final class TrackerEditViewController: UIViewController, TrackerEditViewProtocol {
    var presenter: TrackerEditPresenterProtocol?
    var nameFieldHeightConstraint: NSLayoutConstraint?

    private(set) var trackerType: TrackerType
    private(set) var table: UITableView
    private(set) var nameField: CustomTextField
    private(set) var scrollView = UIScrollView()
    private var titleLabel: UILabel!
    private let cancelButton = TrackerEditButtons.cancel.button
    private let createButton = TrackerEditButtons.create.button
    private let buttonRows = [Constants.buttonSelectCategory, Constants.buttonSelectSchedule]
    
    // MARK: - Ctor
    init(trackerType: TrackerType, presenter: TrackerEditPresenterProtocol) {
        self.trackerType = trackerType
        self.presenter = presenter
        self.table = Tables.buttons.makeButtonsTable(self.trackerType)
        self.nameField = CustomTextField(presenter: self.presenter)
        super.init(nibName: nil, bundle: nil)
        self.presenter?.view = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        toggleCreateButtonEnable(presenter?.modelIsValid() ?? false)
    }
    
    // MARK: - Protocol
    
    func toggleCreateButtonEnable(_ isEnable: Bool) {
        createButton.isEnabled = isEnable
        if isEnable {
            createButton.layer.borderColor = UIColor(resource: .Colors.buttonDefaultBackground).cgColor
            createButton.backgroundColor = .Colors.buttonDefaultBackground
        } else {
            createButton.layer.borderColor = UIColor(resource: .Colors.buttonDisableBackground).cgColor
            createButton.backgroundColor = .Colors.buttonDisableBackground
        }
    }
}

// MARK: - Setup
private extension TrackerEditViewController {
    func setupView() {
        view.backgroundColor = .Colors.backgroundView
        setupTitle()
        setupCancelButton()
        setupCreateButton()
        setupScrollView()
        setupNameField()
        setupButtonsTable()
        setupGestureRecognizers()
    }
    
    func setupTitle() {
        switch trackerType {
        case .regular:
            titleLabel = TitleLabels.regular.addLabelToView(controller: self)
        case .notRegular:
            titleLabel = TitleLabels.notRegular.addLabelToView(controller: self)
        }
    }
    
    func setupCancelButton() {
        view.addSubview(cancelButton)
        cancelButton.addAction(UIAction(handler: {_ in
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
        ])
    }
    
    func setupCreateButton() {
        view.addSubview(createButton)
        createButton.addAction(UIAction(handler: {_ in
            guard let tracker = self.presenter?.trackerModel?.entity else { return }
            
            self.presenter?.saveTracker(tracker: tracker)
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: createButton.topAnchor)
        ])
    }
    
    func setupNameField() {
        scrollView.addSubview(nameField)
        nameFieldHeightConstraint = nameField.heightAnchor.constraint(equalToConstant: 75)
        nameFieldHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            nameField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            nameField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupButtonsTable() {
        table.delegate = self
        table.dataSource = self
        table.register(ButtonCell.self, forCellReuseIdentifier: Constants.buttonCellReuseIdentifier)
        
        scrollView.addSubview(table)
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 24),
            table.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            table.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITableViewDelegate
extension TrackerEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var viewController: UIViewController

        switch buttonRows[indexPath.row] {
        case Constants.buttonSelectCategory:
            viewController = CategoryViewController()
            break
        case Constants.buttonSelectSchedule:
            viewController = ScheduleViewController(presenter: presenter)
            break
        default:
            fatalError()
        }
        
        viewController.modalPresentationStyle = .pageSheet
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TrackerEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackerType == .regular ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.buttonCellReuseIdentifier, for: indexPath) as? ButtonCell else {
            return UITableViewCell()
        }
        
        switch buttonRows[indexPath.row] {
        case Constants.buttonSelectCategory:
            cell.createCategoryButton(category: presenter?.trackerModel?.category ?? presenter?.trackerService?.getCategoryByIndex(0))
            break
        case Constants.buttonSelectSchedule:
            cell.createScheduleButton(schedule: presenter?.trackerModel?.schedule)
            break
        default :
            break
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
