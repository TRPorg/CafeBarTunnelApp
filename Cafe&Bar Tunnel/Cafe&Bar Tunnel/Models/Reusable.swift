//
//  Reusable.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
