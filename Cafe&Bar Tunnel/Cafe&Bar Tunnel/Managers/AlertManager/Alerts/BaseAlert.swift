//
//  BaseAlert.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 30.04.2022.
//

import UIKit

class BaseAlert: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
        backgroundColor = .black.withAlphaComponent(0.6)
    }
    public convenience init() {
        self.init(frame:  UIScreen.main.bounds)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
