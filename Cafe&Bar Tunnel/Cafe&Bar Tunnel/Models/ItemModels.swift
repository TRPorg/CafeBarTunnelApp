//
//  ItemModel.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation

protocol CoreDataObject: NSObject, NSCoding {
    static var entityName: String { get }
    static var entityKey: String { get }
}

public class CatalogGroupModel: NSObject, CoreDataObject {
    static var entityName: String = "CatalogGroups"
    static var entityKey: String = "catalogGroups"

    enum Keys: String {
        case groupId = "GroupId"
        case name = "Name"
    }

    public func encode(with coder: NSCoder) {
        coder.encode(groupId, forKey: Keys.groupId.rawValue)
        coder.encode(name, forKey: Keys.name.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let groupId = coder.decodeInteger(forKey: Keys.groupId.rawValue)
        let name = coder.decodeObject(forKey: Keys.name.rawValue) as! String
        self.init(groupId: groupId, name: name)
    }

    let groupId: Int
    var name: String

    init(groupId: Int, name: String) {
        self.groupId = groupId
        self.name = name
    }
}

public class CatalogItemModel: NSObject, CoreDataObject {
    static var entityName: String = "CatalogItems"
    static var entityKey: String = "catalogItems"

    enum Keys: String {
        case id = "Id"
        case groupId = "GroupId"
        case name = "Name"
        case price = "Price"
        case volume = "Volume"
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Keys.id.rawValue)
        coder.encode(groupId, forKey: Keys.groupId.rawValue)
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(price, forKey: Keys.price.rawValue)
        coder.encode(volume, forKey: Keys.volume.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: Keys.id.rawValue)
        let groupId = coder.decodeInteger(forKey: Keys.groupId.rawValue)
        let name = coder.decodeObject(forKey: Keys.name.rawValue) as! String
        let price = coder.decodeInteger(forKey: Keys.price.rawValue)
        let volume = coder.decodeInteger(forKey: Keys.volume.rawValue)
        self.init(id: id, groupId: groupId, name: name, price: price, volume: volume)
    }

    let id: Int
    let groupId: Int
    var name: String
    var price: Int
    var volume: Int

    init(id: Int, groupId: Int, name: String, price: Int, volume: Int) {
        self.id = id
        self.groupId = groupId
        self.name = name
        self.price = price
        self.volume = volume
    }
}

public class CheckoutItemModel: NSObject, CoreDataObject {
    static var entityName: String = "PurchasedItems"
    static var entityKey: String = "purchasedItem"

    enum Keys: String {
        case id = "Id"
        case groupId = "GroupId"
        case name = "Name"
        case price = "Price"
        case volume = "Volume"
        case quantity = "Quantity"
        case date = "Date"
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: Keys.id.rawValue)
        coder.encode(groupId, forKey: Keys.groupId.rawValue)
        coder.encode(name, forKey: Keys.name.rawValue)
        coder.encode(price, forKey: Keys.price.rawValue)
        coder.encode(volume, forKey: Keys.volume.rawValue)
        coder.encode(quantity, forKey: Keys.quantity.rawValue)
        coder.encode(date, forKey: Keys.date.rawValue)
    }

    public required convenience init?(coder: NSCoder) {
        let id = coder.decodeInteger(forKey: Keys.id.rawValue)
        let groupId = coder.decodeInteger(forKey: Keys.groupId.rawValue)
        let name = coder.decodeObject(forKey: Keys.name.rawValue) as! String
        let price = coder.decodeInteger(forKey: Keys.price.rawValue)
        let volume = coder.decodeInteger(forKey: Keys.volume.rawValue)
        let quantity = coder.decodeInteger(forKey: Keys.quantity.rawValue)
        let date = coder.decodeObject(forKey: Keys.date.rawValue) as! Date
        self.init(id: id, groupId: groupId, name: name, price: price, volume: volume, quantity: quantity, date: date)
    }

    let id: Int
    let groupId: Int
    let name: String
    let price: Int
    let volume: Int
    var quantity: Int
    var date: Date

    init(id: Int, groupId: Int, name: String, price: Int, volume: Int, quantity: Int, date: Date) {
        self.id = id
        self.groupId = groupId
        self.name = name
        self.price = price
        self.volume = volume
        self.quantity = quantity
        self.date = date
    }
}

struct CatalogItemConfigModel {
    let groupModel: CatalogGroupModel
    var items: [DisplayItemCellViewModel]
}

struct CatalogItemSettingsModel {
    let groupModel: CatalogGroupModel
    var items: [EditableItemCellViewModel]
}
