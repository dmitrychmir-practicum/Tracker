//
//  CustomTextField.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

final class CustomTextField: UIView {
    let nameTextField = UITextField()
    let warningLabel = WarningLabels.maxNameLength.label
    private let presenter: TrackerEditPresenterProtocol?
    private var isShowWarning: Bool = false
    
    init(presenter: TrackerEditPresenterProtocol?) {
        self.presenter = presenter
        
        super.init(frame: .zero)
        nameTextField.delegate = self
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
private extension CustomTextField {
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.backgroundColor = .Colors.tableCellBackground
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.textColor = .Colors.text
        nameTextField.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        
        self.backgroundColor = .clear
        
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: Constants.trackerNamePlaceholder,
            attributes: [.foregroundColor: UIColor(resource: .Colors.textSubtitle),
                         .backgroundColor: UIColor(resource: .Colors.tableCellBackground)])

        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftViewMode = .always
        self.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            //self.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            nameTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func toggleWarningMessage(_ isOn: Bool) {
        if isOn { //Показать предупреждение
            if !isShowWarning {
                self.addSubview(warningLabel)
                presenter?.toogleShowWarning(isOn: true)
                NSLayoutConstraint.activate([
                    warningLabel.heightAnchor.constraint(equalToConstant: 22),
                    warningLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
                    warningLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    warningLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
                
                isShowWarning = true
            }
        } else { //Скрыть предупреждение
            if isShowWarning {
                warningLabel.removeFromSuperview()
                presenter?.toogleShowWarning(isOn: false)
                isShowWarning = false
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text, name != "" else {
            presenter?.update(name: nil)
            return
        }
        
        presenter?.update(name: name)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.toggleWarningMessage(false)
        presenter?.update(name: nil)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentText = textField.text,
              let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        handleCharacterLimit(for: updatedText)
        return updatedText.count <= 38
    }
    
    private func handleCharacterLimit(for updatedText: String) {
        toggleWarningMessage(updatedText.count > 38)
    }
}
