//
//  CurrencyListViewModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation
import Combine

class CurrencyListViewModel: CurrencyListViewModelProtocol, ObservableObject {
//    @Published var currentValue = ""
//    @Published var lastUpdated = Date()
    internal var dataModel: CurrencyListModelProtocol
    
    init(dataModel: CurrencyListModelProtocol) {
        self.dataModel = dataModel
    }
    
    var mainList: [CurrencyInfo] {
        return dataModel.mainCurrencyList
    }
    
    // just to get correct list of favorite currency
    var favoriteCurrencyList: [CurrencyInfo] {
        dataModel.mainCurrencyListValidate()
        return mainList.filter({$0.isFavorite == true})
    }
    
    var curencyListElementPublisher = PassthroughSubject<Int, Never>()
    
    lazy var currencyListPublisher: AnyPublisher<CurrencyInfo,Never> = {
        return mainList.publisher
            .map{$0}
            .eraseToAnyPublisher()
    }()
    
//    lazy var currencyListPublisher: AnyPublisher<CurrencyInfo,Never> = {
//    return dataModel.$currencyList
////            .print("-----------------111111----")
//            .map{$0}
//            .eraseToAnyPublisher()
//    }()
    
    
    func changeFavorite(at index: Int) {
        mainList[index].isFavorite.toggle()
        
        dataModel
    }
}
