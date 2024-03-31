//
//  DetailsViewModel.swift
//  MoneyBox
//
//  Created by Mark Golubev on 25/03/2024.
//

import Foundation
import Networking

protocol DetailsNavigation: AnyObject {
    func goToDetailsScreen()
    func goToAccountsScreen()
    func goToRootScreen()
}

protocol DetailsViewModelTableProtocol: AnyObject {
    func numberOfSections() -> Int
    func numberOfRows(in section: Int) -> Int
    
    var selectedProduct: ProductResponse? { get set }
}

protocol DetailsViewModelProtocol: DetailsViewModelTableProtocol {
    var navigation              : DetailsNavigation? { get set }
    var dataProvider            : DataProvider { get set }
    var view                    : DetailsViewControllerDelegate? { get set }
    var tokenManager            : TokenManager { get set }
    var products                : [ProductResponse] { get set }
    var selectedProduct         : ProductResponse? { get set }
    var account                 : Account { get set }
    
    func addMoney()
    func getFilteredData(account: Account)
    func getTitle() -> String
    func enableAddMoneyButton()
}

class DetailsViewModel: DetailsViewModelProtocol {
    weak var navigation         : DetailsNavigation?
    var dataProvider            : DataProvider
    weak var view               : DetailsViewControllerDelegate?
    var tokenManager            : TokenManager
    
    var products                : [ProductResponse] = []
    var selectedProduct         : ProductResponse?
    var account                 : Account
    
    init(nav                    : DetailsNavigation,
         dataProvider           : DataProvider,
         view                   : DetailsViewControllerDelegate,
         tokenManager           : TokenManager,
         account                : Account) {
        
        self.navigation         = nav
        self.dataProvider       = dataProvider
        self.view               = view
        self.tokenManager       = tokenManager
        self.account            = account
    }
    
    func addMoney() {
        guard let productId = selectedProduct?.id else { return }
        view?.isLoading(true)
        let request = OneOffPaymentRequest(amount: 10, investorProductID: productId)
        dataProvider.addMoney(request: request) { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success( _):
                    self.getFilteredData(account: self.account)
                case .failure(let failure):
                    self.view?.showError(message: failure.localizedDescription, dismissHandler: {
                        self.goToRoot()
                    })
                }
                self.view?.isLoading(false)
        }
    }
    
    func getFilteredData(account: Account) {
        guard let accountId = account.wrapper?.id else { return }
        view?.isLoading(true)
        dataProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
                switch result {
                case .success(let success):
                    self.products = success.productResponses?.filter { $0.wrapperID == accountId} ?? []
                    self.view?.productsUpdated()
                    self.setupSelectedProduct()
                case .failure(let failure):
                    self.tokenManager.deleteToken()
                    UserDefaultsManager.shared.deleteUser()
                    self.view?.showError(message: failure.localizedDescription, dismissHandler: {
                        self.goToRoot()
                    })
                    
                }
                self.view?.isLoading(false)
        }
    }
    
    func getTitle() -> String {
        return account.name ?? "Your products"
    }
    
    private func setupSelectedProduct() {
        if products.count == 1 {
            selectedProduct = products.first
            view?.hideSelectProductLabel(true)
        } else {
            selectedProduct = nil
            view?.hideSelectProductLabel(false)
            view?.changeAddMoneyButtonState(false)
        }
    }
    
    func enableAddMoneyButton() {
        view?.changeAddMoneyButtonState(true)
        view?.hideSelectProductLabel(true)
    }
    
    func goToRoot() {
        navigation?.goToRootScreen()
    }
    
    deinit {
        print("Deinit details view model")
    }
}

// MARK: - DetailsViewModelTableProtocol
extension DetailsViewModel {
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfRows(in section: Int) -> Int {
        self.products.count
    }
}
