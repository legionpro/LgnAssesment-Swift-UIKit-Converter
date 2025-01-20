//
//  Constants.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

struct Constants {
    static let color1 = UIColorFromRGB(rgbValue: 0x025951)
    static let color2 = UIColorFromRGB(rgbValue: 0x088c42)
    static let color3 = UIColorFromRGB(rgbValue: 0x0d6e37)
    static let color4 = UIColorFromRGB(rgbValue: 0xd4d9ad)
    static let color5 = UIColorFromRGB(rgbValue: 0x733f2c)
    static let keyBoardColor = color5.withAlphaComponent(0.03)
    static let keyBoardColorisHighlighted = color5.withAlphaComponent(0.1)
    static let maxFavoriteCurrencyNumber = 4
    
    struct mainController {
        static let contentMargines: CGFloat = 8
        static let pageControlHeight: CGFloat = 30
    }
    
    struct FavoriteCurrencyTableView {
        static let cellHeight: CGFloat = 60.0
        static let flagImageHeight: CGFloat = 100.0
        static let flagImageWidth: CGFloat = 100.0
        static let flagFontSize: CGFloat = 80.0
        static let cellLinesImageWidth: CGFloat = 20.0
        static let contentMargin: CGFloat = 8.0
        static let primaryDefaultValue = "100"
        static let defaultValue = "0"
        static let codeFontSize: CGFloat = 21.0
        static let valueFontSize: CGFloat = 36.0
        static let textColor: UIColor = .black
    }
    
    struct CurrencyListViewCell {
        static let cellHeight: CGFloat = 60.0
        static let codeFontSize: CGFloat = 21.0
        static let nameFontSize: CGFloat = 21.0
        static let flagImageHeight: CGFloat = 60.0
        static let flagImageWidth: CGFloat = 60.0
        static let favoriteHeight: CGFloat = 20.0
        static let favoriteWidth: CGFloat = 20.0
        static let flagFontSize: CGFloat = 60.0
        static let contentMargin: CGFloat = 8.0
    }

    
    static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
