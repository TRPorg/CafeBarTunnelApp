//
//  AreYouSureAlert.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 05.05.2022.
//

import UIKit

final class AreYouSureAlert: BaseAlert {

    var yesAction: (() -> Void)?

    private let alertAreaView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()

    private let enterPasswordTextField: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        label.text = "Вы уверены?"
        label.textAlignment = .center
        return label
    }()


    private let yesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitle("Да", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    private let noButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitle("Нет", for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 8
        return button
    }()

    init() {
        super.init(frame: .zero)
        setUpLayout()
        setUpActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpActions() {
        yesButton.addTarget(self, action: #selector(handleYesTap), for: .touchUpInside)
        noButton.addTarget(self, action: #selector(handleNoTap), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
    }

    private func setUpLayout() {
        addSubviewsWithoutAutoresizing(alertAreaView)
        alertAreaView.addSubviewsWithoutAutoresizing(enterPasswordTextField, noButton, yesButton)

        NSLayoutConstraint.activate([
            alertAreaView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertAreaView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            alertAreaView.widthAnchor.constraint(equalToConstant: 260),
            alertAreaView.heightAnchor.constraint(equalToConstant: 140),

            enterPasswordTextField.topAnchor.constraint(equalTo: alertAreaView.topAnchor, constant: 15),
            enterPasswordTextField.widthAnchor.constraint(equalToConstant: 260),
            enterPasswordTextField.heightAnchor.constraint(equalToConstant: 35),
            enterPasswordTextField.centerXAnchor.constraint(equalTo: alertAreaView.centerXAnchor),

            noButton.leftAnchor.constraint(equalTo: alertAreaView.leftAnchor, constant: 18),
            noButton.widthAnchor.constraint(equalToConstant: 80),
            noButton.bottomAnchor.constraint(equalTo: alertAreaView.bottomAnchor, constant: -19),

            yesButton.rightAnchor.constraint(equalTo: alertAreaView.rightAnchor, constant: -18),
            yesButton.widthAnchor.constraint(equalToConstant: 80),
            yesButton.bottomAnchor.constraint(equalTo: alertAreaView.bottomAnchor, constant: -19),
            
        ])
    }

    @objc private func dismissAlert() {
        AlertManager.shared.dismissAlert()
    }

    @objc
    private func handleYesTap() {
        yesAction?()
        dismissAlert()
    }

    @objc
    private func handleNoTap() {
        dismissAlert()
    }
}

extension AreYouSureAlert: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      let location = touch.location(in: nil)
      if alertAreaView.frame.contains(location) {
          return false
      }
      return true
    }
}

