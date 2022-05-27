//
//  ReportScreenViewController.swift
//  Cafe&Bar Tunnel
//
//  Created by Ted on 04.05.2022.
//

import Foundation
import UIKit

final class ReportScreenViewController: BaseViewController {

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

    private let tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: UITableView.Style.grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()

    private let viewModel: ReportScreenViewModel

    init(viewModel: ReportScreenViewModel) {
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
        tableView.register(ReportItemCell.self)
        tableView.register(ReportAnualItemCell.self)
    }

    private func setUpLayout() {
        view.addSubviewsWithoutAutoresizing(tableView, backButton)
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 48),
            backButton.widthAnchor.constraint(equalToConstant: 100),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
        ])
    }

    private func setupTargets() {
        backButton.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
    }

    @objc private func backButtonTap() {
        viewModel.toSettings()
    }
}

extension ReportScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModel.cellData(for: indexPath)
        let cell = tableView.dequeueReusableCell(withModel: viewModel, for: indexPath)
        viewModel.configureAny(cell)
        return cell
    }
}
