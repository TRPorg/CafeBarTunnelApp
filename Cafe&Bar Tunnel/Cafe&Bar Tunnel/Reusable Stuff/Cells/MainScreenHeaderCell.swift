//
//  MainScreenHeaderView.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class MainScreenHeaderCell: UITableViewCell {

    static let cosmoPassportCellReuseID = "DispayItemCell"
    
    private let topLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "#TUNNELCOCTAIL"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let topRightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "#ТУННЕЛЬКОКТЕЛЬ"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let logoImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "logo"))
        image.contentMode = .scaleToFill
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubviewsWithoutAutoresizing(topLeftLabel, topRightLabel, logoImage)
        NSLayoutConstraint.activate([
            topLeftLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 48),
            topLeftLabel.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor),

            topRightLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -48),
            topRightLabel.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor),

            logoImage.topAnchor.constraint(equalTo: topAnchor),
            logoImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            logoImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 120),
            logoImage.widthAnchor.constraint(equalToConstant: 120),
        ])
    }
}
