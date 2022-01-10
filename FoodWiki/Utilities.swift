//
//  Utilities.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/7/22.
//

import UIKit

extension UIImage {
    static func scale(img: UIImage, scale: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: img.size.width * scale, height: img.size.height * scale)

        UIGraphicsBeginImageContext(newSize)
        img.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
