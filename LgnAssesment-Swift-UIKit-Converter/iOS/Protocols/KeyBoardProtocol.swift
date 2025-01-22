//
//  KeyBoardProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import Foundation

protocol KeyBoardProtocol: AnyObject {
    func digitButtonTap(_ tag: BoardKeysTags)
    func deleteButtonTap()
    func clearButtonTap()
    func delimiterButtonTap()
}
