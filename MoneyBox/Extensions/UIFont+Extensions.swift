//
//  UIFont+Extensions.swift
//  MoneyBox
//
//  Created by Mark Golubev on 31/03/2024.
//

import UIKit

extension UIFont {
    /// Support Dynamic Types Accessibility feature for labels
    /// - Parameters:
    ///   - name: Name of the Font
    ///   - textSize: text szie i.e 10, 15, 20, ...
    /// - Returns: The scaled custom Font version with the given size
    static func scaledFont(name: String, textSize size: CGFloat) -> UIFont {
        guard let customFont = UIFont(name: name, size: size) else {
            fatalError("Failed to load the \(name) font.")
        }
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
    
    static func scaledFont(font: UIFont) -> UIFont {
        return UIFontMetrics.default.scaledFont(for: font)
    }
}
