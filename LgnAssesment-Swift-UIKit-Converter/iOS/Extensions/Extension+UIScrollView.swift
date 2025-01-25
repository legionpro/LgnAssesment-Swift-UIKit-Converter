//
//  Extension+UIScrollView.swift
//  iOS
//
//  Created by Oleh Poremskyy on 21.01.2025.
//

import UIKit

extension UIScrollView {

    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            self.scrollRectToVisible(
                CGRect(
                    x: childStartPoint.x, y: 0, width: self.frame.width,
                    height: 1), animated: animated)
        }
    }

    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    func scrollToBottom() {
        let bottomOffset = CGPoint(
            x: 0,
            y: contentSize.height - bounds.size.height + contentInset.bottom)
        if bottomOffset.y > 0 {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
