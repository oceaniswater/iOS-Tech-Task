//
//  AccountsViewController+TableView.swift
//  MoneyBox
//
//  Created by Mark Golubev on 26/03/2024.
//

import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource
extension AccountsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.registerTableCell()
    }
    
    func registerTableCell() {
        tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: AccountTableViewCell.identifier)
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountTableViewCell.identifier, for: indexPath) as? AccountTableViewCell else { return UITableViewCell() }
        
        guard let item = self.viewModel?.products[indexPath.row] else { return UITableViewCell() }
        cell.configure(with: item)
        cell.selectionStyle = .none
        
        return cell
        
    }
}
