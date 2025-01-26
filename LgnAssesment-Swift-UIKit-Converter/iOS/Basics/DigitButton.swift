//
//  DigitButton.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

// basic type for keyboard buttons

class DigitButton: UIButton {
    var digit: Int = 0

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor =
                isHighlighted
                ? Constants.keyBoardColorisHighlighted : Constants.keyBoardColor
        }
    }

}
