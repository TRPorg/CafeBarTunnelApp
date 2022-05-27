//
//  EditableItemCell.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 28.04.2022.
//

import Foundation
import UIKit

protocol EditableItemCellDelegate: AnyObject {
    func modelChanged(_ model: CatalogItemModel)
    func deleteItem(_ id: Int)
}

class EditableItemCell: UITableViewCell {

    static let cosmoPassportCellReuseID = "EditableItemCell"
    weak var delegate: EditableItemCellDelegate?

    private let itemNameTextView: UITextField = {
        let label = UITextField()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
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

    private let itemPriceTextView: UITextField = {
        let label = UITextField()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor
        label.attributedPlaceholder = NSAttributedString(
            string: "Цена",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return label
    }()

    private let itemAmmountTextView: UITextField = {
        let label = UITextField()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor
        label.attributedPlaceholder = NSAttributedString(
            string: "Объем",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        return label
    }()

    private let removeItemButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    

    private var id: Int?

    private var model: CatalogItemModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        setUpLayout()
        setupTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemNameTextView.text = nil
        itemPriceTextView.text = nil
        itemAmmountTextView.text = nil
        model = nil
    }

    func configure(model: CatalogItemModel) {
        self.model = model
        id = model.id
        itemNameTextView.text = model.name
        itemPriceTextView.text = "\(model.price)"
        itemAmmountTextView.text = "\(model.volume)"
        if model.name == "Название" ||
            model.name == "" {
            itemNameTextView.text = nil
        }
        if model.price == 0 {
            itemPriceTextView.text = nil
        }
        if model.volume == 0 {
            itemAmmountTextView.text = nil
        }
    }

    private func setUpUI() {
        backgroundColor = .clear
    }

    private func setUpLayout() {
        contentView.addSubviewsWithoutAutoresizing(itemNameTextView, itemPriceTextView, itemAmmountTextView, removeItemButton)
        NSLayoutConstraint.activate([
            itemNameTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            itemNameTextView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 112),
            itemNameTextView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 96),
            itemNameTextView.heightAnchor.constraint(equalToConstant: 50),
            itemNameTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            itemPriceTextView.centerYAnchor.constraint(equalTo: itemNameTextView.centerYAnchor),
            itemPriceTextView.leftAnchor.constraint(equalTo: itemNameTextView.rightAnchor, constant: 10),
            itemPriceTextView.widthAnchor.constraint(equalToConstant: 130),

            itemAmmountTextView.centerYAnchor.constraint(equalTo: itemPriceTextView.centerYAnchor),
            itemAmmountTextView.leftAnchor.constraint(equalTo: itemPriceTextView.rightAnchor, constant: 10),
            itemAmmountTextView.widthAnchor.constraint(equalToConstant: 130),

            removeItemButton.centerYAnchor.constraint(equalTo: itemAmmountTextView.centerYAnchor),
            removeItemButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -48),
            removeItemButton.widthAnchor.constraint(equalToConstant: 50),
            removeItemButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setupTargets() {
        itemNameTextView.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        itemAmmountTextView.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        itemPriceTextView.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        removeItemButton.addTarget(self, action: #selector(removeItem), for: .touchUpInside)
    }

    @objc private func textChanged() {
        guard let model = model else { return }
        model.name = itemNameTextView.text ?? ""
        model.price = Int(itemPriceTextView.text ?? "") ?? 0
        model.volume = Int(itemAmmountTextView.text ?? "") ?? 0
        delegate?.modelChanged(model)
    }

    @objc private func removeItem() {
        print("delete")
        guard let model = model else { return }
        delegate?.deleteItem(model.id)
    }
}

