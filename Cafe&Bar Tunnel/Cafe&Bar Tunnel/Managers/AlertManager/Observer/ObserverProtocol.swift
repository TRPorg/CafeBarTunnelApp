//
//  ObserverProtocol.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 30.04.2022.
//

import Foundation

public protocol ObserverProtocol {
    associatedtype Value
    typealias Closure = (_ oldValue: Value, _ newValue: Value) -> Void
    var value: Value { get set }
    mutating func bind(closure: @escaping Closure) -> Value
}
