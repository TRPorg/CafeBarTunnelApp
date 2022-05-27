//
//  CoreDataManager+GroupItem.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 03.05.2022.
//

import Foundation
import CoreData
import UIKit

extension CoreDataManager {

    func getNewCatalogItemId() -> Int {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatalogItems")
        request.returnsObjectsAsFaults = false

        var highestId = 0
        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return highestId }
        result.forEach { object  in
            guard let item = object.value(forKey: "catalogItems") as? CatalogItemModel else { assertionFailure("fail to cast"); return }
            if item.id > highestId {
                highestId = Int(item.id)
            }
        }
        return highestId + 1
    }
    
    internal func deleteItemsOfGroup(by groupId: Int) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatalogItems")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return NSError() }

        result.forEach { object in
            guard let item = object.value(forKey: "catalogItems") as? CatalogItemModel else { assertionFailure("fail to cast"); return }
            if item.groupId == groupId {
                context.delete(object)
            }
        }

        do {
            try context.save()
            return nil
        } catch {
            return error
        }
    }

    func deleteItem(with id: Int) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatalogItems")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return NSError() }

        result.forEach { object in
            guard let item = object.value(forKey: "catalogItems") as? CatalogItemModel else { assertionFailure("fail to cast"); return }
            if item.id == id {
                context.delete(object)
            }
        }

        let resultfromdb = deletePurchasedItems(with: id)
        if let result = resultfromdb {
            print(result)
        }
        do {
            try context.save()
            return nil
        } catch {
            return error
        }
    }

}
