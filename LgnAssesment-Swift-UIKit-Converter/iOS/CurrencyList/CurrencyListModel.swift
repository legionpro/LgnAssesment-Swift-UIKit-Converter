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
    
    var mainCurrencyList: [CurrencyInfo] = [
        CurrencyInfo(code: "USD", symbol: "$", countryFlag: "🇺🇸", name: "US Dollar", isFavorite: true, isPrimary: true),
        CurrencyInfo(code: "EUR", symbol: "€", countryFlag: "🇪🇺", name: "Euro", isFavorite: true, isPrimary: false),
        CurrencyInfo(code: "GBP", symbol: "£", countryFlag: "🇬🇧", name: "British Pound", isFavorite: true, isPrimary: false),
        CurrencyInfo(code: "NGN", symbol: "₦", countryFlag: "🇳🇬", name: "Nigerian Naira", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "CAD", symbol: "C$", countryFlag: "🇨🇦", name: "Canadian Dollar", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "JPY", symbol: "¥", countryFlag: "🇯🇵", name: "Japanese Yen", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "INR", symbol: "₹", countryFlag: "🇮🇳", name: "Indian Rupee", isFavorite: false, isPrimary: false)
    ]
    
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
    
    // check is it possible and toggle favorite
    func toggleFavorite(at index: Int) {
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
    }
}


