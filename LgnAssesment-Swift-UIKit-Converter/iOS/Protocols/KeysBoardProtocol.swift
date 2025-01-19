//
//  KeysBoardProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation

protocol KeysBoardProtocol: AnyObject {
    func digitButtonTap(_ button: DigitButton)
    func deleteButtonTap()
    func delimiterButtonTap()
}
