//
//  CurrencyListModelProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 20.01.2025.
//

import Foundation

protocol CurrencyListModelProtocol {
    var primaryValue: String { get set }
    var mainCurrencyList: [CurrencyInfo]  { get }
    var primaryCurrencySelectionFlag: Bool { get set }
    func mainCurrencyListValidate()
    func toggleFavorite(at index: Int)
    func setPrimary(at index: Int)
}
