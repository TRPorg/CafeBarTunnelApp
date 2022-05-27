//
//  AppCoordinator.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class AppCoordinator {

    private var navigationController: UINavigationController
    private var mainScreenCoordinator: MainScreenCoordinator

    init () {
        let navController = UINavigationController()
        navController.isNavigationBarHidden = true
        self.navigationController = navController
        mainScreenCoordinator = MainScreenCoordinator(navController)
    }

    func start() -> UIViewController {
        let controller = mainScreenCoordinator.start()
        navigationController.setViewControllers([controller], animated: true)
        return navigationController
    }
}
