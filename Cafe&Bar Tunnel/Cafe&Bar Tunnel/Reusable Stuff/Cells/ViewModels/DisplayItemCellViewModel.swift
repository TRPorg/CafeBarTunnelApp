//
//  DisplayItemCellViewModel.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation

final class DisplayItemCellViewModel: TableViewCellModelProtocol {

    var model: CheckoutItemModel

    init(_ model: CheckoutItemModel) {
        self.model = model
    }

    func configure(_ cell: DispayItemCell) {
        cell.configure(model: model)
    }
}
