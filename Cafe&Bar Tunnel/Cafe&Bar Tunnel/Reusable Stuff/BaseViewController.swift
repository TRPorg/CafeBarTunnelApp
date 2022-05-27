//
//  BaseVC.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    private let backgroundImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "backgroundMain"))
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    private let backgroundAlphaView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.7)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        setUpUI()
    }

    private func setUpUI() {
        view.backgroundColor = .black
        view.addSubview(backgroundImage)
        view.addSubview(backgroundAlphaView)
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backgroundAlphaView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundAlphaView.leftAnchor.constraint(equalTo: view.leftAnchor),
            backgroundAlphaView.rightAnchor.constraint(equalTo: view.rightAnchor),
            backgroundAlphaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
