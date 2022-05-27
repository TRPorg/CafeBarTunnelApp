//
//  UIView.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import UIKit

extension UIView: Reusable { }

extension UIView {
    func addSubviewsWithoutAutoresizing(_ subviews: UIView...) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
