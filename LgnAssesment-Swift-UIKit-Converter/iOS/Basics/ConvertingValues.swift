//
//  ConvertingValues.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation

class ConvertingValues: ConvertingValuesProtocol & ConvertingMethodsProtocol {
    lazy var list: [ConvertingValuesInfo] = {
        []
    }()
    
    func addSymbolToPrimaryValue(_ tag: BoardKeysTags) {
        guard list.count > 1 else {return}
        list[0].value += tag.rawValue
    }
    
    func deleteSymbolFromToPrimaryValue() {
        guard list.count > 1 else {return}
        guard list[0].value.count > 1 else {return}
        list[0].value.removeLast()
    }
    
    func cleanToPrimaryValue() {
        guard list.count > 1 else {return}
        list[0].value = "0"
    }
        
    func setValueConvertedValue(code: String, value: String) {
    }
    
    func getCurrencyValue(_ index: Int) -> String {
        guard list.count >= index - 1 else {return "0"}
        return list[index].value
    }
}
