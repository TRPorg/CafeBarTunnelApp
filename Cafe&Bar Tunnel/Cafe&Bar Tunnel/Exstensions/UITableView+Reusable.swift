//
//  UITableView+Reusable.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import UIKit

extension UITableViewCell {

    static var reuseIdentifier: String { String(describing: Self.self) }

    func cellAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }
}
