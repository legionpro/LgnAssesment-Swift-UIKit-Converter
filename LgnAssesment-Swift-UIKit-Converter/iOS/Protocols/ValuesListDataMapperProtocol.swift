//
//  ValuesListDataMapperProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 23.01.2025.
//

import Foundation

// MARK: - jsut protocol for mapping  response data to values list

//@MainActor
protocol ValuesListDataMapperProtocol {
    func updateCurrencyValuesList()
    func itemResponseToItem(_ response: RequestResponseValue?) -> ConvertingValuesInfo?
}

// FIXME: - needs real implematation
extension ValuesListDataMapperProtocol {
    func itemResponseToItem(_ response: RequestResponseValue?) -> ConvertingValuesInfo? {
        var resultValue: ConvertingValuesInfo?
        if let resp = response {
            resultValue = ConvertingValuesInfo(
                    code: resp.currency,
                    value: resp.amount
                )
            }
        return resultValue
    }
}

