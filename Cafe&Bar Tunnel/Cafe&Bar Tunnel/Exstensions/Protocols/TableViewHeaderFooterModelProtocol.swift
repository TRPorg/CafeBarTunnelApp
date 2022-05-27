//
//  TableViewHeaderFooterModelProtocol.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import UIKit

protocol AnyTableViewHeaderFooterModelProtocol: AnyReusableViewModelProtocol {

    func configureAny(_ cell: UITableViewHeaderFooterView)
}

protocol TableViewHeaderFooterModelProtocol: AnyTableViewHeaderFooterModelProtocol {

    associatedtype CellType: UITableViewHeaderFooterView

    var height: CGFloat { get }

    func configure(_ cell: CellType)
}

extension TableViewHeaderFooterModelProtocol {
    var height: CGFloat { 0 }
}

extension TableViewHeaderFooterModelProtocol {

    static var viewClass: UIView.Type {
        return CellType.self
    }

    func configureAny(_ headerFooter: UITableViewHeaderFooterView) {
        guard let headerFooter = headerFooter as? CellType else {
            assertionFailure()
            return
        }
        configure(headerFooter)
    }
}
