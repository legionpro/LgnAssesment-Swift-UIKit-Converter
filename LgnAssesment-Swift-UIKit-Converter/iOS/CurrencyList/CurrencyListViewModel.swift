//
//  CurrencyListViewModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation
import Combine

class CurrencyListViewModel: CurrencyListViewModelProtocol, ObservableObject {
   
    internal var dataModel: CurrencyListModelProtocol
    
    var curencyListElementPublisher = PassthroughSubject<Int, Never>()
    
    init(dataModel: CurrencyListModelProtocol) {
        self.dataModel = dataModel
    }
    
    var mainList: [CurrencyInfo] {
        return dataModel.mainCurrencyList
    }
    
    // just to get correct list of favorite currency
    var favoriteCurrencyList: [CurrencyInfo] {
        return dataModel.mainCurrencyList.filter({$0.isFavorite})
    }
    
    func toggleFavorite(at index: Int) {
        dataModel.toggleFavorite(at: index)
        curencyListElementPublisher.send(index)
    }
}
