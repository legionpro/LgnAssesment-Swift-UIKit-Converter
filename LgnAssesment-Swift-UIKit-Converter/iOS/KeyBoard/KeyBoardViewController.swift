//
//  KeyBoardViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class KeyBoardViewController: UIViewController {

    var textField = UITextField()

    override func loadView() {
        self.view = NumericKeyboard(target: textField)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
    }

}
