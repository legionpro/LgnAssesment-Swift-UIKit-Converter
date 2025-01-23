//
//  CurrencyListViewModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation
import Combine

class CurrencyListViewModel: CurrencyListViewModelProtocol, ObservableObject {

    var bag = Set<AnyCancellable>()
    var dataModel: CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol
    private let networkService: NetworkServiceProtocol
    var curencyListElementPublisher = PassthroughSubject<Int, Never>()
    
    init(dataModel: CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol, networkService: NetworkServiceProtocol) {
        self.dataModel = dataModel
        self.networkService = networkService
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


extension CurrencyListViewModel : ValuesListDataMapperProtocol {
    
    func updateCurrencyValuesList() {
        bag = Set<AnyCancellable>()
        let from = dataModel.convertingValues.list[0].code
        let value = dataModel.convertingValues.list[0].value
        for item in dataModel.convertingValues.list {
            if item.code != from {
                resetValuesListItem(from: from, to: item.code, value: value)
            }
        }
    }

    func resetValuesListItem(from: String, to: String, value: String) {
        let pub: AnyPublisher<RequestResponseValue, APIError> = self.networkService.request(
            Endpoint.justGet(value: value, from: from, to: to),
            headers: nil,
            parameters: nil )
        let _ = pub
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                  print("All the requests are done")
                case .failure(let apiError):
                  print("An API error caused a problem \(apiError)")
                }
            } receiveValue: { [self] result in
                    if let value = self.itemResponseToItem(result) {
                        self.dataModel.convertingValues.setValueConvertedValue(code: value.code, value: value.value)
                        
                        
                        for item in self.dataModel.convertingValues.list {
                            print("----------------------------\(item.code)   \(item.value)")
                        }
                        
                        curencyListElementPublisher.send(0)
                    }
              }
              .store(in: &bag)
    }
}
