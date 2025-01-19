//
//  FavoriteCurrencyViewCell.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class FavoriteCurrencyViewCell: UITableViewCell {

    var lastCellFlag: Bool = false

    var currency: CurrencyInfo? {
        didSet {
            if currency != nil {
                setUpData()
            }
        }
    }

    var value: String {
        get {
            return currencyAmount.text
                ?? Constants.FavoriteCurrencyTableView.defaultValue
        }
        set {
            guard let currency = self.currency else { return }
            if currency.isPrimary {
                currencyAmount.text =
                    (newValue == ""
                        ? Constants.FavoriteCurrencyTableView
                            .primaryDefaultValue : newValue)
            } else {
                currencyAmount.text =
                    (newValue == ""
                        ? Constants.FavoriteCurrencyTableView.defaultValue
                        : newValue)
            }
        }
    }

    private let linesImage: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .clear
        return imgv
    }()

    private let currencyFlag: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .clear
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()

    private let currencyCode: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.codeFontSize)
        lbl.textAlignment = .left
        return lbl
    }()

    private var currencyAmount: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.valueFontSize)
        lbl.textAlignment = .right
        return lbl
    }()

    private let bottomSeparator: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green.withAlphaComponent(0.1)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.value = ""
        setupLinesImage()
        setupFlagImage()
        setupCurrencyCode()
        setupCurrencyAmount()
        setupBottomSeparator()

        layoutLlinesImage()
        layoutFlagImage()
        layoutCurrencyCode()
        layoutCurrencyAmount()
        layoutBottomSeparator()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setUpData() {
        guard let currency = self.currency else { return }
        if !currency.isPrimary {
            if lastCellFlag {
                linesImage.image = UIImage(named: "corner.png")
            } else {
                linesImage.image = UIImage(named: "cross.png")
            }
            currencyAmount.alpha = 0.5
        } else {
            currencyAmount.alpha = 1.0
            linesImage.removeFromSuperview()
        }
        currencyFlag.image = currency.countryFlag.textToImage()
        currencyCode.text = currency.code
        value = ""

        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

}

extension FavoriteCurrencyViewCell {

    private func setupBottomSeparator() {
        contentView.addSubview(bottomSeparator)
    }

    private func setupLinesImage() {
        contentView.addSubview(linesImage)
    }

    private func setupFlagImage() {
        contentView.addSubview(currencyFlag)
    }

    private func setupCurrencyAmount() {
        contentView.addSubview(currencyAmount)
    }

    private func setupCurrencyCode() {
        contentView.addSubview(currencyCode)
    }

    private func layoutLlinesImage() {
        linesImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            linesImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 0),
            linesImage.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 0),
            linesImage.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: 0),
            linesImage.widthAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .cellLinesImageWidth),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutFlagImage() {
        currencyFlag.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyFlag.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyFlag.widthAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .flagImageWidth),
            currencyFlag.heightAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .flagImageHeight),
            currencyFlag.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: -5
            ).withPriority(500),
            currencyFlag.leadingAnchor.constraint(
                equalTo: linesImage.trailingAnchor, constant: -5
            ).withPriority(1000),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutCurrencyCode() {
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyCode.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyCode.leadingAnchor.constraint(
                equalTo: currencyFlag.trailingAnchor, constant: -8),
            //currencyCode.trailingAnchor.constraint(equalTo: currencyAmount.leadingAnchor, constant: Constants.FavoriteCurrencyTableView.contentMargin)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutCurrencyAmount() {
        currencyAmount.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyAmount.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyAmount.leadingAnchor.constraint(
                equalTo: currencyCode.trailingAnchor,
                constant: Constants.FavoriteCurrencyTableView.contentMargin),
            currencyAmount.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -1 * Constants.FavoriteCurrencyTableView.contentMargin
            ),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutBottomSeparator() {
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            bottomSeparator.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 2 * Constants.FavoriteCurrencyTableView.contentMargin),
            bottomSeparator.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            bottomSeparator.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
