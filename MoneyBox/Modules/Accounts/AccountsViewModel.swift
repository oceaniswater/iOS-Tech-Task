////
////  AccountsViewModel.swift
////  MoneyBox
////
////  Created by Mark Golubev on 25/03/2024.
////

import Foundation
import Networking

protocol AccountsNavigation: AnyObject {
    func goToDetailsScreen(account: Account)
    func goToRootScreen()
}

protocol AccountsViewModelTableProtocol: AnyObject {
    var products: [ProductResponse] { get set }
    var accounts: [(account: Account, totalMoney: Double)] { get set }
    
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

protocol AccountsViewModelProtocol: AccountsViewModelTableProtocol {
    var navigation: AccountsNavigation? { get set }
    var view: AccountsViewControllerDelegate? { get set }
    
    func getUser() -> String
    func getData()
    func refresh()
    func goToDetails(account: Account)
    func goToRoot()
}

class AccountsViewModel: AccountsViewModelProtocol {
    
    weak var navigation: AccountsNavigation?
    weak var view: AccountsViewControllerDelegate?
    private let dataProvider: DataProviderLogic
    private let tokenManager: TokenManagerProtocol
    private var user: User?
    var products: [ProductResponse] = []
    var accounts: [(account: Account, totalMoney: Double)] = []
    
    init(dataProvider: DataProviderLogic, tokenManager: TokenManagerProtocol, user: User?) {
        self.dataProvider = dataProvider
        self.tokenManager = tokenManager
        self.user = user
    }
    
    func getUser() -> String {
        guard let user = self.user else { return "Moneyboxer"}
        return user.firstName ?? "Moneyboxer"
    }
    
    func getData() {
        view?.isLoading(true)
        dataProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.handleDataSuccess(success)
            case .failure(let failure):
                self.handleDataFailure(failure)
            }
            self.view?.isLoading(false)
        }
    }
    
    func refresh() {
        tokenManager.saveToken("r2zla51MZLfw8aN8sh+iGJM96RX/T+uEaO7UMi3SKxQ=")
        getData()
    }
    
    func goToDetails(account: Account) {
        navigation?.goToDetailsScreen(account: account)
    }
    
    func goToRoot() {
        navigation?.goToRootScreen()
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return accounts.count
    }
    
    // MARK: - Private Methods
    
    private func handleDataSuccess(_ success: AccountResponse) {
        products = success.productResponses ?? []
        accounts = calculateTotalMoneyByAccount(accountResponse: success)
        let totalSaved = accounts.map { $0.totalMoney }.reduce(0, +)
        view?.totalsAreRecieved(totalPlan: success.totalPlanValue, totalSaved: totalSaved)
        view?.accountsAreRecieved()
    }
    
    private func handleDataFailure(_ failure: Error) {
        view?.showError(message: failure.localizedDescription) { [weak self] in
            self?.goToRoot()
        }
        tokenManager.deleteToken()
        UserDefaultsManager.shared.deleteUser()
    }
    
    private func calculateTotalMoneyByAccount(accountResponse: AccountResponse) -> [(account: Account, totalMoney: Double)] {
        guard let accounts = accountResponse.accounts else { return [] }
        var result: [(account: Account, totalMoney: Double)] = []
        for account in accounts {
            var money = 0.0
            for product in products {
                if account.wrapper?.id == product.wrapperID {
                    money += product.moneybox ?? 0.0
                }
            }
            result.append((account: account, totalMoney: money))
        }
        return result
    }
}
