//
//  KeyBoardViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

// keyBoard controller, put it into ItemSlideView - the basic view for MainViewController collectionViewCell
// and add it as child viewController for MainViewController

protocol KeyBoardViewControllerProtocol {
    var boardView: NumericKeyboard { get set }

    func setUpKeyBoadrDelegate(_ delegate: KeyBoardProtocol)
}

class KeyBoardViewController: UIViewController & KeyBoardViewControllerProtocol
{
    var boardView: NumericKeyboard

    init(boardView: NumericKeyboard) {
        self.boardView = boardView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        boardView.frame = view.bounds
        view.addSubview(boardView)
        self.view.backgroundColor = .clear
    }

    func setUpKeyBoadrDelegate(_ delegate: KeyBoardProtocol) {
        self.boardView.keyBoardDelegate = delegate
    }

}
