//
//  TagsLbl.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit

@IBDesignable class TagsLbl: UILabel {
    
    let fontValue = UIFont(name: "Avenir Next Regular",
                           size: 18)
    let textColorValue = UIColor.systemGray4
    
    
    @IBInspectable override var text: String? {
        didSet {
            setAttributedString(textContent: text)
        }
    }
    
    func setAttributedString(textContent: String?) {
        guard let text = textContent?.trimmingCharacters(in: .whitespacesAndNewlines),
              text.isEmpty == false else {
            self.attributedText = NSMutableAttributedString(string: "")
            isHidden = true
            return
        }
        
        let tagsList = text.components(separatedBy: " ")
        
        let tagsString = NSMutableAttributedString(string: tagsList[0] + "  ")
        let range = NSRange(location: 0, length: tagsList[0].count)
        tagsString.addAttribute(NSAttributedString.Key.backgroundColor,
                                value: textColorValue,
                                range: range)
        
        
        for i in 1..<tagsList.count {
            let range = NSRange(location: tagsString.length, length: tagsList[i].count)
            let currString = NSAttributedString(string: tagsList[i] + "  ")
            tagsString.append(currString)


            tagsString.addAttribute(NSAttributedString.Key.backgroundColor,
                                    value: textColorValue,
                                    range: range)

        }
            
        tagsString.addAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.label,
             NSAttributedString.Key.font: fontValue as Any],
            range: NSRange(location: 0, length: tagsString.length))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        tagsString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: tagsString.length))
        
        self.attributedText = tagsString
    }
}

