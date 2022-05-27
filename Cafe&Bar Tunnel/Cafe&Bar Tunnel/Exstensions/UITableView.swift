//
//  UITableView.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import UIKit

extension UITableView {

    func registerCells(withModels models: AnyTableViewCellModelProtocol.Type...) {
        models.forEach {
            register(cellType: $0.viewClass)
        }
    }

    func register(withModel models: AnyTableViewHeaderFooterModelProtocol.Type...) {
        models.forEach {
            register(viewType: $0.viewClass)
        }
    }

    func dequeueReusableCell(withModel model: AnyTableViewCellModelProtocol, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: type(of: model).reuseIdentifier, for: indexPath)
    }

    func dequeueReusableHeaderFooter(withModel model: AnyTableViewHeaderFooterModelProtocol) -> UITableViewHeaderFooterView {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: type(of: model).reuseIdentifier) else {
            fatalError("Failed to dequeue a header/footer with identifier \(type(of: model).reuseIdentifier) matching type \(model.self).")
        }
        return headerFooter
    }
}

extension UITableView {

    func register<T: Reusable>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func register<T: Reusable>(viewType: T.Type) {
        register(viewType.self, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }

}
