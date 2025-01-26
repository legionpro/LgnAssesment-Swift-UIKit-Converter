//
//  CurrencyListModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Combine
import Foundation
import OSLog

// MVVM model for currencyListViewContoller

class CurrencyListModel: CurrencyListModelProtocol {

    var primaryCurrencySelectionFlag = false
    var convertingValues: ConvertingMethodsProtocol & ConvertingValuesProtocol

    var mainCurrencyList: [CurrencyInfo] {
        Constants.CountryCurrencyList
    }

    init(convertingValues: ConvertingMethodsProtocol & ConvertingValuesProtocol)
    {
        self.convertingValues = convertingValues
        resetValuesOnInit()
        resetValuesFromCurrentStateOfMainList()
    }

    // just to validate the list
    func mainCurrencyListValidate() {
        if mainCurrencyList.filter({ $0.isFavorite }).count
            > validMaxCountOfFavoriteCurrecyList()
            || mainCurrencyList.filter({ $0.isFavorite }).count < 1
            || mainCurrencyList.filter({ $0.isPrimary }).count != 1
        {
            resetPrimaryFlag()
        }
    }

    // reset the list to  make data valid
    private func resetPrimaryFlag() {
        for item in mainCurrencyList {
            item.isPrimary = false
            item.isFavorite = false
        }

        // at the begining here is only two favorites currency
        for i in (0...1) {
            mainCurrencyList[i].isFavorite = true
        }
        mainCurrencyList[0].isPrimary = true
    }

    // TODO:
    // get flags from userdefaults
    private func resetmainCurrencyListFlags() {

    }

    // TODO:
    // set flags to userdefaults
    private func savemainCurrencyListFlags() {

    }

    // it will works when list of currency will be dinamic ( from server side )
    private func validMaxCountOfFavoriteCurrecyList() -> Int {
        let result =
            mainCurrencyList.count <= Constants.maxFavoriteCurrencyNumber
            ? mainCurrencyList.count : Constants.maxFavoriteCurrencyNumber
        return result
    }

    // check if it is possible to add new favorite
    private func checkAddNewFavoritePossible() -> Bool {
        return validMaxCountOfFavoriteCurrecyList()
            <= mainCurrencyList.filter({ $0.isFavorite }).count ? false : true
    }

    // check if it is possible to add new favorite
    private func checkIfRemovingFavoritePossible() -> Bool {
        return mainCurrencyList.filter({ $0.isFavorite }).count > 2
    }

    // get element to remove from favorites
    // just to improve user experience
    // it just helps not to ask user for the additonal operation
    private func getIndexToRemoFavorite() -> Int? {
        return mainCurrencyList.firstIndex(where: {
            $0.isFavorite && !$0.isPrimary
        })
    }

    private func getIndexOfPrimary() -> Int? {
        return mainCurrencyList.firstIndex(where: { $0.isPrimary })
    }
    // check is it possible and toggle favorite
    func toggleFavorite(at index: Int) -> Bool {
        if !mainCurrencyList[index].isFavorite {
            if !checkAddNewFavoritePossible() {
                if let remove = getIndexToRemoFavorite() {
                    mainCurrencyList[remove].isFavorite.toggle()
                }
            }
            mainCurrencyList[index].isFavorite.toggle()
        } else {
            if checkIfRemovingFavoritePossible() {
                mainCurrencyList[index].isFavorite.toggle()
            }
        }
        let result = resetValuesFromCurrentStateOfMainList()
        return result
    }

    // uses when the Primary currency is changed
    func setPrimary(at index: Int) -> Bool {
        guard let pindex = getIndexOfPrimary() else { return false}
        guard pindex != index else { return false}
        if !mainCurrencyList[index].isFavorite {
            if !checkAddNewFavoritePossible() {
                mainCurrencyList[pindex].isFavorite = false
            }
            mainCurrencyList[index].isFavorite = true
        }
        mainCurrencyList[pindex].isPrimary = false
        mainCurrencyList[index].isPrimary = true
        let result = resetValuesFromCurrentStateOfMainList()
        return result
    }

    // to reset values array according to new state of main currency list list
    func resetValuesFromCurrentStateOfMainList() -> Bool {
        var flag = true
        var newList: [ConvertingValuesInfo] = []
        mainCurrencyListValidate()
        let list = convertingValues.list
        let code = list.count > 0 ? list[0].code : "--=="
        let value =
            list.count > 0
            ? list[0].value
            : Constants.FavoriteCurrencyTableView.primaryDefaultValue
        if let index = mainCurrencyList.firstIndex(where: { $0.isPrimary }),
            code == mainCurrencyList[index].code
        {
            newList.append(
                ConvertingValuesInfo(code: list[0].code, value: list[0].value))
        } else {
            if let ii = mainCurrencyList.firstIndex(where: { $0.isPrimary }) {
                flag = false
                newList.append(
                    ConvertingValuesInfo(
                        code: mainCurrencyList[ii].code, value: value))
            }
        }
        for item in mainCurrencyList.filter({
            $0.isFavorite == true && $0.isPrimary == false
        }) {
            var value = Constants.FavoriteCurrencyTableView.defaultValue
            if let index = list.firstIndex(where: { $0.code == item.code }) {
                if flag {
                    value = list[index].value
                }
            }
            newList.append(ConvertingValuesInfo(code: item.code, value: value))
        }
        let resflag = isListsIsEqual(newList)
        convertingValues.list = newList
        return resflag
    }
    
    // to compare the array with convertingValues.list - element by
    func isListsIsEqual(_ array: [ConvertingValuesInfo]) -> Bool {
        var result = true
        guard (convertingValues.list.count > 0) , (array.count > 0) else {return false}
        guard convertingValues.list.count == array.count else { return  false}
        for index in convertingValues.list.indices {
            if convertingValues.list[index].code != array[index].code || convertingValues.list[index].value != array[index].value {
                result = false
            }
        }
        return result
    }
}

// to work with the user Defaults - persistence
extension CurrencyListModel: CurrencyListModelPersistenceProtocol {
    static var key: String { "CurrencyListModelPersistenceProtocol" }

    func getValuesFromUserDefaults() -> [ConvertingValuesInfo] {
        let code0 = Constants.CountryCurrencyList[0].code
        let code1 = Constants.CountryCurrencyList[1].code
        var list: [ConvertingValuesInfo] = [
            ConvertingValuesInfo(code: code0, value: "100"),
            ConvertingValuesInfo(code: code1, value: "0"),
        ]
        if let data = UserDefaults.standard.data(forKey: CurrencyListModel.key)
        {
            do {
                let decoder = JSONDecoder()
                let objs = try decoder.decode(
                    [ConvertingValuesInfo].self, from: data)
                list = objs
            } catch {
                Logger.statistics.error(
                    "Unable to Decode CurrencyListModel (\(error))")
            }
        }
        return list
    }

    func resetValuesOnInit() {
        let list = getValuesFromUserDefaults()
        convertingValues.list = list
        for (index, element) in list.enumerated() {
            if let ii = mainCurrencyList.firstIndex(where: {
                $0.code == element.code
            }) {
                mainCurrencyList[ii].isFavorite = true
                if index == 0 {
                    mainCurrencyList[ii].isPrimary = true
                }
            }
        }

    }

    func setValuesToUserDefaults() {
        let array = convertingValues.list
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array)
            UserDefaults.standard.set(data, forKey: CurrencyListModel.key)
            UserDefaults.standard.synchronize()
        } catch {
            Logger.statistics.error(
                "Unable to Decode CurrencyListModel (\(error))")
        }
    }
}
