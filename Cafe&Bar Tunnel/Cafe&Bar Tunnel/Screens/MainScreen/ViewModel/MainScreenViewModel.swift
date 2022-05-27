//
//  MainScreenViewModelImpl.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

protocol MainScreenViewModel: AnyObject {
    var routing: (MainScreenViewModelFlow) -> Void { get set }
    func loadDataFromDB()
    func getPassword() -> String?
    func modifyModel(model: CheckoutItemModel)
    func resetCounters()
    func saveCheckoutedItems()
    func getNumberOfRows(for section: Int) -> Int
    func getNumberOfSections() -> Int
    func getTextForHeader(for section: Int) -> String
    func cellData(for indexPath: IndexPath) -> AnyTableViewCellModelProtocol
    func toSettings()
}

enum MainScreenViewModelFlow {
    case toSettings
    case exit
}

final class MainScreenViewModelImpl: MainScreenViewModel {

    var routing: (MainScreenViewModelFlow) -> Void = { _ in }

    private var cellModels: [CatalogItemConfigModel] = []
    private let coreDataManager = CoreDataManager()

    init() {}

    func loadDataFromDB() {
        cellModels = []
        guard let groups = coreDataManager.getItems(with: CatalogGroupModel.entityName, and: CatalogGroupModel.entityKey) as? [CatalogGroupModel] else { assertionFailure("wrong object"); return }
        guard let items = coreDataManager.getItems(with: CatalogItemModel.entityName, and: CatalogItemModel.entityKey) as? [CatalogItemModel] else { assertionFailure("wrong object"); return }

        groups.forEach { group in
            var sameGroupItems: [DisplayItemCellViewModel] = []
            items.forEach { item in
                if item.groupId == group.groupId {
                    sameGroupItems.append(DisplayItemCellViewModel(CheckoutItemModel(id: item.id,
                                                                                     groupId: item.groupId,
                                                                                     name: item.name,
                                                                                     price: item.price,
                                                                                     volume: item.volume,
                                                                                     quantity: 0,
                                                                                     date: Date())))
                }
            }
            cellModels.append(CatalogItemConfigModel(groupModel: group, items: sameGroupItems))
        }
    }

    func getPassword() -> String? {
        coreDataManager.getPassword()
    }

    func modifyModel(model: CheckoutItemModel) {
        cellModels.forEach { object in
            object.items.forEach { item in
                if item.model.id == model.id {
                    item.model = model
                }
            }
        }
    }

    func resetCounters() {
        cellModels.forEach { group in
            group.items.forEach { item in
                item.model.quantity = 0
            }
        }
    }

    func saveCheckoutedItems() {
        cellModels.forEach { group in
            group.items.forEach { item in
                if item.model.quantity != 0 {
                    item.model.date = Date()
                    let result = coreDataManager.saveCoreDataObject(item.model)
                    if let result = result {
                        print(result)
                    }
                }
                item.model.quantity = 0
            }
        }
    }

    func getNumberOfRows(for section: Int) -> Int {
        cellModels[section].items.count
    }

    func getNumberOfSections() -> Int {
        cellModels.count
    }

    func getTextForHeader(for section: Int) -> String {
        cellModels[section].groupModel.name
    }

    func cellData(for indexPath: IndexPath) -> AnyTableViewCellModelProtocol {
        return cellModels[indexPath.section-1].items[indexPath.row]
    }

    func toSettings() {
        routing(.toSettings)
    }
}
