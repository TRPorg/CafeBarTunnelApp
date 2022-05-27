//
//  SettingsScreenViewModel.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

protocol SettingsScreenViewModel: AnyObject {
    var routing: (SettingsScreenViewModelFlow) -> Void { get set }
    func loadDataFromDB()
    func clearDB()
    func deleteItem(with id: Int)
    func deleteGroupItem(with groupId: Int)
    func savePassword(_ password: String)
    func saveDataToDB()
    func modifyItemCellModel(model: CatalogItemModel)
    func modifyGroupCellModel(groupId: Int, name: String)
    func addNewGroupItem(with name: String)
    func insertNewItem(in groupId: Int)
    func getNumberOfRows(for section: Int) -> Int
    func getNumberOfSections() -> Int
    func getModelForHeader(for section: Int) -> CatalogGroupModel
    func cellData(for indexPath: IndexPath) -> AnyTableViewCellModelProtocol
    func toMainScreen()
    func toReportScreen(from: Date, to: Date)
}

enum SettingsScreenViewModelFlow {
    case toReportScreen(Date, Date)
    case toMainScreen
}

final class SettingsScreenViewModelImpl: SettingsScreenViewModel {

    var routing: (SettingsScreenViewModelFlow) -> Void = { _ in }

    private var cellModels: [CatalogItemSettingsModel] = []
    private let coreDataManager = CoreDataManager()

    init() { }

    func loadDataFromDB() {
        cellModels = []
        guard let groups = coreDataManager.getItems(with: CatalogGroupModel.entityName, and: CatalogGroupModel.entityKey) as? [CatalogGroupModel] else { assertionFailure("wrong object"); return }
        guard let items = coreDataManager.getItems(with: CatalogItemModel.entityName, and: CatalogItemModel.entityKey) as? [CatalogItemModel] else { assertionFailure("wrong object"); return }

        groups.forEach { group in
            var sameGroupItems: [EditableItemCellViewModel] = []
            items.forEach { item in
                if item.groupId == group.groupId {
                    sameGroupItems.append(EditableItemCellViewModel(item))
                }
            }
            cellModels.append(CatalogItemSettingsModel(groupModel: group, items: sameGroupItems))
        }
    }

    func savePassword(_ password: String) {
        let result = coreDataManager.savePassword(password)
        if let result = result {
            print(result)
        }
    }

    func clearDB() {
        coreDataManager.clearData()
        cellModels = []
    }

    func saveDataToDB() {
        cellModels.forEach { object in
            let result = coreDataManager.modifyItem(with: object.groupModel)
            if let result = result {
                print(result)
            }
            object.items.forEach { item in
                let result = coreDataManager.modifyItem(with: item.model)
                if let result = result {
                    print(result)
                }
            }
        }
    }

    func deleteItem(with id: Int) {
        let result = coreDataManager.deleteItem(with: id)
        if let result = result {
            print(result)
        } else {
            for index in 0...cellModels.count-1 {
                for itemIndex in 0...cellModels[index].items.count-1 {
                    if cellModels[index].items[itemIndex].model.id == id {
                        cellModels[index].items.remove(at: itemIndex)
                        return
                    }
                }
            }
        }
    }

    func deleteGroupItem(with groupId: Int) {
        let result = coreDataManager.deleteGroupItem(with: groupId)
        if let result = result {
            print(result)
        } else {
            for index in 0...cellModels.count-1 {
                if cellModels[index].groupModel.groupId == groupId {
                    cellModels.remove(at: index)
                    return
                }
            }
        }
    }


    func modifyItemCellModel(model: CatalogItemModel) {
        cellModels.forEach { object in
            object.items.forEach { item in
                if item.model.id == model.id {
                    item.model = model
                }
            }
        }
    }

    func modifyGroupCellModel(groupId: Int, name: String) {
        cellModels.forEach { object in
            if object.groupModel.groupId == groupId {
                object.groupModel.name = name
            }
        }
    }

    func addNewGroupItem(with name: String) {
        let groupModel = CatalogGroupModel(groupId: coreDataManager.getNewGroupId(), name: name)
        let saveResult = coreDataManager.saveCoreDataObject(groupModel)
        switch saveResult {
        case .none:
            cellModels.append(CatalogItemSettingsModel(groupModel: groupModel, items: []))
        case .some(let error):
            print(error)
        }
    }

    func insertNewItem(in groupId: Int) {
        let itemModel = CatalogItemModel(id: coreDataManager.getNewCatalogItemId(),
                                         groupId: groupId, name: "Название",
                                         price: 0,
                                         volume: 0)
        let saveResult = coreDataManager.saveCoreDataObject(itemModel)
        switch saveResult {
        case .none:
            for index in 0...cellModels.count-1 {
                if cellModels[index].groupModel.groupId == itemModel.groupId {
                    cellModels[index].items.append(EditableItemCellViewModel(itemModel))
                    return
                }
            }
        case .some(let error):
            print(error)
        }
    }

    func getNumberOfRows(for section: Int) -> Int {
        cellModels[section].items.count
    }

    func getNumberOfSections() -> Int {
        cellModels.count
    }

    func getModelForHeader(for section: Int) -> CatalogGroupModel {
        cellModels[section].groupModel
    }

    func cellData(for indexPath: IndexPath) -> AnyTableViewCellModelProtocol {
        return cellModels[indexPath.section].items[indexPath.row]
    }

    func toReportScreen(from: Date, to: Date) {
        routing(.toReportScreen(from, to))
    }
    
    func toMainScreen() {
        routing(.toMainScreen)
    }

    private func fillCellModels(with items: [CatalogItemModel]) {
        let subGroupCellModels = items.compactMap { item in
            EditableItemCellViewModel(item)
        }
        cellModels.append(CatalogItemSettingsModel(groupModel: CatalogGroupModel(groupId: 0, name: "mocked"),
                                                 items: subGroupCellModels))
    }
}
