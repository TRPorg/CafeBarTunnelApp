//
//  ReportItemCell.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 04.05.2022.
//

import Foundation
import UIKit

final class ReportItemCell: UITableViewCell {

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

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

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
    }

    func configure(model: CheckoutItemModel) {
        itemNameLabel.text = model.name

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd HH:mm:ss"
        let formatedTime = dateFormatter.string(from: model.date)

        itemPriceLabel.text = "Количество:\(model.quantity) Продан в: \(formatedTime)"
    }

    private func setUpUI() {
        backgroundColor = .clear
    }

    private func setUpLayout() {
        contentView.addSubviewsWithoutAutoresizing(itemPriceLabel, itemNameLabel, separator)
        NSLayoutConstraint.activate([
            itemNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            itemNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 48),
            itemNameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2 - 96),
            itemNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            itemPriceLabel.centerYAnchor.constraint(equalTo: itemNameLabel.centerYAnchor),
            itemPriceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -48),

            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 48),
            separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -48),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

