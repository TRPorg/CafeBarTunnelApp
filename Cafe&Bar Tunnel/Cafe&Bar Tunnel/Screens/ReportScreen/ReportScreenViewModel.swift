//
//  ReportScreenViewModel.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 04.05.2022.
//

import Foundation

protocol ReportScreenViewModel: AnyObject {
    var routing: (ReportScreenViewModelFlow) -> Void { get set }
    func loadDataFromDB()
    func cellData(for indexPath: IndexPath) -> AnyTableViewCellModelProtocol
    func getNumberOfRows() -> Int
    func toSettings()
}

enum ReportScreenViewModelFlow {
    case toSettingsScreen
}

final class ReportScreenViewModelImpl: ReportScreenViewModel {

    var routing: (ReportScreenViewModelFlow) -> Void = { _ in }

    private let coreDataManager = CoreDataManager()
    private var cellModels: [AnyTableViewCellModelProtocol] = []

    private let from: Date
    private let to: Date

    init(from: Date, to: Date) {
        self.from = from
        self.to = to
    }

    func loadDataFromDB() {
        cellModels = []
        let items = coreDataManager.getPurchasedItems(from: from, to: to)
        var ids: [Int] = []
        items.forEach { item in
            cellModels.append(ReportItemCellViewModel(item))
            if !ids.contains(item.id) {
                ids.append(item.id)
            }
        }

        ids.forEach { id in
            var count = 0
            var itemtemp: CheckoutItemModel?
            items.forEach { item in
                if item.id == id {
                    count += item.quantity
                    item.quantity = count
                    itemtemp = item
                }
            }
            guard let itemtemp = itemtemp else { return }
            cellModels.append(ReportAnualItemCellViewModel(itemtemp))
        }

    }

    func cellData(for indexPath: IndexPath) -> AnyTableViewCellModelProtocol {
        return cellModels[indexPath.row]
    }

    func getNumberOfRows() -> Int {
        return cellModels.count
    }

    func toSettings() {
        routing(.toSettingsScreen)
    }
}
