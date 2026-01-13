//
//  Buttons.swift
//  Tracker
//
//  Created by Дмитрий Чмир on 11.01.2026.
//

import UIKit

enum NavigationBarButtons {
    case add
    case date
    
    var button: UIButton {
        if self != .add {
            assertionFailure("Выбран не верный case")
        }
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        switch self {
            case .add:
            button.setImage(UIImage(resource: .Images.plus), for: .normal)
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 42),
                button.heightAnchor.constraint(equalToConstant: 42)
            ])
        default:
            break
        }

        return button
    }
    
    var picker: UIDatePicker {
        if self != .date {
            assertionFailure("Выбран не верный case")
        }
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        switch self {
        case .date:
            let pickerLabel = UILabel()
            datePicker.datePickerMode = .date
            datePicker.locale = Locale(identifier: "ru_RU")
            datePicker.preferredDatePickerStyle = .compact
            datePicker.tintColor = .Colors.datePickerTint
            datePicker.layer.cornerRadius = 8
            datePicker.addAction(UIAction(handler: {sender in
                pickerLabel.text = datePicker.date.datePickerString
            }), for: .valueChanged)
            
            pickerLabel.backgroundColor = .Colors.datePickerBackground
            pickerLabel.textColor = .Colors.datePickerTint
            pickerLabel.text = datePicker.date.datePickerString
            pickerLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            pickerLabel.translatesAutoresizingMaskIntoConstraints = false
            pickerLabel.layer.cornerRadius = 8
            pickerLabel.layer.masksToBounds = true
            pickerLabel.textAlignment = .center
            datePicker.addSubview(pickerLabel)
            
            NSLayoutConstraint.activate([
                datePicker.widthAnchor.constraint(equalToConstant: 77),
                datePicker.heightAnchor.constraint(equalToConstant: 34),
                pickerLabel.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor),
                pickerLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
                pickerLabel.widthAnchor.constraint(equalToConstant: 77),
                pickerLabel.heightAnchor.constraint(equalToConstant: 34)
            ])
        default:
            break
        }
        
        return datePicker
    }
}

enum TrackerEditButtons {
    case create
    case cancel
    case ok
    
    var button: UIButton {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch self {
        case .create:
            button.setTitle(Constants.buttonCreate, for: .normal)
            button.layer.borderColor = UIColor(resource: .Colors.buttonDefaultBackground).cgColor
            button.setTitleColor(.Colors.buttonDefaultText, for: .normal)
            button.backgroundColor = .Colors.buttonDefaultBackground
        case .cancel:
            button.setTitle(Constants.buttonCancel, for: .normal)
            button.layer.borderColor = UIColor(resource: .Colors.ypRed).cgColor
            button.setTitleColor(.Colors.ypRed, for: .normal)
        case .ok:
            button.setTitle(Constants.buttonOk, for: .normal)
            button.layer.borderColor = UIColor(resource: .Colors.buttonDefaultBackground).cgColor
            button.setTitleColor(.Colors.buttonDefaultText, for: .normal)
            button.backgroundColor = .Colors.buttonDefaultBackground
        }
        
        NSLayoutConstraint.activate([button.heightAnchor.constraint(equalToConstant: 60)])
        
        return button
    }
}
