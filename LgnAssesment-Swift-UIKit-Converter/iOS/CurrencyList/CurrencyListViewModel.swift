//
//  CurrencyListViewModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation
import Combine

class CurrencyListViewModel: CurrencyListViewModelProtocol, ObservableObject {

    internal var dataModel: CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol
    
    var curencyListElementPublisher = PassthroughSubject<Int, Never>()
    
    init(dataModel: CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol) {
        self.dataModel = dataModel
        //self.setDataToUserDefaults()
    }
    
    var mainList: [CurrencyInfo] {
        return dataModel.mainCurrencyList
    }
    
    var primaryCurrencySelectionFlag: Bool {
        get {
            return dataModel.primaryCurrencySelectionFlag
        }
        set {
            dataModel.primaryCurrencySelectionFlag = newValue
        }
    }
    
    func getCurrencyValue(_ index: Int) -> String {
        return dataModel.convertingValues.getCurrencyValue(index)
    }
    
    // just to get correct list of favorite currency
    var favoriteCurrencyList: [CurrencyInfo] {
        dataModel.mainCurrencyListValidate()
        var result = dataModel.mainCurrencyList.filter({$0.isFavorite && $0.isPrimary == false})
        if let item = dataModel.mainCurrencyList.first(where: {$0.isPrimary == true}) {
            result.insert(item, at: 0)
        } else {
            result[0].isPrimary = true
        }
        return result
    }
    
    func toggleFavorite(at index: Int) {
        dataModel.toggleFavorite(at: index)
        curencyListElementPublisher.send(index)
    }
    
    func setPrimary(at index: Int) {
        dataModel.setPrimary(at: index)
        curencyListElementPublisher.send(index)
    }
    
    func setDataToUserDefaults() {
        dataModel.setValuesToUserDefaults()
    }

}


extension CurrencyListViewModel: ConvertingMethodsProtocol {

        func addSymbolToPrimaryValue(_ tag: BoardKeysTags) {
            dataModel.convertingValues.addSymbolToPrimaryValue(tag)
            curencyListElementPublisher.send(0)
        }
    
        func deleteSymbolFromToPrimaryValue() {
            dataModel.convertingValues.deleteSymbolFromToPrimaryValue()
            curencyListElementPublisher.send(0)
        }
    
        func cleanToPrimaryValue() {
            dataModel.convertingValues.cleanToPrimaryValue()
            curencyListElementPublisher.send(0)
        }
            
        func setValueConvertedValue(code: String, value: String) {
            dataModel.convertingValues.setValueConvertedValue(code: code, value: value)
        }
}
