//
//  Extension+String.swift
//  iOS
//
//  Created by Oleh Poremskyy on 19.01.2025.
//

import UIKit


extension String {
    
    func textToImage() -> UIImage? {
        let nsString = (self as NSString)
        let font = UIFont.systemFont(ofSize: 1024)
        let stringAttributes = [NSAttributedString.Key.font: font]
        let imageSize = nsString.size(withAttributes: stringAttributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        UIColor.clear.set()
        UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
        nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image ?? UIImage()
    }
    
    
    func deleteLeadingZeros() -> String {
      var resultStr = self
      while resultStr.hasPrefix("0") && resultStr.count > 1 {
       resultStr.removeFirst()
      }
      return resultStr
    }
}
