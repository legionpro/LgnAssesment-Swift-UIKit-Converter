//
//  CurrencyListViewCell.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

final class CurrencyListViewCell: CurrencyViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupCellSubviews() {
        setupFlagImage()
        setupCurrencyCode()
        setupCurrencyName()
        setupFavoriteImage()
        setupBottomSeparator()
    }

    override func layoutCellSubviews() {
        layoutFlagImage()
        layoutCurrencyCode()
        layoutCurrencyName()
        layoutFavoriteImage()
        layoutBottomSeparator()
    }

    override func setUpCellData() {
        guard let currency = self.currency else { return }
        currencyCode.text = currency.code
        currencyName.text = currency.name
        currencyFlagLabel.text = currency.countryFlag
        if currency.isPrimary {
            favoriteImage.alpha = 0.7
        } else {
            favoriteImage.alpha = 0.5
        }
        if currency.isFavorite {
            favoriteImage.image = UIImage(systemName: "star.fill")
        } else {
            favoriteImage.image = UIImage(systemName: "star")
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}

extension CurrencyListViewCell {

    private func setupBottomSeparator() {
        contentView.addSubview(bottomSeparator)
    }

    private func setupFlagImage() {
        contentView.addSubview(currencyFlagLabel)
    }

    private func setupCurrencyCode() {
        contentView.addSubview(currencyCode)
    }

    private func setupCurrencyName() {
        contentView.addSubview(currencyName)
    }

    private func setupFavoriteImage() {
        contentView.addSubview(favoriteImage)
    }

    private func layoutFlagImage() {
        currencyFlagLabel.font = UIFont.boldSystemFont(
            ofSize: Constants.CurrencyListViewCell.flagFontSize)
        currencyFlagLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyFlagLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyFlagLabel.widthAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.flagImageWidth),
            currencyFlagLabel.heightAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.flagImageHeight),
            currencyFlagLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.CurrencyListViewCell.contentMargin),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutCurrencyCode() {
        currencyName.font = UIFont.systemFont(
            ofSize: Constants.CurrencyListViewCell.codeFontSize)
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyCode.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyCode.leadingAnchor.constraint(
                equalTo: currencyFlagLabel.trailingAnchor,
                constant: Constants.CurrencyListViewCell.contentMargin),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutCurrencyName() {
        currencyName.font = UIFont.systemFont(
            ofSize: Constants.CurrencyListViewCell.nameFontSize)
        currencyName.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            currencyName.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyName.leadingAnchor.constraint(
                equalTo: currencyCode.trailingAnchor,
                constant: Constants.CurrencyListViewCell.contentMargin),
            currencyName.trailingAnchor.constraint(
                equalTo: favoriteImage.leadingAnchor,
                constant: -1 * Constants.CurrencyListViewCell.contentMargin),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func layoutFavoriteImage() {
        favoriteImage.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            favoriteImage.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            favoriteImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -1 * Constants.CurrencyListViewCell.contentMargin),
            favoriteImage.widthAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.favoriteWidth),
            favoriteImage.heightAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.favoriteHeight),
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
