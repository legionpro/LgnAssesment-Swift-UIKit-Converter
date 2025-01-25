//
//  NumericKeyboardView.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

//enum BoardKeys

class NumericKeyboard: UIView {
    weak var keyBoardDelegate: KeyBoardProtocol?
    private let generator = UIImpactFeedbackGenerator(style: .heavy)

    var useDecimalSeparator: Bool = true

    lazy var numericButtons: [DigitButton] = (0...9).map {
        let button = DigitButton(type: .system)
        button.digit = $0
        button.setTitle("\($0)", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.backgroundColor = Constants.keyBoardColor
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

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⌫/C", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.backgroundColor = Constants.keyBoardColor
        button.setTitleColor(Constants.color5, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delete"
        button.addTarget(
            self, action: #selector(deleteButtonAction(_:)), for: .touchUpInside
        )
        button.addTarget(
            self, action: #selector(clearButtonAction(_:)),
            for: .touchDownRepeat)
        return button
    }()

    lazy var delimiterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(",", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.backgroundColor = Constants.keyBoardColor
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.accessibilityTraits = [.keyboardKey]
        button.accessibilityLabel = "Delimiter"
        button.addTarget(
            self, action: #selector(delimiterButtonAction(_:)),
            for: .touchUpInside)
        return button
    }()

    init(useDecimalSeparator: Bool = false) {
        self.useDecimalSeparator = useDecimalSeparator
        super.init(frame: .zero)
        generator.prepare()
        generator.impactOccurred()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Actions

extension NumericKeyboard {

    @objc func digitButtonAction(_ sender: DigitButton) {
        generator.impactOccurred()
        guard let tag = BoardKeysTags(rawValue: "\(sender.digit)") else {
            return
        }
        keyBoardDelegate?.digitButtonTap(tag)
    }

    @objc func delimiterButtonAction(_ sender: DigitButton) {
        generator.impactOccurred()
        keyBoardDelegate?.delimiterButtonTap()
    }

    @objc func deleteButtonAction(_ sender: DigitButton) {
        generator.impactOccurred()
        keyBoardDelegate?.deleteButtonTap()

    }
    @objc func clearButtonAction(_ sender: DigitButton) {
        generator.impactOccurred()
        keyBoardDelegate?.clearButtonTap()
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
                subStackView.spacing = 3.0
                subStackView.addArrangedSubview(
                    numericButtons[row * 3 + column + 1])
            }
        }

        let subStackView = createButtonsStackView(axis: .horizontal)
        stackView.addArrangedSubview(subStackView)
        subStackView.addArrangedSubview(delimiterButton)
        subStackView.addArrangedSubview(numericButtons[0])
        subStackView.addArrangedSubview(deleteButton)

    }

    fileprivate func createButtonsStackView(axis: NSLayoutConstraint.Axis)
        -> UIStackView
    {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }
}
