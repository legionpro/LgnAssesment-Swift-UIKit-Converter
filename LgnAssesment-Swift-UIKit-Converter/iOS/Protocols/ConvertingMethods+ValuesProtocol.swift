//
//  ConvertingMethods+ValuesProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation

protocol ConvertingValuesProtocol {
    var list: [ConvertingValuesInfo] { get set }
}


protocol ConvertingMethodsProtocol {
    func addSymbolToPrimaryValue(_ tag: BoardKeysTags)
    func deleteSymbolFromToPrimaryValue()
    func cleanToPrimaryValue()
    func setValueConvertedValue(code: String, value: String)
}
