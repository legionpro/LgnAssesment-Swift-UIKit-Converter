//
//  RequestResponseValue.swift
//  iOS
//
//  Created by Oleh Poremskyy on 23.01.2025.
//

import Foundation

struct RequestResponseValue: Codable, Sendable {
    let amount, currency: String

    init(amount: String, currency: String) {
        self.amount = amount
        self.currency = currency
    }
}
