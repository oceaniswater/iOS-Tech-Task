//
//  AccountsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol AccountsNavigation : AnyObject {
    func goToDetailsScreen(account: Account)
    func goToRootScreen()
}

protocol AccountsViewModelTableProtocol:  AnyObject {
    var products                        : [ProductResponse] { get set }
    var accounts                        : [(account: Account, totalMoney: Double)] { get set }

    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
}

protocol AccountsViewModelProtocol: AccountsViewModelTableProtocol {
    var navigation              : AccountsNavigation? { get set }
    var view                    : AccountsViewControllerDelegate? { get set }
    var dataProvider            : DataProvider { get set }
    var tokenManager            : TokenManager { get set }
    
    func getUser() -> User?
    func getData()
    func refresh()
    
    func goToDetails(account: Account)
    func goToRoot()
}

class AccountsViewModel: AccountsViewModelProtocol {
    weak var navigation         : AccountsNavigation?
    weak var view               : AccountsViewControllerDelegate?
    var dataProvider            : DataProvider
    var tokenManager            : TokenManager
    
    private var user            : User?
    private var total           : Double = 0.0
    var products                : [ProductResponse] = []
    var accounts                : [(account: Account, totalMoney: Double)] = []
    
    init(nav                    : AccountsNavigation,
         dataProvider           : DataProvider,
         view                   : AccountsViewControllerDelegate,
         tokenManager           : TokenManager,
         user                   : User?) {
        self.navigation         = nav
        self.dataProvider       = dataProvider
        self.view               = view
        self.tokenManager       = tokenManager
        
        self.user               = user
    }
    
    func getUser() -> User? {
        guard let user = user else { return nil}
        return user
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getSavedMoneyByAccount(accountResponse: AccountResponse) -> [(account: Account, totalMoney: Double)]{
        guard let accounts = accountResponse.accounts else { return []}
        let productResponses = accountResponse.productResponses
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
    
    func getTotalSaved() -> Double {
        return accounts.map({$0.totalMoney}).reduce(0, +)
    }
    
    func getData() {
        view?.isLoading(true)
        dataProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.products   = success.productResponses ?? []
                    self.accounts   = self.getSavedMoneyByAccount(accountResponse: success)
                    let totalSaved  = self.getTotalSaved()
                    self.view?.totalsAreRecieved(totalPlan: success.totalPlanValue, totalSaved: totalSaved)
                    self.view?.accountsAreRecieved()
                case .failure(let failure):
                    self.view?.showError(message: failure.localizedDescription, dismissHandler: {
                        self.goToRoot()
                    })
                    self.tokenManager.deleteToken()
                    UserDefaultsManager.shared.deleteUser()
                    
                }
                self.view?.isLoading(false)

        }
    }
    
    func goToDetails(account: Account){
        navigation?.goToDetailsScreen(account: account)
    }
    
    func goToRoot() {
        navigation?.goToRootScreen()
    }
    
    func refresh() {
        tokenManager.saveToken("r2zla51MZLfw8aN8sh+iGJM96RX/T+uEaO7UMi3SKxQ=")
        getData()
    }
    
    deinit {
        print("Deinit Accounts view Model")
    }
}

extension AccountsViewModel {
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.accounts.count
    }
}
