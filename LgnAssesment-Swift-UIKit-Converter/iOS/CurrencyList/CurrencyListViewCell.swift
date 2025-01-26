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
        setupCellSubviews()
        layoutCellSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCellSubviews() {
        setupFlagImage()
        setupCurrencyCode()
        setupCurrencyName()
        setupBottomSeparator()
    }

    func layoutCellSubviews() {
        createLayoutFlagImage()
        createLayoutCurrencyCode()
        createLayoutCurrencyName()
        createLayoutFavoriteImage()
        createLayoutBottomSeparator()
    }
    func setUpCellData(_ currency: CurrencyInfo) {
        self.currency = currency
        currencyCode.text = currency.code
        currencyName.text = currency.name
        currencyFlagLabel.text = currency.countryFlag
        if currency.isPrimary {
            favoriteImage.alpha = 0.7
            selectionStyle = .none
        } else {
            favoriteImage.alpha = 0.5
            selectionStyle = .gray
        }
        if currency.isFavorite {
            favoriteImage.image = UIImage(systemName: "star.fill")
        } else {
            favoriteImage.image = UIImage(systemName: "star")
        }
        if showFavoriteFlag {
            contentView.addSubview(favoriteImage)
        } else {
            favoriteImage.removeFromSuperview()
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.deactivate(favoriteImageConstraints)
        createLayoutFavoriteImage()
        activateLayoutConstraints()

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

    private func createLayoutFlagImage() {
        currencyFlagLabel.font = UIFont.boldSystemFont(
            ofSize: Constants.CurrencyListViewCell.flagFontSize)
        currencyFlagLabel.translatesAutoresizingMaskIntoConstraints = false
        currencyFlagLabelConstraints = [
            currencyFlagLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyFlagLabel.widthAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.flagImageWidth),
            currencyFlagLabel.heightAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.flagImageHeight),
            currencyFlagLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Constants.CurrencyListViewCell.contentMargin),
        ]
    }

    private func createLayoutCurrencyCode() {
        currencyName.font = UIFont.systemFont(
            ofSize: Constants.CurrencyListViewCell.codeFontSize)
        currencyCode.translatesAutoresizingMaskIntoConstraints = false
        currencyCodeConstraints = [
            currencyCode.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyCode.leadingAnchor.constraint(
                equalTo: currencyFlagLabel.trailingAnchor,
                constant: Constants.CurrencyListViewCell.contentMargin),
        ]
    }

    private func createLayoutCurrencyName() {
        currencyName.font = UIFont.systemFont(
            ofSize: Constants.CurrencyListViewCell.nameFontSize)
        currencyName.translatesAutoresizingMaskIntoConstraints = false
        currencyNameConstraints = [
            currencyName.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            currencyName.leadingAnchor.constraint(
                equalTo: currencyCode.trailingAnchor,
                constant: Constants.CurrencyListViewCell.contentMargin),
            currencyName.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -1 * Constants.CurrencyListViewCell.contentMargin
            ).withPriority(500),
        ]
    }

    private func createLayoutFavoriteImage() {
        favoriteImage.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageConstraints = [
            favoriteImage.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            favoriteImage.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -1 * Constants.CurrencyListViewCell.contentMargin),
            favoriteImage.widthAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.favoriteWidth),
            favoriteImage.heightAnchor.constraint(
                equalToConstant: Constants.CurrencyListViewCell.favoriteHeight),
            favoriteImage.leadingAnchor.constraint(
                equalTo: currencyName.trailingAnchor,
                constant: Constants.CurrencyListViewCell.contentMargin
            ).withPriority(1000),
        ]
    }

    private func createLayoutBottomSeparator() {
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorConstraints = [
            bottomSeparator.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 2 * Constants.FavoriteCurrencyTableView.contentMargin),
            bottomSeparator.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.0),
            bottomSeparator.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ]
    }

    func activateLayoutConstraints() {
        NSLayoutConstraint.activate(currencyFlagLabelConstraints)
        NSLayoutConstraint.activate(currencyCodeConstraints)
        NSLayoutConstraint.activate(currencyNameConstraints)
        NSLayoutConstraint.activate(bottomSeparatorConstraints)
        if favoriteImage.superview != nil {
            NSLayoutConstraint.activate(favoriteImageConstraints)
        } else {
            NSLayoutConstraint.deactivate(favoriteImageConstraints)
        }
    }
}
