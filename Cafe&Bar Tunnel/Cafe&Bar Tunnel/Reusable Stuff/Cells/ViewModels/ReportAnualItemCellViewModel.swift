//
//  ReportAnualItemCellViewModel.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 04.05.2022.
//

import Foundation

final class ReportAnualItemCellViewModel: TableViewCellModelProtocol {

    var model: CheckoutItemModel

    init(_ model: CheckoutItemModel) {
        self.model = model
    }

    func configure(_ cell: ReportAnualItemCell) {
        cell.configure(model: model)
    }
}
