//
//  SettingsScreenCoordinator.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class SettingsScreenCoordinator {

    private var navController: UINavigationController
    private let reportScreenCoordinator: ReportScreenCoordinator

    init(_ navController: UINavigationController) {
        self.navController = navController
        self.reportScreenCoordinator = ReportScreenCoordinator(navController)
    }

    func start() -> UIViewController {
        let model = SettingsScreenViewModelImpl()
        bindSettingsScreenVM(model)
        let controller = SettingsScreenViewController(viewModel: model)
        return controller
    }

    private func bindSettingsScreenVM(_ model: SettingsScreenViewModel) {
        model.routing = { [weak self] flow in
            switch flow {
            case .toMainScreen:
                self?.navController.popViewController(animated: true)
            case .toReportScreen(let from, let to):
                self?.showReport(from: from, to: to)
            }
        }
    }

    private func showReport(from: Date, to: Date) {
        let controller = reportScreenCoordinator.start(from: from, to: to)
        navController.pushViewController(controller, animated: true)
    }
}
