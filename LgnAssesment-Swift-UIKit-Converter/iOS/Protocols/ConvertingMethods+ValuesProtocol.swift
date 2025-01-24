//
//  ConvertingMethods+ValuesProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation
import Combine

protocol ConvertingValuesProtocol {
    var list: [ConvertingValuesInfo] { get set }
}

protocol ConvertingMethodsProtocol {
    func addSymbolToPrimaryValue(_ tag: BoardKeysTags) -> (Bool, String)
    func deleteSymbolFromToPrimaryValue() -> (Bool, String)
    func cleanToPrimaryValue() -> (Bool, String)
    func setValueConvertedValue(code: String, value: String)
    func getCurrencyValue(index: Int) -> String
    func getCurrencyValue(code: String) -> String
}
