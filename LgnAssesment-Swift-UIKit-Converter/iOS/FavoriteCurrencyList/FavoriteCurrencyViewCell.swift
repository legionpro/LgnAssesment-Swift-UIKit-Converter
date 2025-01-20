//
//  FavoriteCurrencyViewCell.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class FavoriteCurrencyViewCell: CurrencyViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupCellSubviews() {
        setupLinesImage()
        setupFlagImage()
        setupCurrencyCode()
        setupCurrencyAmount()
        setupBottomSeparator()
    }
    override func layoutCellSubviews() {
        layoutLlinesImage()
        layoutFlagImage()
        layoutCurrencyCode()
        layoutCurrencyAmount()
        layoutBottomSeparator()
    }
    override func setUpCellData() {
        contentView.backgroundColor = .clear
        guard let currency = self.currency else { return }
        if !currency.isPrimary {
            if lastCellFlag {
                linesImage.image = UIImage(named: "corner.png")
            } else {
                linesImage.image = UIImage(named: "cross.png")
            }
            linesImage.tintColor = Constants.color5
            currencyAmount.alpha = 0.5
            currencyFlagLabel.font = UIFont.boldSystemFont(
                ofSize: Constants.FavoriteCurrencyTableView.flagFontSize - 10)
        } else {
            currencyFlagLabel.font = UIFont.boldSystemFont(
                ofSize: Constants.FavoriteCurrencyTableView.flagFontSize)
            currencyAmount.alpha = 1.0
            linesImage.removeFromSuperview()
        }
        currencyFlagLabel.text = currency.countryFlag
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
        contentView.addSubview(currencyFlagLabel)
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
        currencyFlagLabel.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.flagFontSize)
        currencyFlagLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyFlagLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyFlagLabel.widthAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .flagImageWidth),
            currencyFlagLabel.heightAnchor.constraint(
                equalToConstant: Constants.FavoriteCurrencyTableView
                    .flagImageHeight),
            currencyFlagLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: -5
            ).withPriority(500),
            currencyFlagLabel.leadingAnchor.constraint(
                equalTo: linesImage.trailingAnchor, constant: -5
            ).withPriority(1000),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutCurrencyCode() {
        currencyCode.textColor = Constants.FavoriteCurrencyTableView.textColor
        currencyCode.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.codeFontSize)
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyCode.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyCode.leadingAnchor.constraint(
                equalTo: currencyFlagLabel.trailingAnchor, constant: -8),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutCurrencyAmount() {
        currencyAmount.textColor = Constants.FavoriteCurrencyTableView.textColor
        currencyAmount.font = UIFont.boldSystemFont(
            ofSize: Constants.FavoriteCurrencyTableView.valueFontSize)
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
                constant: 10 * Constants.FavoriteCurrencyTableView.contentMargin),
            bottomSeparator.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            bottomSeparator.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
