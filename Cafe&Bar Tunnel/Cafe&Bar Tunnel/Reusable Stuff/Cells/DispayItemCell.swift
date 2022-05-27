//
//  DispayItemCell.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

protocol DispayItemCellDelegate: AnyObject {
    func modelChanged(model: CheckoutItemModel)
}

class DispayItemCell: UITableViewCell {

    static let cosmoPassportCellReuseID = "DispayItemCell"
    weak var delegate: DispayItemCellDelegate?

    private let itemNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()

    private let decreaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("-", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = "0"
        label.layer.cornerRadius = 4
        label.numberOfLines = 0
        return label
    }()
    
    private let increaseButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private var model: CheckoutItemModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        setUpLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        itemNameLabel.text = nil
        itemPriceLabel.text = nil
        quantityLabel.text = "0"
    }

    func configure(model: CheckoutItemModel) {
        self.model = model
        itemNameLabel.text = model.name
        itemPriceLabel.text = "\(model.price)руб."
        quantityLabel.text = "\(model.quantity)"
        if model.volume != 0 {
            itemPriceLabel.text = "\(model.volume) мл/\(model.price)руб."
            return
        }
    }

    private func setUpUI() {
        backgroundColor = .clear
    }

    private func setUpLayout() {
        contentView.addSubviewsWithoutAutoresizing(itemPriceLabel, itemNameLabel, decreaseButton, quantityLabel, increaseButton, separator)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            itemNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            itemNameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 96),
            itemNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            itemPriceLabel.centerYAnchor.constraint(equalTo: itemNameLabel.centerYAnchor),
            itemPriceLabel.rightAnchor.constraint(equalTo: decreaseButton.leftAnchor, constant: -10),

            decreaseButton.centerYAnchor.constraint(equalTo: itemNameLabel.centerYAnchor),
            decreaseButton.rightAnchor.constraint(equalTo: quantityLabel.leftAnchor, constant: -20),
            decreaseButton.heightAnchor.constraint(equalToConstant: 50),
            decreaseButton.widthAnchor.constraint(equalToConstant: 50),

            quantityLabel.centerYAnchor.constraint(equalTo: itemNameLabel.centerYAnchor),
            quantityLabel.rightAnchor.constraint(equalTo: increaseButton.leftAnchor, constant: -20),

            increaseButton.centerYAnchor.constraint(equalTo: itemNameLabel.centerYAnchor),
            increaseButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -48),
            increaseButton.heightAnchor.constraint(equalToConstant: 50),
            increaseButton.widthAnchor.constraint(equalToConstant: 50),

            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 48),
            separator.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -48),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])

        decreaseButton.addTarget(self, action: #selector(decreaseTap), for: .touchUpInside)
        increaseButton.addTarget(self, action: #selector(increaseTap), for: .touchUpInside)
    }

    @objc private func decreaseTap() {
        guard let model = model else { return }
        if model.quantity > 0 {
            model.quantity -= 1
        }
        quantityLabel.text = "\(model.quantity)"
        delegate?.modelChanged(model: model)
    }

    @objc private func increaseTap() {
        guard let model = model else { return }
        model.quantity += 1
        quantityLabel.text = "\(model.quantity)"
        delegate?.modelChanged(model: model)
    }
}

