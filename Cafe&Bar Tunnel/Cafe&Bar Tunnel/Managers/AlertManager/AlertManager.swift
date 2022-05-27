//
//  AlertManager.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 30.04.2022.
//

import Foundation
import UIKit

public class AlertManager {
    public static let shared = AlertManager()
    private init() {}
    private static let alertObserverId = "Alert Manager"
    public var alertObserver = Observer<Bool>(value: false)
    public private(set) var pendingAlertViews: [UIView] = []

    public func addAlertView(_ alertView: UIView) {
        if pendingAlertViews.contains(alertView) {
            return
        }
        pendingAlertViews.append(alertView)
        alertObserver.post(value: true)
    }

    private func showAlert(animated: Bool = true) {
        DispatchQueue.main.async {
            guard let screen = UIApplication.shared.currentWindow else {
                self.alertObserver.post(value: true)
                return
            }
            guard self.pendingCount > 0 else { return }
            guard let alert = self.topAlert else { return }
            if self.alertIsAlreadyShowing {
                return
            }
            screen.endEditing(true)
            screen.addSubviewsWithoutAutoresizing(alert)
            NSLayoutConstraint.activate([
                alert.topAnchor.constraint(equalTo: screen.topAnchor),
                alert.leftAnchor.constraint(equalTo: screen.leftAnchor),
                alert.rightAnchor.constraint(equalTo: screen.rightAnchor),
                alert.bottomAnchor.constraint(equalTo: screen.bottomAnchor),
            ])

            self.pendingAlertViews.remove(at: 0)
        }
    }

    public func dismissAlert() {
        guard let screen = UIApplication.shared.currentWindow else { return }
        for view in screen.subviews where view is BaseAlert {
            view.removeFromSuperview()
            self.alertObserver.post(value: true)
        }
    }

    internal func setupAlertChangeObserver() {
        alertObserver.bind(id: Self.alertObserverId) { _, queueHasChanged in
            if queueHasChanged {
                self.showAlert()
            }
        }
    }

    private var alertIsAlreadyShowing: Bool {
        guard let screen = UIApplication.shared.currentWindow else { return false }
        for view in screen.subviews where view is BaseAlert {
                return true
        }
        return false
    }

    public var pendingCount: Int {
        self.pendingAlertViews.count
    }

    public var hasPendingAlerts: Bool {
        pendingCount == 0
    }

    private var topAlert: UIView? {
        guard let topAlert = pendingAlertViews.first else { return nil }
        return topAlert
    }
}
extension UIApplication {
    var currentWindow: UIWindow? {
        UIApplication.shared.keyWindow
    }
}
