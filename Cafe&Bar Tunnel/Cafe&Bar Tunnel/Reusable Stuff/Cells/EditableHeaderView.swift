//
//  EditableHeaderCell.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 28.04.2022.
//

import Foundation
import UIKit

protocol EditableHeaderViewDelegate: AnyObject {
    func addNewItem(_ groupId: Int)
    func deleteCategory(_ groupId: Int)
    func textChanged(_ text: String, groupId: Int)
}

final class EditableHeaderView: UIView {

    weak var delegate: EditableHeaderViewDelegate?

    private let titleLabel: UITextField = {
        let label = UITextField()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor
        label.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return label
    }()

    private let addItemButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let removeCategoryButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()


    private let groupId: Int

    init(model: CatalogGroupModel) {
        titleLabel.text = model.name as String
        if model.name == "Название" ||
            model.name == "" {
            titleLabel.text = nil
        }
        groupId = model.groupId
        super.init(frame: .zero)
        setupUI()
        setupTargets()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviewsWithoutAutoresizing(titleLabel, addItemButton, removeCategoryButton)
        NSLayoutConstraint.activate([
            removeCategoryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeCategoryButton.widthAnchor.constraint(equalToConstant: 50),
            removeCategoryButton.heightAnchor.constraint(equalToConstant: 50),
            removeCategoryButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 48),

            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2+5),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            addItemButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: 50),
            addItemButton.heightAnchor.constraint(equalToConstant: 50),
            addItemButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -48),
        ])
        backgroundColor = .clear
    }

    private func setupTargets() {
        removeCategoryButton.addTarget(self, action: #selector(removeTap), for: .touchUpInside)
        addItemButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        titleLabel.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
    }

    @objc private func removeTap() {
        delegate?.deleteCategory(groupId)
    }

    @objc private func buttonTap() {
        delegate?.addNewItem(groupId)
    }

    @objc private func textChanged() {
        guard let text = titleLabel.text else { return }
        delegate?.textChanged(text, groupId: groupId)
    }
}
