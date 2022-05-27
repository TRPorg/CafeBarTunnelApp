//
//  CoreDataManager.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import CoreData
import UIKit

final class CoreDataManager {

    init() { }

    func clearData() {
        let entitys = ["CatalogGroups", "CatalogItems", "PurchasedItems"]
        entitys.forEach { entity in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            do {
                try context.execute(deleteRequest)
            } catch let error as NSError {
                assertionFailure(error.localizedDescription)
            }
        }
    }

    func getPassword() -> String? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Credentials")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return nil }

        var password: String?
        result.forEach { object in
            guard let item = object.value(forKey: "password") as? String else { assertionFailure("fail to cast"); return }
            password = item
        }
        return password
    }

    func savePassword(_ password: String) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Credentials")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return NSError() }

        if result.count == 0 {
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "Credentials", into: context)
            newItem.setValue(password, forKey: "password")

        } else {
            result[0].setValue(password, forKey: "password")
        }

        do {
            try context.save()
            return nil
        } catch {
            return error
        }
    }

    func saveCoreDataObject<T:CoreDataObject>(_ item: T) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newItem = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context)
        newItem.setValue(item, forKey: T.entityKey)
        do {
            try context.save()
            return nil
        } catch {
            return error
        }
    }

    func getItems(with entityName: String, and key: String) -> [CoreDataObject] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return [] }

        var retrievedItems: [CoreDataObject] = []
        result.forEach { object in
            guard let item = object.value(forKey: key) as? CoreDataObject else { assertionFailure("fail to cast"); return }
            retrievedItems.append(item)
        }
        return retrievedItems
    }

    func getNewGroupId() -> Int {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatalogGroups")
        request.returnsObjectsAsFaults = false

        var highestId = 0
        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return highestId }
        result.forEach { object  in
            guard let item = object.value(forKey: "catalogGroups") as? CatalogGroupModel else { assertionFailure("fail to cast"); return }
            if Int(item.groupId) > highestId {
                highestId = Int(item.groupId)
            }
        }
        return highestId + 1
    }

    func modifyItem<T:CoreDataObject>(with model: T) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return NSError() }

        var success = false

        result.forEach { object in
            if let item = object.value(forKey: T.entityKey) as? CatalogGroupModel {
                if item.groupId == (model as! CatalogGroupModel).groupId {
                    object.setValue(model, forKey: T.entityKey)
                    success = true
                    return
                }
            }
            if let item = object.value(forKey: T.entityKey) as? CatalogItemModel {
                if item.id == (model as! CatalogItemModel).id {
                    object.setValue(model, forKey: T.entityKey)
                    success = true
                    return
                }
            }
        }

        if success {
            do {
                try context.save()
                return nil
            } catch {
                return error
            }
        } else {
            return NSError()
        }
    }
}

