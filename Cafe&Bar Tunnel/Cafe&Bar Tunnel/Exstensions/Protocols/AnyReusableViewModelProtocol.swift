//
//  AnyReusableViewModelProtocol.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import UIKit

protocol AnyReusableViewModelProtocol: AnyObject {

    static var viewClass: UIView.Type { get }
    static var reuseIdentifier: String { get }
}

extension AnyReusableViewModelProtocol {

    private static var cellClassName: String {
        return String(describing: viewClass)
    }

    static var reuseIdentifier: String {
        return cellClassName
    }
}
