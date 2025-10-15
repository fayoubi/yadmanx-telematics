//
//  Theme.swift
//  DemoSwiftApp
//
//  App-wide color scheme and styling
//

import UIKit

struct Theme {
    // Color Palette - Green Theme (matching desired design)
    static let primaryGreen = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    static let lightGreen = UIColor(red: 129/255, green: 199/255, blue: 132/255, alpha: 1.0)
    static let paleGreen = UIColor(red: 200/255, green: 230/255, blue: 201/255, alpha: 1.0)
    static let backgroundColor = UIColor.systemBackground
    static let secondaryBackground = UIColor.secondarySystemBackground
    static let textPrimary = UIColor.label
    static let textSecondary = UIColor.secondaryLabel
    static let separator = UIColor.separator

    // Status Colors
    static let scoreExcellent = UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0)
    static let scoreGood = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1.0)
    static let scoreAverage = UIColor(red: 255/255, green: 193/255, blue: 7/255, alpha: 1.0)
    static let scorePoor = UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1.0)

    // Typography
    static let titleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    static let bodyFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let captionFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let boldBodyFont = UIFont.systemFont(ofSize: 15, weight: .semibold)

    // Spacing
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 12

    // Helper Methods
    static func scoreColor(for score: Int?) -> UIColor {
        guard let score = score else { return textSecondary }

        switch score {
        case 90...100:
            return scoreExcellent
        case 75..<90:
            return scoreGood
        case 60..<75:
            return scoreAverage
        default:
            return scorePoor
        }
    }
}
