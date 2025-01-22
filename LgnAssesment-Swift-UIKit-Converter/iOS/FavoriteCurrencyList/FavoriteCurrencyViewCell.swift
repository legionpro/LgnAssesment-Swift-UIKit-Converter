//
//  FavoriteCurrencyViewCell.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

final class FavoriteCurrencyViewCell: CurrencyViewCell {

    var multipl: CGFloat = 0
    private var didLayoutSubviews = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellSubviews()
        createLayoutCellSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCellSubviews() {
        setupLinesImage()
        setupFlagImage()
        setupCurrencyCode()
        setupCurrencyAmount()
        setupBottomSeparator()
    }
    func createLayoutCellSubviews() {
        createLayoutLlinesImage()
        createLayoutFlagImage()
        createLayoutCurrencyCode()
        createLayoutCurrencyAmount()
        createLayoutBottomSeparator()
    }
    func setUpCellData(currency: CurrencyInfo, value: String) {
        self.currency = currency
        linesImage.image = self.crossImage
        if !currency.isPrimary {
            multipl = 0
            if lastCellFlag {
                linesImage.image = self.cornerImage
            }
            linesImage.isHidden = false
            linesImage.tintColor = Constants.color5
            currencyAmount.alpha = 0.5
            currencyFlagLabel.font = UIFont.boldSystemFont(
                ofSize: Constants.FavoriteCurrencyTableView.flagFontSize - 10)
        } else {
            multipl =
                -1
                * Constants.FavoriteCurrencyTableView
                .cellLinesImageWidth
            currencyFlagLabel.font = UIFont.boldSystemFont(
                ofSize: Constants.FavoriteCurrencyTableView.flagFontSize)
            currencyAmount.alpha = 1.0
        }
        currencyFlagLabel.text = currency.countryFlag
        currencyCode.text = currency.code
        self.value = value
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.deactivate(linesImageConstraints)
        createLayoutLlinesImage()
        activateLayoutConstraints()

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
        contentView.addSubview(currencyFlagLabel)
    }

    private func setupCurrencyAmount() {
        contentView.addSubview(currencyAmount)
    }

    private func setupCurrencyCode() {
        contentView.addSubview(currencyCode)
    }

    private func createLayoutLlinesImage() {
        linesImage.translatesAutoresizingMaskIntoConstraints = false

        linesImageConstraints = [
            linesImage.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: multipl),
            linesImage.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 0),
            linesImage.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: 0),
            linesImage.widthAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .cellLinesImageWidth),
        ]
    }

    private func createLayoutFlagImage() {
        currencyFlagLabel.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.flagFontSize)
        currencyFlagLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyFlagLabelConstraints = [
            currencyFlagLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyFlagLabel.widthAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .flagImageWidth),
            currencyFlagLabel.heightAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .flagImageHeight),
            currencyFlagLabel.leadingAnchor.constraint(
                equalTo: linesImage.trailingAnchor, constant: -5
            )
        ]
    }

    private func createLayoutCurrencyCode() {
        currencyCode.textColor = Constants.FavoriteCurrencyTableView.textColor
        currencyCode.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.codeFontSize)
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        currencyCodeConstraints = [
            currencyCode.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyCode.leadingAnchor.constraint(
                equalTo: currencyFlagLabel.trailingAnchor, constant: -8),
        ]
    }

    private func createLayoutCurrencyAmount() {
        currencyAmount.textColor = Constants.FavoriteCurrencyTableView.textColor
        currencyAmount.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.valueFontSize)
        currencyAmount.translatesAutoresizingMaskIntoConstraints = false
        currencyAmountConstraints = [
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
    }

    private func createLayoutBottomSeparator() {
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorConstraints = [
            bottomSeparator.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10 * Constants.FavoriteCurrencyTableView.contentMargin
            ),
            bottomSeparator.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            bottomSeparator.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ]
    }
    
    func activateLayoutConstraints() {
        NSLayoutConstraint.activate(currencyCodeConstraints)
        NSLayoutConstraint.activate(currencyAmountConstraints)
        NSLayoutConstraint.activate(bottomSeparatorConstraints)
        NSLayoutConstraint.activate(currencyFlagLabelConstraints)
        NSLayoutConstraint.activate(linesImageConstraints)
    }

}
