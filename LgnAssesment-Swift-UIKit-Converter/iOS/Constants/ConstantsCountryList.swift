//
//  ConstantsCountryList.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation

extension Constants {
 
    static let CountryCurrencyList: [CurrencyInfo] = [
        CurrencyInfo(code: "USD", symbol: "$", countryFlag: "🇺🇸", name: "US Dollar", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "EUR", symbol: "€", countryFlag: "🇪🇺", name: "Euro", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "GBP", symbol: "£", countryFlag: "🇬🇧", name: "British Pound", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "NGN", symbol: "₦", countryFlag: "🇳🇬", name: "Nigerian Naira", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "CAD", symbol: "C$", countryFlag: "🇨🇦", name: "Canadian Dollar", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "JPY", symbol: "¥", countryFlag: "🇯🇵", name: "Japanese Yen", isFavorite: false, isPrimary: false),
        CurrencyInfo(code: "INR", symbol: "₹", countryFlag: "🇮🇳", name: "Indian Rupee", isFavorite: false, isPrimary: false)
    ]
}
