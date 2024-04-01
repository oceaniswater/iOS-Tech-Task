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
    var products: [ProductResponse] { get set }
}

protocol DetailsViewModelProtocol: DetailsViewModelTableProtocol {
    var navigation: DetailsNavigation? { get set }
    var view: DetailsViewControllerDelegate? { get set }
    
    func addMoney()
    func getFilteredData()
    func getTitle() -> String
    func enableAddMoneyButton()
}

class DetailsViewModel: DetailsViewModelProtocol {
    
    weak var navigation: DetailsNavigation?
    var dataProvider: DataProviderLogic
    weak var view: DetailsViewControllerDelegate?
    var tokenManager: TokenManagerProtocol
    var account: Account
    var products: [ProductResponse] = []
    var selectedProduct: ProductResponse?
    
    init(dataProvider: DataProviderLogic, tokenManager: TokenManagerProtocol, account: Account) {
        self.dataProvider = dataProvider
        self.tokenManager = tokenManager
        self.account = account
    }
    
    func addMoney() {
        guard let productId = selectedProduct?.id else { return }
        view?.isLoading(true)
        let request = OneOffPaymentRequest(amount: 10, investorProductID: productId)
        dataProvider.addMoney(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.getFilteredData()
            case .failure(let failure):
                self.view?.showError(message: failure.localizedDescription) {
                    self.goToRoot()
                }
            }
            self.view?.isLoading(false)
        }
    }
    
    func getTitle() -> String {
        return account.name ?? "Your products"
    }
    
    func enableAddMoneyButton() {
        view?.changeAddMoneyButtonState(true)
        view?.hideSelectProductLabel(true)
    }
    
    func goToRoot() {
        navigation?.goToRootScreen()
    }
    
    func getFilteredData() {
        guard let accountId = account.wrapper?.id else { return }
        view?.isLoading(true)
        dataProvider.fetchProducts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let success):
                self.handleDataSuccess(success, accountId: accountId)
            case .failure(let failure):
                self.handleDataFailure(failure)
            }
            self.view?.isLoading(false)
        }
    }
    
    // MARK: - Private Methods
    
    private func handleDataSuccess(_ success: AccountResponse, accountId: String) {
        guard let filteredProducts = success.productResponses?.filter({ $0.wrapperID == accountId }) else { return }
        self.products = filteredProducts
        self.view?.productsUpdated()
        self.setupSelectedProduct()
    }
    
    private func handleDataFailure(_ failure: Error) {
        self.tokenManager.deleteToken()
        UserDefaultsManager.shared.deleteUser()
        self.view?.showError(message: failure.localizedDescription) {
            self.goToRoot()
        }
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
}

// MARK: - DetailsViewModelTableProtocol
extension DetailsViewModel {
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return self.products.count
    }
}
