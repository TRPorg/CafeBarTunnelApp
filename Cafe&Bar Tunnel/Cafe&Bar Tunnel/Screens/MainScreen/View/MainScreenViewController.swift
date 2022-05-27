//
//  MainScreenViewController.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class MainScreenViewController: BaseViewController {

    private let headerCell = MainScreenHeaderCell()
    private let footerView = MainScreenFooterView()
    private let tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let viewModel: MainScreenViewModel

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setupTargets()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.loadDataFromDB()
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = true
        tableView.register(DispayItemCell.self)
    }

    private func setUpLayout() {
        view.addSubviewsWithoutAutoresizing(tableView, footerView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),

            footerView.heightAnchor.constraint(equalToConstant: 110),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTargets() {
        footerView.delegate = self
    }
}

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections() + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return viewModel.getNumberOfRows(for: section - 1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            return headerCell
        }
        let viewModel = viewModel.cellData(for: indexPath)
        let cell = tableView.dequeueReusableCell(withModel: viewModel, for: indexPath)
        if let cell = cell as? DispayItemCell {
            cell.delegate = self
        }
        viewModel.configureAny(cell)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        }
        return ItemHeaderView(title: viewModel.getTextForHeader(for: section - 1))
    }
}

extension MainScreenViewController: MainScreenFooterViewDelegate {
    func clearCounters() {
        viewModel.resetCounters()
        tableView.reloadData()
    }

    func askForCheckout() {
        let model = AreYouSureAlert()
        model.yesAction = { [weak self] in
            self?.viewModel.saveCheckoutedItems()
            self?.tableView.reloadData()
        }
        AlertManager.shared.addAlertView(model)
    }

    func openSettings() {
        guard let password = viewModel.getPassword() else { self.viewModel.toSettings(); return }
        let alert = EnterPasswordAlert(password: password)
        alert.correctPassword = {
            self.viewModel.toSettings()
            AlertManager.shared.dismissAlert()
        }
        AlertManager.shared.addAlertView(alert)
    }
}

extension MainScreenViewController: DispayItemCellDelegate {
    func modelChanged(model: CheckoutItemModel) {
        viewModel.modifyModel(model: model)
    }
}
