//
//  Observer.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 30.04.2022.
//

import Foundation

public class Observer<T>: ObserverProtocol {
    public typealias Value = T
    public typealias Closure = (_ oldValue: T, _ newValue: T) -> Void
    private var observers = [String: Observer.Closure]()

    public var value: T {
        didSet {
            for closure in observers.values {
                closure(oldValue, value)
            }
        }
    }

    public init(value: T) {
        self.value = value
    }

    @discardableResult public func bind(closure: @escaping Closure) -> T {
        return bind(closure: closure).currentValue
    }

    @discardableResult public func bind(closure: @escaping Closure) -> (id: String, currentValue: T) {
        return bind(id: UUID().uuidString, closure: closure)
    }

    @discardableResult public func bind(id: String, closure: @escaping Closure) -> (id: String, currentValue: T) {
        observers[id] = closure
        return (id, value)
    }

    public func unbind(id: String) {
        observers[id] = nil
    }

    public func unbindAll() {
        observers.removeAll()
    }

    public func post(value: T) {
        DispatchQueue.main.async {
            self.value = value
        }
    }
}
