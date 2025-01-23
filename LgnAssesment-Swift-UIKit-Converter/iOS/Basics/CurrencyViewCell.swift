//
//  CurrencyViewCell.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class CurrencyViewCell: UITableViewCell {

    let crossImage = UIImage(named: "cross.png")!
    let cornerImage = UIImage(named: "corner.png")!
    
    var lastCellFlag: Bool = false
    var showFavoriteFlag: Bool = true
    
    var currency: CurrencyInfo?

    var linesImageConstraints: [NSLayoutConstraint] = []
    var currencyFlagLabelConstraints: [NSLayoutConstraint] = []
    var currencyCodeConstraints: [NSLayoutConstraint] = []
    var currencyAmountConstraints: [NSLayoutConstraint] = []
    var bottomSeparatorConstraints: [NSLayoutConstraint] = []
    var currencyNameConstraints: [NSLayoutConstraint] = []
    var favoriteImageConstraints: [NSLayoutConstraint] = []

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

    let linesImage: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .clear
        return imgv
    }()

    let currencyFlagImage: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .clear
        imgv.contentMode = .scaleAspectFit
        return imgv
    }()

    let currencyFlagLabel: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()

    let currencyCode: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.textAlignment = .left
        return lbl
    }()

    let currencyName: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.textAlignment = .left
        return lbl
    }()

    let bottomSeparator: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 1.0, height: 1.0))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.color5.withAlphaComponent(0.1)
        return view
    }()

    lazy var currencyAmount: UILabel = {
        let lbl = UILabel()
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.textAlignment = .right
        return lbl
    }()

    let favoriteImage: UIImageView = {
        let imgv = UIImageView()
        imgv.backgroundColor = .clear
        imgv.contentMode = .scaleAspectFit
        imgv.image = UIImage(systemName: "star")
        imgv.tintColor = .orange
        return imgv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.value = ""
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
