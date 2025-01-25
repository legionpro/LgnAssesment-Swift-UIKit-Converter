//
//  CurrencyListModelProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 20.01.2025.
//

import Combine
import Foundation

protocol CurrencyListDataModelProtocol {
    var dataModel:
        CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol
    { get set }
}

protocol CurrencyListModelProtocol {
    var convertingValues: ConvertingValuesProtocol & ConvertingMethodsProtocol {
        get
    }
    var mainCurrencyList: [CurrencyInfo] { get }
    var primaryCurrencySelectionFlag: Bool { get set }
    func mainCurrencyListValidate()
    mutating func toggleFavorite(at index: Int) -> Bool
    mutating func setPrimary(at index: Int) -> Bool
}
