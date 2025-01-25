//
//  ColumnFlowLayout.swift
//  iOS
//
//  Created by Oleh Poremskyy on 25.01.2025.
//

import Foundation
import UIKit

class ColumnFlowLayout: UICollectionViewFlowLayout {
    var cellsPerRow: Int
    let type: String?
    override var itemSize: CGSize {
        get {
            guard let collectionView = collectionView else {
                return super.itemSize
            }
            let marginsAndInsets =
                sectionInset.left + sectionInset.right + minimumInteritemSpacing
                * CGFloat(cellsPerRow - 1)
            let itemWidth =
                ((collectionView.bounds.size.width - marginsAndInsets)
                / CGFloat(cellsPerRow)).rounded(.down)
            let itemHeight =
                collectionView.bounds.size.height - sectionInset.top
                - sectionInset.bottom
            return CGSize(width: itemWidth, height: itemHeight)
        }
        set {
            super.itemSize = newValue
        }
    }
    init(
        cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0,
        minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero,
        type: String = ""
    ) {
        self.cellsPerRow = cellsPerRow
        self.type = type
        super.init()
        self.scrollDirection = UICollectionView.ScrollDirection.horizontal
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func invalidationContext(forBoundsChange newBounds: CGRect)
        -> UICollectionViewLayoutInvalidationContext
    {
        let context =
            super.invalidationContext(forBoundsChange: newBounds)
            as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics =
            newBounds != collectionView?.bounds
        return context
    }
    override func targetContentOffset(
        forProposedContentOffset proposedContentOffset: CGPoint,
        withScrollingVelocity velocity: CGPoint
    ) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        let pageWidth = itemSize.width + minimumLineSpacing
        let currentPage: CGFloat = collectionView.contentOffset.x / pageWidth
        let nearestPage: CGFloat = round(currentPage)
        let isNearPreviousPage = nearestPage < currentPage
        var pageDiff: CGFloat = 0
        let velocityThreshold: CGFloat = 0.5
        if isNearPreviousPage {
            if velocity.x > velocityThreshold {
                pageDiff = 1
            }
        } else {
            if velocity.x < -velocityThreshold {
                pageDiff = -1
            }
        }
        let x = (nearestPage + pageDiff) * pageWidth
        let cappedX = max(0, x)
        return CGPoint(x: cappedX, y: proposedContentOffset.y)
    }
}
