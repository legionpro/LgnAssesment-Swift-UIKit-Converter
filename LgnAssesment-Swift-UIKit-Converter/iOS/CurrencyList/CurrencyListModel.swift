//
//  CurrencyListModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation
import Combine

struct CurrencyListModel: CurrencyListModelProtocol {
    var primaryValue = "0"
    var primaryCurrencySelectionFlag = false
    
    lazy var convertingValuesList: [ConvertingValuesInfo] = []
//    {
//        //resetValuesOnInit()
//        //getValuesFromUserDefaults()
//    }()
    
    var mainCurrencyList: [CurrencyInfo] {
        Constants.CountryCurrencyList
    }
    
    init() {
        resetValuesOnInit()
        resetValuesCurrentStateOfMainList()
        //mainCurrencyListValidate()
    }
    
    // just to validate the list
    func mainCurrencyListValidate() {
        if  mainCurrencyList.filter({$0.isFavorite}).count > validMaxCountOfFavoriteCurrecyList() ||
                mainCurrencyList.filter({$0.isFavorite}).count < 1 ||
                mainCurrencyList.filter({$0.isPrimary}).count != 1 {
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
        let result = mainCurrencyList.count <= Constants.maxFavoriteCurrencyNumber ? mainCurrencyList.count : Constants.maxFavoriteCurrencyNumber
        return result
    }
    
    // check if it is possible to add new favorite
    private func checkAddNewFavoritePossible() -> Bool {
        return validMaxCountOfFavoriteCurrecyList() <= mainCurrencyList.filter({$0.isFavorite}).count ? false : true
    }
    
    // check if it is possible to add new favorite
    private func checkIfRemovingFavoritePossible() -> Bool {
        return mainCurrencyList.filter({$0.isFavorite}).count > 2
    }
    
    // get element to remove from favorites
    //just to improve user experience
    // it just helps not to ask user for the additonal operation
    private func getIndexToRemoFavorite() -> Int? {
        return mainCurrencyList.firstIndex(where: {$0.isFavorite && !$0.isPrimary})
    }
    
    private func getIndexOfPrimary() -> Int? {
        return mainCurrencyList.firstIndex(where: {$0.isPrimary})
    }
    // check is it possible and toggle favorite
    mutating func toggleFavorite(at index: Int) {
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
        resetValuesCurrentStateOfMainList()
    }
    
    mutating func setPrimary(at index: Int) {
        guard let pindex = getIndexOfPrimary() else { return }
        guard pindex != index else { return }
        if !mainCurrencyList[index].isFavorite {
            if !checkAddNewFavoritePossible() {
                mainCurrencyList[pindex].isFavorite = false
            }
            mainCurrencyList[index].isFavorite = true
        }
        mainCurrencyList[pindex].isPrimary = false
        mainCurrencyList[index].isPrimary = true
        resetValuesCurrentStateOfMainList()
     }
    
    // reset values array according to new state of main currency list list
    mutating func resetValuesCurrentStateOfMainList() {
        var flag = true
        var newList: [ConvertingValuesInfo] = []
        mainCurrencyListValidate()
        let list = convertingValuesList
        let code = list.count > 0 ? list[0].code : "--=="
        let value = list.count > 0 ? list[0].value : Constants.FavoriteCurrencyTableView.primaryDefaultValue
        if let index = mainCurrencyList.firstIndex(where: {$0.isPrimary}), (code == mainCurrencyList[index].code) {
            newList.append(ConvertingValuesInfo(code: list[0].code, value: list[0].value))
        } else {
            if let ii = mainCurrencyList.firstIndex(where: {$0.isPrimary}) {
                flag = false
                newList.append(ConvertingValuesInfo(code: mainCurrencyList[ii].code, value: value))
            }
        }
        for item in mainCurrencyList.filter({ $0.isFavorite == true && $0.isPrimary == false }) {
            var value = Constants.FavoriteCurrencyTableView.defaultValue
            if let index = list.firstIndex(where: { $0.code == item.code }) {
                if flag {
                    value = list[index].value
                }
            }
            newList.append(ConvertingValuesInfo(code: item.code, value: value))
        }
        convertingValuesList = newList
    }
}


// to work with the user Defaults
extension CurrencyListModel: CurrencyListModelPersistenceProtocol {
    static var key: String { "CurrencyListModelPersistenceProtocol" }
    
    func getValuesFromUserDefaults() -> [ConvertingValuesInfo] {
        let code0 = Constants.CountryCurrencyList[0].code
        let code1 = Constants.CountryCurrencyList[1].code
        var list: [ConvertingValuesInfo] = [ConvertingValuesInfo(code: code0, value: "100"), ConvertingValuesInfo(code: code1, value: "0")]
        if let data = UserDefaults.standard.data(forKey: CurrencyListModel.key) {
            do {
                let decoder = JSONDecoder()
                let objs = try decoder.decode( [ConvertingValuesInfo].self, from: data)
                list = objs
            } catch {
                print("Unable to Decode Notes (\(error))")
            }
        }
        return list
    }
    
    mutating func resetValuesOnInit() {
        let list = getValuesFromUserDefaults()
        for (index, element) in list.enumerated() {
            if let ii = mainCurrencyList.firstIndex(where: {$0.code == element.code}) {
                mainCurrencyList[ii].isFavorite = true
                if index == 0 {
                    mainCurrencyList[ii].isPrimary = true
                }
            }
        }
 
    }
    
    mutating func setValuesToUserDefaults() {
        let array = convertingValuesList        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(array)
            UserDefaults.standard.set(data, forKey: CurrencyListModel.key)
            UserDefaults.standard.synchronize()
        } catch {
            print("Unable to Encode Array of Notes (\(error))")
        }
    }
}


