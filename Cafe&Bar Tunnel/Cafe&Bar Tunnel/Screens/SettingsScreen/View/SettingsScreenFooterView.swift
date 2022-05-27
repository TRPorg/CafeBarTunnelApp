//
//  SettingsScreenFooterView.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

protocol SettingsScreenFooterViewDelegate: AnyObject {
    func addGroupTap()
    func clearDBTap()
    func reportTap()
    func changePasswordTap()
}

final class SettingsScreenFooterView: UIView {

    weak var delegate: SettingsScreenFooterViewDelegate?
    
    private let changePasswordButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Сменить пароль", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let clearDBButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Очистить БД", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let reportButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Отчет", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let addGroupButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Добавить Категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()


    init() {
        super.init(frame: .zero)
        setupUI()
        setupTargets()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviewsWithoutAutoresizing(changePasswordButton, clearDBButton, reportButton, addGroupButton)
        NSLayoutConstraint.activate([
            changePasswordButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 48),
            changePasswordButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            changePasswordButton.widthAnchor.constraint(equalToConstant: 230),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),

            clearDBButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -48),
            clearDBButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            clearDBButton.widthAnchor.constraint(equalToConstant: 230),
            clearDBButton.heightAnchor.constraint(equalToConstant: 50),


            reportButton.widthAnchor.constraint(equalToConstant: 170),
            reportButton.heightAnchor.constraint(equalToConstant: 50),
            reportButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            reportButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),

            addGroupButton.widthAnchor.constraint(equalToConstant: 280),
            addGroupButton.heightAnchor.constraint(equalToConstant: 50),
            addGroupButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addGroupButton.bottomAnchor.constraint(equalTo: reportButton.topAnchor, constant: -20),

        ])
    }

    private func setupTargets() {
        changePasswordButton.addTarget(self, action: #selector(changePasswordTap), for: .touchUpInside)
        addGroupButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        clearDBButton.addTarget(self, action: #selector(clearDBTap), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(reportTap), for: .touchUpInside)
    }

    @objc private func buttonTap() {
        delegate?.addGroupTap()
    }

    @objc private func clearDBTap() {
        delegate?.clearDBTap()
    }

    @objc private func reportTap() {
        delegate?.reportTap()
    }

    @objc private func changePasswordTap() {
        delegate?.changePasswordTap()
    }
}
