//
//  CollectionViewCell.swift
//  iOS
//
//  Created by Oleh Poremskyy on 25.01.2025.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let identifier = "DemoCollectionViewCell"

    var customView: ItemSlideView?
    var buttomView: UIView?
    var cConstraint = [NSLayoutConstraint]()
    var bConstraint = [NSLayoutConstraint]()

    // Lazy initialization of the UIImageView
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        NSLayoutConstraint.deactivate(cConstraint)
        NSLayoutConstraint.deactivate(cConstraint)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configure the cell with the image name
    func configure(with imageName: String) {
        imageView.image = UIImage(systemName: imageName)
    }

    // Setup the view and add imageView with constraints
    func setupView() {
        guard let iview = customView else { return }
        iview.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(iview)
        let cConstraint = [
            iview.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor),
            iview.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor),
            iview.topAnchor.constraint(
                equalTo: self.contentView.topAnchor),
            iview.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor
            ).withPriority(500),
        ]
        if let buttomView = buttomView {
            buttomView.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(buttomView)
            let bConstraint = [
                buttomView.leadingAnchor.constraint(
                    equalTo: self.contentView.leadingAnchor),
                buttomView.trailingAnchor.constraint(
                    equalTo: self.contentView.trailingAnchor),
                buttomView.topAnchor.constraint(
                    equalTo: iview.bottomAnchor
                ).withPriority(1000),
                buttomView.bottomAnchor.constraint(
                    equalTo: self.contentView.bottomAnchor),
                buttomView.heightAnchor.constraint(
                    equalToConstant: self.contentView.bounds.height / 3),
            ]
            NSLayoutConstraint.activate(bConstraint)
        }
        NSLayoutConstraint.activate(cConstraint)
    }

}
