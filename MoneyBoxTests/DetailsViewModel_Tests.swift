//
//  DetailsViewModel_Tests.swift
//  MoneyBoxTests
//
//  Created by Mark Golubev on 31/03/2024.
//

import XCTest
@testable import MoneyBox
@testable import Networking

final class DetailsViewModel_Tests: XCTestCase {
    
    // Mock dependencies
    class MockNavigation: DetailsNavigation {
        func goToDetailsScreen() {}
        func goToAccountsScreen() {}
        func goToRootScreen() {}
    }
    
    class MockDataProvider: DataProviderLogic {
        var moneyboxResult: Result<OneOffPaymentResponse, Error>?
        var productsResult: Result<AccountResponse, Error>?
        
        func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, Error>) -> Void)) {
            if let result = moneyboxResult {
                completion(result)
            }
        }
        
        func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void)) {
            if let result = productsResult {
                completion(result)
            }
        }
        
        func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, Error>) -> Void)) {}
    }
    
    class MockView: DetailsViewControllerDelegate {
        var productsUpdatedCalled = false
        var showErrorCalled = false
        
        func productsUpdated() {
            productsUpdatedCalled = true
        }
        
        func showError(message: String, dismissHandler: (() -> Void)?) {
            showErrorCalled = true
        }
        
        func isLoading(_ isActive: Bool) {}
        
        func hideSelectProductLabel(_ isHidden: Bool) {}
        
        func changeAddMoneyButtonState(_ isEnabled: Bool) {}
    }
    
    class MockTokenManager: TokenManagerProtocol {
        var deleteTokenCalled = false
        
        func saveToken(_ token: String) {}
        
        func getToken() -> String? { "GuQfJPpjUyJH10Og+hS9c0ttz4q2ZoOnEQBSBP2eAEs=" }
        
        func deleteToken() {
            deleteTokenCalled = true
        }
    }
    
    var viewModel: DetailsViewModel!
    var mockNavigation: MockNavigation!
    var mockDataProvider: MockDataProvider!
    var mockView: MockView!
    var mockTokenManager: MockTokenManager!
    var account: Account!
    
    override func setUpWithError() throws {
        mockNavigation = MockNavigation()
        mockDataProvider = MockDataProvider()
        mockView = MockView()
        mockTokenManager = MockTokenManager()
        account = createAccount(id: "b9eaa523-cdd5-46c6-8353-9d538da845e0", name: "Stocks & Shares ISA")
        
        viewModel = DetailsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, account: account)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
    }
    
    override func tearDownWithError() throws {
        mockNavigation = nil
        mockDataProvider = nil
        mockView = nil
        mockTokenManager = nil
        viewModel.navigation = nil
        viewModel.view = nil
        viewModel = nil
        account = nil
        super.tearDown()
    }
    
    func test_DetailsViewModel_getTitle_success() throws {
        let expectedTitle = "Stocks & Shares ISA"
        
        let actualTitle = viewModel.getTitle()
        
        XCTAssertEqual(expectedTitle, actualTitle)
    }
    
    func test_DetailsViewModel_getFilteredData_success() throws {
        let account = createAccount(id: "b9eaa523-cdd5-46c6-8353-9d538da845e0", name: "Stocks & Shares ISA")
        
        let viewModel = DetailsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, account: account)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
        
        let accountId = viewModel.account.wrapper?.id
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        viewModel.getFilteredData()
        
        let filteredData = viewModel.products
        
        for product in filteredData {
            let productAccountId = product.wrapperID
            XCTAssertEqual(accountId, productAccountId)
        }
    }
    
    func test_DetailsViewModel_getFilteredData_failure() throws {
        // Stub failure response
        let error = NSError(domain: "Test error", code: 500, userInfo: nil)
        mockDataProvider.productsResult = .failure(error)
        
        viewModel.getFilteredData()
        
        XCTAssertEqual(viewModel.products.count, 0)
        
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertTrue(mockTokenManager.deleteTokenCalled)
    }
    
    func test_DetailsViewModel_setupSelectedProduct_nil() throws {
        let account = createAccount(id: "b9eaa523-cdd5-46c6-8353-9d538da845e0", name: "Stocks & Shares ISA")
        
        let viewModel = DetailsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, account: account)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        viewModel.getFilteredData()
        
        XCTAssertNil(viewModel.selectedProduct)
    }
    
    func test_DetailsViewModel_setupSelectedProduct_notNil() throws {
        let account = createAccount(id: "e7bdfeb4-23c7-44d6-88f5-04dc0c7ab99d", name: "Lifetime ISA")
        
        let viewModel = DetailsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, account: account)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        viewModel.getFilteredData()
        
        XCTAssertNotNil(viewModel.selectedProduct)
    }
    
    func test_DetailsViewModel_addMoney_success() throws {
        let account = createAccount(id: "e7bdfeb4-23c7-44d6-88f5-04dc0c7ab99d", name: "Lifetime ISA")
        
        let viewModel = DetailsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, account: account)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
        
        // Stub success response
        StubData.read(file: "AddMoneySuccess") { [weak self] (result: Result<OneOffPaymentResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.moneyboxResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        viewModel.getFilteredData()
        
        viewModel.addMoney()
        
        XCTAssertTrue(mockView.productsUpdatedCalled)
    }
    
    func test_DetailsViewModel_addMoney_failure() throws {
        let account = createAccount(id: "e7bdfeb4-23c7-44d6-88f5-04dc0c7ab99d", name: "Lifetime ISA")
        
        let viewModel = DetailsViewModel(dataProvider: mockDataProvider, tokenManager: mockTokenManager, account: account)
        viewModel.navigation = mockNavigation
        viewModel.view = mockView
        
        // Stub success response
        let error = NSError(domain: "", code: 500, userInfo: nil)
        mockDataProvider.moneyboxResult = .failure(error)
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        viewModel.getFilteredData()
        
        viewModel.addMoney()
        
        XCTAssertTrue(mockView.showErrorCalled)
    }
    
    func test_AccountsViewModel_numberOfRows_productsCount() throws {
        var expectedNumber: Int!
        
        StubData.read(file: "Accounts") { [weak self] (result: Result<AccountResponse, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.mockDataProvider.productsResult = .success(response)
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        viewModel.getFilteredData()
        
        expectedNumber = viewModel.products.count
        
        let actualNumber = viewModel.numberOfRows(in: 1)
        
        XCTAssertEqual(expectedNumber, actualNumber)
    }
    
    func test_AccountsViewModel_numberOfRows_zero() throws {
        let expectedNumber = 0
        
        let actualNumber = viewModel.numberOfRows(in: 1)
        
        XCTAssertEqual(expectedNumber, actualNumber)
    }
    
    func test_AccountsViewModel_numberOfSections_one() throws {
        let number = viewModel.numberOfSections()
        
        XCTAssertEqual(number, 1)
    }
}

func createAccount(id: String, name: String) -> Account {
    return Account(
        type: "ISA",
        name: name,
        deepLinkIdentifier: "Mock Deep Link",
        wrapper: Wrapper(
            id: id,
            definitionGlobalID: "Mock Definition Global ID",
            totalValue: 1000.0,
            totalContributions: 500,
            earningsNet: 100.0,
            earningsAsPercentage: 10.0,
            returns: Returns(
                simple: 50.0,
                lifetime: 500.0,
                annualised: 20.0
            )
        ),
        milestone: Milestone(
            initialStage: "Mock Initial Stage",
            endStage: "Mock End Stage",
            endStageID: 123
        ),
        hasCollections: true
    )
}
