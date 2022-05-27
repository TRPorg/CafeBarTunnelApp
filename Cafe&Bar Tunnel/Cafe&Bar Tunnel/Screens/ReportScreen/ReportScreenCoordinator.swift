//
//  ReportScreenCoordinator.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class ReportScreenCoordinator {

    private var navController: UINavigationController

    init(_ navController: UINavigationController) {
        self.navController = navController
    }

    func start(from: Date, to: Date) -> UIViewController {
        let model = ReportScreenViewModelImpl(from: from, to: to)
        bindReportScreenVM(model)
        let controller = ReportScreenViewController(viewModel: model)
        return controller
    }

    private func bindReportScreenVM(_ model: ReportScreenViewModel) {
        model.routing = { [weak self] flow in
            switch flow {
            case .toSettingsScreen:
                self?.navController.popViewController(animated: true)
            }
        }
    }
}
