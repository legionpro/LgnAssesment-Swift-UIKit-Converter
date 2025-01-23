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
        let str = list[0].value  //.deleteLeadingZeros()
        let delim = Character(Constants.delimiter.rawValue)
        let characters = Array(list[0].value)
        let indexOfDelimiter = characters.firstIndex(of: delim) ?? -1
        guard (indexOfDelimiter < 0 && tag == Constants.delimiter) || (tag != Constants.delimiter) else {return}
        guard (((characters.count - indexOfDelimiter) <= 2) && (tag != Constants.delimiter)) || ( (indexOfDelimiter < 0)) else {return}
        guard characters.count < Constants.FavoriteCurrencyTableView.primaryMaxChars else {return}
        let result = str + tag.rawValue
        if indexOfDelimiter == 1 || (result.count <= 2 && indexOfDelimiter < 0 && tag == Constants.delimiter) {
            list[0].value = result
        } else {
            list[0].value = result.deleteLeadingZeros()
        }
    }
    
    func deleteSymbolFromToPrimaryValue() {
        guard list.count > 1 else {return}
        if list[0].value.count > 1 {
            list[0].value.removeLast()
        } else {
            list[0].value = "0"
        }
    }
    
    func cleanToPrimaryValue() {
        guard list.count > 1 else {return}
        list[0].value = "0"
    }
        
    func setValueConvertedValue(code: String, value: String) {
        guard let item = list.first(where: {$0.code == code}) else { return }
        item.value = value
    }
    
    func getCurrencyValue(_ index: Int) -> String {
        guard list.count >= index - 1 else {return "0"}
        return list[index].value
    }
}
