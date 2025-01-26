//
//  ItemSlideView.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

// container view to put into MainViewController collectionViewCell
// separately contains controllers - keyboard and currency list

class ItemSlideView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViews() {
        self.backgroundColor = UIColor.clear
    }
}
