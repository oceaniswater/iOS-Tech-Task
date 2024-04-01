//
//  UserDefaultsManager_Tests.swift
//  MoneyBoxTests
//
//  Created by Mark Golubev on 01/04/2024.
//

import XCTest
import Networking

@testable import MoneyBox
final class UserDefaultsManager_Tests: XCTestCase {
    
    typealias User = LoginResponse.User
    
    override func tearDownWithError() throws {
        UserDefaultsManager.shared.deleteUser()
    }
    
    func test_UserDefaultsManager_saveUser_succes() throws {
        var testUser: User?
        
        StubData.read(file: "LoginSucceed") { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                testUser = response.user
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        UserDefaultsManager.shared.saveUser(testUser!)
        
        let user = UserDefaultsManager.shared.getUser()
        
        XCTAssertEqual(testUser?.firstName, user?.firstName)
        XCTAssertEqual(testUser?.lastName, user?.lastName)
    }
    
    func test_UserDefaultsManager_deleteUser_succes() throws {
        var testUser: User?
        
        StubData.read(file: "LoginSucceed") {(result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let response):
                testUser = response.user
            case .failure(let error):
                XCTFail("Error reading stub data: \(error.localizedDescription)")
            }
        }
        
        UserDefaultsManager.shared.saveUser(testUser!)
        UserDefaultsManager.shared.deleteUser()
        
        let user = UserDefaultsManager.shared.getUser()
        
        XCTAssertNil(user)
    }
}
