//
//  MainScreenCoordinator.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class MainScreenCoordinator {

    enum Flow {
        case toSettings
    }

    var routing: (Flow) -> Void = { _ in }
    private var navController: UINavigationController
    private let settingsCoordinator: SettingsScreenCoordinator

    init(_ navController: UINavigationController) {
        self.navController = navController
        self.settingsCoordinator = SettingsScreenCoordinator(navController)
    }

    func start() -> UIViewController {
        let model = MainScreenViewModelImpl()
        bindMainScreenVM(model)
        let controller = MainScreenViewController(viewModel: model)
        return controller
    }

    private func bindMainScreenVM(_ model: MainScreenViewModel) {
        model.routing = { [weak self] flow in
            switch flow {
            case .toSettings:
                self?.showSettings()
            case .exit:
                print("exit")
            }
        }
    }

    private func showSettings() {
        let controller = settingsCoordinator.start()
        navController.pushViewController(controller, animated: true)
    }
}
