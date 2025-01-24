//
//  CurrencyListViewModelProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 20.01.2025.
//

import Foundation
import Combine 

protocol CurrencyListViewModelProtocol {

    var failureFlag: Bool { get set }
    var dataModel: CurrencyListModelProtocol  & CurrencyListModelPersistenceProtocol { get set }
    var primaryCurrencySelectionFlag: Bool  { get set }
    var mainList: [CurrencyInfo] { get }
    var favoriteCurrencyList: [CurrencyInfo] { get }
    var curencyListElementPublisher: PassthroughSubject<Int, Never>  { get }
    var primaryCurrencyValuePublisher: PassthroughSubject<String, Never>  { get }

    func toggleFavorite(at index: Int)
    func setPrimary(at index: Int)
    func setDataToUserDefaults()
}
