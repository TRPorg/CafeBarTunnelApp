//
//  CoreDataManagerCatalogItem.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 03.05.2022.
//

import Foundation
import CoreData
import UIKit

extension CoreDataManager {
    
    func deleteGroupItem(with groupId: Int) -> Error? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CatalogGroups")
        request.returnsObjectsAsFaults = false

        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return NSError() }

        result.forEach { object in
            guard let item = object.value(forKey: "catalogGroups") as? CatalogGroupModel else { assertionFailure("fail to cast"); return }
            if item.groupId == groupId {
                context.delete(object)
            }
        }

        let resultfromdb = deleteItemsOfGroup(by: groupId)
        if let result = resultfromdb {
            print(result)
        }

        let resultfromdb2 = deletePurchasedGroupItems(with: groupId)
        if let result = resultfromdb2 {
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
