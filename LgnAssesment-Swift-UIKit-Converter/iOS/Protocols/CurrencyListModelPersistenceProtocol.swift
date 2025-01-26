//
//  CurrencyListModelPersistenceProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation

// for persistence in nodel and for mediators

protocol CurrencyListModelPersistenceProtocol {
    static var key: String { get }
    func getValuesFromUserDefaults() -> [ConvertingValuesInfo]
    mutating func resetValuesOnInit()
    mutating func setValuesToUserDefaults()
}
