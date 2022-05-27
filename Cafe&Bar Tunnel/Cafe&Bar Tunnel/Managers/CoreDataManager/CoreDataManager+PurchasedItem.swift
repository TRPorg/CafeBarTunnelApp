//
//  CoreDataManager+PurchasedItem.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 03.05.2022.
//

import Foundation
import CoreData
import UIKit

extension CoreDataManager {
    
    func getPurchasedItems(from: Date, to: Date) -> [CheckoutItemModel] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PurchasedItems")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return [] }

        var retrievedItems: [CheckoutItemModel] = []
        result.forEach { object in
            guard let item = object.value(forKey: "purchasedItem") as? CheckoutItemModel else { assertionFailure("fail to cast"); return }
            if item.date > from && item.date < to {
                retrievedItems.append(item)
            }
        }
        return retrievedItems
    }

    internal func deletePurchasedItems(with id: Int) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PurchasedItems")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return nil }

        result.forEach { object in
            guard let item = object.value(forKey: "purchasedItem") as? CheckoutItemModel else { assertionFailure("fail to cast"); return }
            if item.id == id {
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

    internal func deletePurchasedGroupItems(with groupId: Int) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PurchasedItems")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return nil }

        result.forEach { object in
            guard let item = object.value(forKey: "purchasedItem") as? CheckoutItemModel else { assertionFailure("fail to cast"); return }
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
}
