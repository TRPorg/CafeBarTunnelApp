//
//  EnterPasswordAlert.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 30.04.2022.
//

import UIKit

final class EnterPasswordAlert: BaseAlert {

    var correctPassword: (() -> Void)?

    var newPassword: ((String) -> Void)?

    private let alertAreaView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let enterPasswordTextField: UITextField = {
        let label = UITextField()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.placeholder = "Пароль"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.black.cgColor
        return label
    }()


    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("Войти", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let password: String?

    init(password: String?) {
        self.password = password
        if password == nil {
            button.setTitle("Сохранить", for: .normal)
        }
        super.init(frame: .zero)
        setUpLayout()
        setUpActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpActions() {
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    private func setUpLayout() {
        addSubviewsWithoutAutoresizing(alertAreaView)
        alertAreaView.addSubviewsWithoutAutoresizing(enterPasswordTextField, button)

        NSLayoutConstraint.activate([
            alertAreaView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertAreaView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertAreaView.widthAnchor.constraint(equalToConstant: 300),
            alertAreaView.heightAnchor.constraint(equalToConstant: 120),

            enterPasswordTextField.topAnchor.constraint(equalTo: alertAreaView.topAnchor, constant: 15),
            enterPasswordTextField.widthAnchor.constraint(equalToConstant: 260),
            enterPasswordTextField.heightAnchor.constraint(equalToConstant: 35),
            enterPasswordTextField.centerXAnchor.constraint(equalTo: alertAreaView.centerXAnchor),

            button.centerXAnchor.constraint(equalTo: alertAreaView.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 260),
            button.bottomAnchor.constraint(equalTo: alertAreaView.bottomAnchor, constant: -19),
        ])
    }

    @objc private func dismissAlert() {
        AlertManager.shared.dismissAlert()
    }

    @objc
    private func handleTap() {
        if password == nil {
            guard let text = enterPasswordTextField.text else { return }
            newPassword?(text)
            dismissAlert()
            return
        }

        if enterPasswordTextField.text == password {
            correctPassword?()
        } else {
            button.setTitle("Неверный пароль", for: .normal)
        }
    }
}

extension EnterPasswordAlert: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      let location = touch.location(in: nil)
      if alertAreaView.frame.contains(location) {
          return false
      }
      return true
    }
}
