//
//  String+Extensions.swift
//  MoneyBox
//
//  Created by Mark Golubev on 29/03/2024.
//

import Foundation

extension Double {
    func toMoneyFormatString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2 // Ensure at least two digits after the decimal point
        formatter.maximumFractionDigits = 2 // Maximum two digits after the decimal point

        // Convert the Double to NSNumber
        let number = NSNumber(value: self)

        // Format the NSNumber into a String
        guard let formattedString = formatter.string(from: number) else {
            return ""
        }

        return formattedString
    }
}
