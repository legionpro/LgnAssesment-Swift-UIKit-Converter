//
//  NumericKeyboardView.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class NumericKeyboard: UIView {
    weak var target: (UIKeyInput & UITextInput)?
    weak var keyBoardDelegate: KeyBoardProtocol?

    var useDecimalSeparator: Bool = true

    lazy var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.sizeToFit()
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.addTarget(
            self, action: #selector(digitButtonAction(_:)), for: .touchUpInside)
        button.inputView.self?.sizeToFit()
        return button
    }

    var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)

        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(
            NumericKeyboard.self, action: #selector(deleteButtonAction(_:)),
            for: .touchUpInside)
        return button
    }()

    var delimiterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(",", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)

        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        //button.accessibilityLabel = "Delete"
        button.addTarget(
            NumericKeyboard.self, action: #selector(delimiterButtonAction(_:)),
            for: .touchUpInside)
        return button
    }()

    init(target: UIKeyInput & UITextInput, useDecimalSeparator: Bool = false) {
        self.target = target
        self.useDecimalSeparator = useDecimalSeparator
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension NumericKeyboard {

    @objc func digitButtonAction(_ sender: DigitButton) {
        //insertText("\(sender.digit)")
        keyBoardDelegate?.digitButtonTap(sender)
    }
    @objc func deleteButtonAction(_ sender: DigitButton) {
        keyBoardDelegate?.deleteButtonTap()

    }

    @objc func delimiterButtonAction(_ sender: DigitButton) {
        //target?.deleteBackward()
        keyBoardDelegate?.delimiterButtonTap()
    }
}

// MARK: - Private initial configuration methods

extension NumericKeyboard {
    fileprivate func configure() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addButtons()
    }

    fileprivate func addButtons() {
        let stackView = createButtonsStackView(axis: .vertical)
        stackView.frame = bounds
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(stackView)

        for row in 0..<3 {
            let subStackView = createButtonsStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)

            for column in 0..<3 {
                subStackView.addArrangedSubview(
                    numericButtons[row * 3 + column + 1])
            }
        }

        let subStackView = createButtonsStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)

        subStackView.addArrangedSubview(numericButtons[0])

        subStackView.addArrangedSubview(deleteButton)

    }

    fileprivate func createButtonsStackView(axis: NSLayoutConstraint.Axis)
        -> UIStackView
    {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }

}
