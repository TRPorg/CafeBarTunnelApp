//
//  MainScreenFooterView.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

protocol MainScreenFooterViewDelegate: AnyObject {
    func openSettings()
    func askForCheckout()
    func clearCounters()
}

final class MainScreenFooterView: UIView, UIGestureRecognizerDelegate {

    weak var delegate: MainScreenFooterViewDelegate?

    private lazy var resetButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Сбросить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private lazy var checkoutButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Пробить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let settingsImageView: UIImageView = {
        let button = UIImageView()
        button.image = UIImage(named: "gearshape")
        button.backgroundColor = .clear
        return button
    }()

    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.isEnabled = true
        button.backgroundColor = .clear
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviewsWithoutAutoresizing(checkoutButton, resetButton, settingsImageView, settingsButton)
        NSLayoutConstraint.activate([
            resetButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 48),
            resetButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            resetButton.widthAnchor.constraint(equalToConstant: 150),
            resetButton.heightAnchor.constraint(equalToConstant: 40),

            checkoutButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -48),
            checkoutButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            checkoutButton.widthAnchor.constraint(equalToConstant: 150),
            checkoutButton.heightAnchor.constraint(equalToConstant: 40),

            settingsButton.widthAnchor.constraint(equalToConstant: 40),
            settingsButton.heightAnchor.constraint(equalToConstant: 40),
            settingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),

            settingsImageView.widthAnchor.constraint(equalToConstant: 40),
            settingsImageView.heightAnchor.constraint(equalToConstant: 40),
            settingsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            settingsImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),

        ])

        settingsButton.addTarget(self, action: #selector(settingsTap), for: .touchUpInside)
        checkoutButton.addTarget(self, action: #selector(checkoutTap), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetTap), for: .touchUpInside)
    }

    @objc private func settingsTap() {
        print("Settings tap")
        delegate?.openSettings()
    }

    @objc private func checkoutTap() {
        delegate?.askForCheckout()
    }

    @objc private func resetTap() {
        delegate?.clearCounters()
    }

}
