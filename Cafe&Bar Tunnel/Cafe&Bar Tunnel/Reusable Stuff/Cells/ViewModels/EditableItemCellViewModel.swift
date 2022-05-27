//
//  EditableItemCellViewModel.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 28.04.2022.
//

import Foundation

final class EditableItemCellViewModel: TableViewCellModelProtocol {

    var model: CatalogItemModel

    init(_ model: CatalogItemModel) {
        self.model = model
    }

    func configure(_ cell: EditableItemCell) {
        cell.configure(model: model)
    }
}
