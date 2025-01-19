//
//  CurrencyListModel.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation

class CurrencyListModel {
    var currencyList: [CurrencyInfo] = [
        CurrencyInfo(code: "USD", symbol: "$", countryFlag: "🇺🇸", name: "US Dollar", isFavorite: true, isPrimary: true),
        CurrencyInfo(code: "EUR", symbol: "€", countryFlag: "🇪🇺", name: "Euro", isFavorite: true, isPrimary: false),
        CurrencyInfo(code: "GBP", symbol: "£", countryFlag: "🇬🇧", name: "British Pound", isFavorite: true, isPrimary: false),
        CurrencyInfo(code: "NGN", symbol: "₦", countryFlag: "🇳🇬", name: "Nigerian Naira", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "CAD", symbol: "C$", countryFlag: "🇨🇦", name: "Canadian Dollar", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "JPY", symbol: "¥", countryFlag: "🇯🇵", name: "Japanese Yen", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "INR", symbol: "₹", countryFlag: "🇮🇳", name: "Indian Rupee", isFavorite: false, isPrimary: false)
    ]
    
    // just to get correct list of favorite currency
    var favoriteCurrencyList: [CurrencyInfo] {
        currencyListValidate()
        return currencyList.filter({$0.isFavorite == true})
    }
    
    // just to validate the list
    private func currencyListValidate() {
        if  currencyList.filter({$0.isFavorite}).count > validMaxCountOfFavoriteCurrecyList() ||
                currencyList.filter({$0.isFavorite}).count < 1 ||
                currencyList.filter({$0.isPrimary}).count != 1 {
            resetPrimaryFlag()
        }
    }
    
    // reset the list to  make data valid
    private func resetPrimaryFlag() {
        for item in currencyList {
            item.isPrimary = false
            item.isFavorite = false
        }
        
        // at the begining here is only two favorites currency
        for i in (0...1) {
            currencyList[i].isFavorite = true
        }
        currencyList[0].isPrimary = true
    }
    
    // TODO:
    // get flags from userdefaults
    private func resetCurrencyListFlags() {
        
    }
    
    // TODO:
    // set flags to userdefaults
    private func saveCurrencyListFlags() {
        
    }
    
    // it will works when list of currency will be dinamic ( from server side )
    func validMaxCountOfFavoriteCurrecyList() -> Int {
        return currencyList.count <= Constants.maxFavoriteCurrencyNumber ? currencyList.count : Constants.maxFavoriteCurrencyNumber
    }

}
