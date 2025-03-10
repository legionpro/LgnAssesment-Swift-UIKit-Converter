//
//  ConvertingValuesInfo.swift
//  iOS
//
//  Created by Oleh Poremskyy on 22.01.2025.
//

import Foundation

//basic type for ConvertingValues.list elements

class ConvertingValuesInfo: Codable {
    let code: String
    var value: String

    init(code: String, value: String) {
        self.code = code
        self.value = value
    }
}
