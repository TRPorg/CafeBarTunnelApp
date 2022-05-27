//
//  SelectTimeIntervalAlert.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 06.05.2022.
//

import UIKit

final class SelectTimeIntervalAlert: BaseAlert {

    var dateAction: ((Date,Date) -> Void)?

    private let alertAreaView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.date = Date()
        picker.datePickerMode = .dateAndTime
        return picker
    }()

    private let fromDateTextField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 4
        field.placeholder = "С какого"
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 20)
        return field
    }()

    private let toDateTextField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.cornerRadius = 4
        field.placeholder = "По какое"
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 20)
        return field
    }()



    private let makeReportButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitle(" Сформировать ", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private var fromDate = Date()
    private var toDate = Date()

    init() {
        super.init(frame: .zero)
        setUpLayout()
        setUpActions()
        createToolbar()
    }

    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        let doneButton = UIBarButtonItem(title: "Применить", style: .plain, target: nil, action:  #selector(dateset))
        toolbar.setItems([doneButton], animated: false)
        fromDateTextField.inputAccessoryView = toolbar
        fromDateTextField.inputView = datePicker
        toDateTextField.inputAccessoryView = toolbar
        toDateTextField.inputView = datePicker
        datePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)

   }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpActions() {
        makeReportButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    private func setUpLayout() {
        addSubviewsWithoutAutoresizing(alertAreaView)
        alertAreaView.addSubviewsWithoutAutoresizing(fromDateTextField, toDateTextField, makeReportButton)

        NSLayoutConstraint.activate([
            alertAreaView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertAreaView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            fromDateTextField.topAnchor.constraint(equalTo: alertAreaView.topAnchor, constant: 18),
            fromDateTextField.leftAnchor.constraint(equalTo: alertAreaView.leftAnchor, constant: 18),
            fromDateTextField.rightAnchor.constraint(equalTo: alertAreaView.rightAnchor, constant: -18),


            toDateTextField.topAnchor.constraint(equalTo: fromDateTextField.bottomAnchor, constant: 18),
            toDateTextField.leftAnchor.constraint(equalTo: alertAreaView.leftAnchor, constant: 18),
            toDateTextField.rightAnchor.constraint(equalTo: alertAreaView.rightAnchor, constant: -18),

            makeReportButton.topAnchor.constraint(equalTo: toDateTextField.bottomAnchor, constant: 18),
            makeReportButton.leftAnchor.constraint(equalTo: alertAreaView.leftAnchor, constant: 18),
            makeReportButton.rightAnchor.constraint(equalTo: alertAreaView.rightAnchor, constant: -18),
            makeReportButton.bottomAnchor.constraint(equalTo: alertAreaView.bottomAnchor, constant: -18),
        ])
    }

    @objc private func dateset() {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YY/MM/dd HH:mm:ss"
        let string = dateFormat.string(from: datePicker.date)


        if fromDateTextField.isFirstResponder {
            fromDateTextField.text = string
            fromDate = datePicker.date
        }

        if toDateTextField.isFirstResponder {
            toDateTextField.text = string
            toDate = datePicker.date
        }
        self.endEditing(true)
    }

    @objc private func dismissAlert() {
        AlertManager.shared.dismissAlert()
    }

    @objc
    private func handleTap() {
        dateAction?(fromDate, toDate)
        dismissAlert()
    }
}

extension SelectTimeIntervalAlert: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      let location = touch.location(in: nil)
      if alertAreaView.frame.contains(location) {
          return false
      }
      return true
    }
}

