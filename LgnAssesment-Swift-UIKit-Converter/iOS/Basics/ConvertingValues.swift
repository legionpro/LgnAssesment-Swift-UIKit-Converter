//
//  ConvertingValues.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation
import Combine


class ConvertingValues: ConvertingValuesProtocol & ConvertingMethodsProtocol, ObservableObject {
    
    // to trav the value just to avoid multiple request with primaryValue == 0
    var previousPrimaryvalue = ""
    
    func setPreviousPrimaryValue(_ value: String) {
        previousPrimaryvalue = value
    }
    
    func getPreviousPrimaryValue() -> String {
        return previousPrimaryvalue
    }
    
    
    lazy var list: [ConvertingValuesInfo] = {
        []
    }()

    func addSymbolToPrimaryValue(_ tag: BoardKeysTags) -> (Bool, String) {
        let falseResult = (false, "")
        guard list.count > 1 else {return falseResult}
        let str = list[0].value  //.deleteLeadingZeros()
        let delim = Character(Constants.delimiter.rawValue)
        let characters = Array(list[0].value)
        let indexOfDelimiter = characters.firstIndex(of: delim) ?? -1
        guard (indexOfDelimiter < 0 && tag == Constants.delimiter) || (tag != Constants.delimiter) else {return falseResult}
        guard (((characters.count - indexOfDelimiter) <= 2) && (tag != Constants.delimiter)) || ( (indexOfDelimiter < 0)) else {return falseResult}
        guard characters.count < Constants.FavoriteCurrencyTableView.primaryMaxChars else {return falseResult}
        let result = str + tag.rawValue
        if indexOfDelimiter == 1 || (result.count <= 2 && indexOfDelimiter < 0 && tag == Constants.delimiter) {
            list[0].value = result
        } else {
            list[0].value = result.deleteLeadingZeros()
        }
        return (true, list[0].value)
    }
    
    func deleteSymbolFromToPrimaryValue() -> (Bool, String) {
        var flag = false
        guard list.count > 1 else {return (flag, list[0].value) }
        if list[0].value.count > 1 {
            list[0].value.removeLast()
            flag = true
        } else {
            list[0].value = "0"
            flag = true
        }
        return (flag,list[0].value)
    }
    
    func cleanToPrimaryValue() -> (Bool, String) {
        guard list.count > 1 else {return (false,list[0].value) }
        guard list[0].value != "0" else {return (false,list[0].value)}
        list[0].value = "0"
        return (true,list[0].value)
    }
        
    func setValueConvertedValue(code: String, value: String) {
        guard let item = list.first(where: {$0.code == code}) else { return }
        item.value = value
    }
    
    func getCurrencyValue(index: Int) -> String {
        guard list.count >= index - 1 else {return "0"}
        return list[index].value
    }
    
    
    func getCurrencyValue(code: String) -> String {
        guard let item = list.first(where: {$0.code == code}) else { return "" }
        return item.value
    }
}
