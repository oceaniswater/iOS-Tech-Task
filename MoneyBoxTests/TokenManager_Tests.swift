//
//  TokenManager_Tests.swift
//  MoneyBoxTests
//
//  Created by Mark Golubev on 01/04/2024.
//

import XCTest
import Networking

@testable import MoneyBox
final class TokenManager_Tests: XCTestCase {
    
    var tokenManager: TokenManagerProtocol!

    override func setUpWithError() throws {
        let sessionManager = SessionManager()
        tokenManager = TokenManager(sessionManager: sessionManager)
    }

    override func tearDownWithError() throws {
        tokenManager = nil
    }

    func test_TokenManager_saveToken_succes() throws {
        let testToken = "testToken"
        tokenManager.saveToken(testToken)
        let token = tokenManager.getToken()
        
        XCTAssertEqual(testToken, token)
    }
    
    func test_TokenManager_deleteToken_succes() throws {
        let testToken = "testToken"
        tokenManager.saveToken(testToken)
        tokenManager.deleteToken()
        let token = tokenManager.getToken()
        
        XCTAssertNil(token)
    }

}
