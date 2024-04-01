//
//  String+Extensions_Tests.swift
//  MoneyBoxTests
//
//  Created by Mark Golubev on 01/04/2024.
//

import XCTest

@testable import MoneyBox
final class Double_Extensions_Tests: XCTestCase {

    func test_StringExtensions_fromDoubleToMoneyFormatString_succes() throws {
        let testDoubles: [Double]     = [1234.0, 1234.52, 12345.0, 123456.22, 1234567.0, 1234567890.01]
        let expectedStrings           = ["1,234.00", "1,234.52", "12,345.00", "123,456.22", "1,234,567.00", "1,234,567,890.01"]
        var result: [String] = []
        
        for testDouble in testDoubles {
            result.append(testDouble.toMoneyFormatString())
        }
        
        XCTAssertEqual(expectedStrings, result)
    }
}
