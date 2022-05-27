//
//  HighlightedButton.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 21.05.2022.
//

import UIKit

class HighlightedButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .white.withAlphaComponent(0.3) : .clear
        }
    }
}
