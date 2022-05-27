//
//  SettingsScreenViewController.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 27.04.2022.
//

import Foundation
import UIKit

final class SettingsScreenViewController: BaseViewController {

    private let footerView = SettingsScreenFooterView()

    private let backButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Назад", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    private let saveButton: UIButton = {
        let button = HighlightedButton()
        button.setTitle("Сохранить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .bold)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 8
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Настройки"
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()


    private let tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let viewModel: SettingsScreenViewModel

    init(viewModel: SettingsScreenViewModel) {
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
        viewModel.loadDataFromDB()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.showsVerticalScrollIndicator = true
        tableView.register(EditableItemCell.self)
    }

    private func setUpLayout() {
        view.addSubviewsWithoutAutoresizing(backButton, saveButton, titleLabel, tableView, footerView)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -28),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -190),

            footerView.heightAnchor.constraint(equalToConstant: 170),
            footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }

    private func setupTargets() {
        footerView.delegate = self
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveData), for: .touchUpInside)
    }

    @objc private func backButtonTap() {
        viewModel.toMainScreen()
    }

    @objc private func saveData() {
        let model = AreYouSureAlert()
        model.yesAction = { [weak self] in
            self?.viewModel.saveDataToDB()
        }
        AlertManager.shared.addAlertView(model)
    }
}

extension SettingsScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(for: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel.cellData(for: indexPath)
        let cell = tableView.dequeueReusableCell(withModel: viewModel, for: indexPath)
        viewModel.configureAny(cell)
        if let cell = cell as? EditableItemCell {
            cell.delegate = self
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = EditableHeaderView(model: viewModel.getModelForHeader(for: section))
        header.delegate = self
        return header
    }
}

extension SettingsScreenViewController: SettingsScreenFooterViewDelegate {
    func changePasswordTap() {
        let model = EnterPasswordAlert(password: nil)
        model.newPassword = { [weak viewModel] password in
            viewModel?.savePassword(password)
        }
        AlertManager.shared.addAlertView(model)
    }

    func reportTap() {
        let model = SelectTimeIntervalAlert()
        model.dateAction = { [weak self] from, to in
            self?.viewModel.toReportScreen(from: from, to: to)
        }
        AlertManager.shared.addAlertView(model)
    }

    func clearDBTap() {
        let model = AreYouSureAlert()
        model.yesAction = { [weak self] in
            self?.viewModel.clearDB()
            self?.tableView.reloadData()
        }
        AlertManager.shared.addAlertView(model)
    }

    func addGroupTap() {
        viewModel.addNewGroupItem(with: "Название")
        tableView.reloadData()
    }
}

extension SettingsScreenViewController: EditableHeaderViewDelegate {
    func textChanged(_ text: String, groupId: Int) {
        viewModel.modifyGroupCellModel(groupId: groupId, name: text)
    }

    func addNewItem(_ groupId: Int) {
        viewModel.insertNewItem(in: groupId)
        tableView.reloadData()
    }

    func deleteCategory(_ groupId: Int) {
        let model = AreYouSureAlert()
        model.yesAction = { [weak self] in
            self?.viewModel.deleteGroupItem(with: groupId)
            self?.tableView.reloadData()
        }
        AlertManager.shared.addAlertView(model)
    }
}

extension SettingsScreenViewController: EditableItemCellDelegate {
    func modelChanged(_ model: CatalogItemModel) {
        viewModel.modifyItemCellModel(model: model)
    }

    func deleteItem(_ id: Int) {
        let model = AreYouSureAlert()
        model.yesAction = { [weak self] in
            self?.viewModel.deleteItem(with: id)
            self?.tableView.reloadData()
        }
        AlertManager.shared.addAlertView(model)
    }
}
