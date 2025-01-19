//
//  ItemSlideView.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

class ItemSlideView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViews() {
        //self.addSubview(imageView)
        self.backgroundColor = UIColor.green
    }

    private func layoutViews() {
        layoutImageView()
    }

    private func layoutImageView() {
        //        NSLayoutConstraint.activate([
        //            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 55),
        //            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        //            imageView.widthAnchor.constraint(equalToConstant: 260),
        //            imageView.heightAnchor.constraint(equalToConstant: 260)
        //        ])
    }
}
