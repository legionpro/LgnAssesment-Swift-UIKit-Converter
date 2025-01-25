//
//  CurrencyListViewModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Combine
import Foundation
import OSLog

class CurrencyListViewModel: CurrencyListViewModelProtocol
        & CurrencyListDataModelProtocol, ObservableObject
{

    private var bag = Set<AnyCancellable>()
    var curencyListElementPublisher = PassthroughSubject<Int, Never>()
    var primaryCurrencyValuePublisher = PassthroughSubject<String, Never>()

    var failureFlag = false
    var dataModel:
        CurrencyListModelProtocol & CurrencyListModelPersistenceProtocol
    private let networkService: NetworkServiceProtocol

    init(
        dataModel: CurrencyListModelProtocol
            & CurrencyListModelPersistenceProtocol,
        networkService: NetworkServiceProtocol
    ) {
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

    // just to get correct list of favorite currency
    var favoriteCurrencyList: [CurrencyInfo] {
        dataModel.mainCurrencyListValidate()
        var result = dataModel.mainCurrencyList.filter({
            $0.isFavorite && $0.isPrimary == false
        })
        if let item = dataModel.mainCurrencyList.first(where: {
            $0.isPrimary == true
        }) {
            result.insert(item, at: 0)
        } else {
            result[0].isPrimary = true
        }
        return result
    }

    func toggleFavorite(at index: Int) {
        let res = dataModel.toggleFavorite(at: index)
        curencyListElementPublisher.send(index)
        if  res == false {
            primaryCurrencyValuePublisher.send("")
        }

    }

    func setPrimary(at index: Int) {
        let res = dataModel.setPrimary(at: index)
        curencyListElementPublisher.send(index)
        if  res == false {
            primaryCurrencyValuePublisher.send("")
        }
    }

    func setDataToUserDefaults() {
        dataModel.setValuesToUserDefaults()
    }

}

extension CurrencyListViewModel: ConvertingMethodsProtocol {

    func addSymbolToPrimaryValue(_ tag: BoardKeysTags) -> (Bool, String) {
        let result = dataModel.convertingValues.addSymbolToPrimaryValue(tag)
        if result.0 {
            primaryCurrencyValuePublisher.send(result.1)
        }
        curencyListElementPublisher.send(0)
        return result
    }

    func deleteSymbolFromToPrimaryValue() -> (Bool, String) {
        let result = dataModel.convertingValues.deleteSymbolFromToPrimaryValue()
        if result.0 {
            primaryCurrencyValuePublisher.send(result.1)
        }
        curencyListElementPublisher.send(0)
        return result
    }

    func cleanToPrimaryValue() -> (Bool, String) {
        let result = dataModel.convertingValues.cleanToPrimaryValue()
        if result.0 {
            primaryCurrencyValuePublisher.send(result.1)
        }
        curencyListElementPublisher.send(0)
        return result
    }

    func setValueConvertedValue(code: String, value: String) {
        dataModel.convertingValues.setValueConvertedValue(
            code: code, value: value)
    }

    func getCurrencyValue(index: Int) -> String {
        return dataModel.convertingValues.getCurrencyValue(index: index)
    }

    func getCurrencyValue(code: String) -> String {
        return dataModel.convertingValues.getCurrencyValue(code: code)
    }

    func setPreviousPrimaryValue(_ value: String) {
        dataModel.convertingValues.setPreviousPrimaryValue(value)
    }

    func getPreviousPrimaryValue() -> String {
        return dataModel.convertingValues.getPreviousPrimaryValue()
    }
}

extension CurrencyListViewModel: ValuesListDataMapperProtocol {

    func updateCurrencyValuesList() {
        let array = ["0", "0.0", ".", ".0", "0.00", ".00"]
        bag = Set<AnyCancellable>()
        let from = dataModel.convertingValues.list[0].code
        let value = dataModel.convertingValues.list[0].value
        if !(self.getPreviousPrimaryValue() == value
            && (array.contains(self.getPreviousPrimaryValue())
                && !self.failureFlag))
        {
            for item in dataModel.convertingValues.list {
                if item.code != from {
                    resetValuesListItem(from: from, to: item.code, value: value)
                }
            }
        } else {
            Logger.statistics.debug("API stopped via the value is 0")
        }
    }

    func resetValuesListItem(from: String, to: String, value: String) {
        let pub: AnyPublisher<RequestResponseValue, APIError> = self
            .networkService.request(
                Endpoint.justGet(value: value, from: from, to: to),
                headers: nil,
                parameters: nil)
        let _ =
            pub
            .receive(on: DispatchQueue.main)
            .sink { [self] completion in
                switch completion {
                case .finished:
                    Logger.statistics.debug("=== All the requests are done ===")
                case .failure(let apiError):
                    self.failureFlag = true
                    curencyListElementPublisher.send(0)
                    Logger.statistics.error(
                        "An API error caused a problem \(apiError)")
                }
            } receiveValue: { [self] result in
                if let res = self.itemResponseToItem(result) {
                    self.failureFlag = false
                    self.dataModel.convertingValues.setValueConvertedValue(
                        code: res.code, value: res.value)
                    self.setPreviousPrimaryValue(value)
                    curencyListElementPublisher.send(0)
                }
            }
            .store(in: &bag)
    }
}
