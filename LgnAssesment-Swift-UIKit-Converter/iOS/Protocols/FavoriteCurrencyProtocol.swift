//
//  FavoriteCurrencyProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation

protocol FavoriteCurrencyProtocol: AnyObject {
    
    var primaryCurrencySelectionFlag: Bool { get set }
    func addCurrencyAsFavorite(currency: CurrencyInfo)
}
