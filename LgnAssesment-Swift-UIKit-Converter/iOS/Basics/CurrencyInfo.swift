//
//  CurrencyInfo.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation

class CurrencyInfo {
    let code: String
    let symbol: String
    let countryFlag: String
    let name: String
    var isFavorite: Bool
    var isPrimary: Bool
    
    init(code: String, symbol: String, countryFlag: String, name: String, isFavorite: Bool, isPrimary: Bool) {
        self.code = code
        self.symbol = symbol
        self.countryFlag = countryFlag
        self.name = name
        self.isFavorite = isFavorite
        self.isPrimary = isPrimary
    }
}
