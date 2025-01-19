//
//  Extension+ViewController.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit

extension UIViewController {

    func add(
        childViewController viewController: UIViewController,
        to contentView: UIView
    ) {
        let matchParentConstraints = [
            viewController.view.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            viewController.view.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            viewController.view.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
        ]

        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewController.view)
        NSLayoutConstraint.activate(matchParentConstraints)
        viewController.didMove(toParent: self)
    }

}
