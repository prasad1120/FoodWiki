//
//  TagsLbl.swift
//  FoodWiki
//
//  Created by Prasad Shinde on 1/9/22.
//

import UIKit

/// UILabel subclass for displaying tags on MealDetailsVC
@IBDesignable class TagsLbl: UILabel {
    
    let fontValue = UIFont(name: "Avenir Next Regular",
                           size: 18)
    let textColorValue = UIColor.systemGray4
    
    /// New custom field in attribute inspector
    @IBInspectable override var text: String? {
        didSet {
            setAttributedString(textContent: text)
        }
    }
    
    /// Sets passed string as attributed string to the TagsLbl after formatting
    func setAttributedString(textContent: String?) {
        
        // Hides the TagsLbl if text is not non empty
        guard let text = textContent?.trimmingCharacters(in: .whitespacesAndNewlines),
              text.isEmpty == false else {
            self.attributedText = NSMutableAttributedString(string: "")
            isHidden = true
            return
        }
        
        let tagsList = text.components(separatedBy: " ")
        
        // Set backgroundColor for first tag
        let tagsString = NSMutableAttributedString(string: tagsList[0] + "  ")
        let range = NSRange(location: 0, length: tagsList[0].count)
        tagsString.addAttribute(NSAttributedString.Key.backgroundColor,
                                value: textColorValue,
                                range: range)
        
        // Set backgroundColor for subsequent tags after first
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
        
        // Add Vertical spacing between multiline tags
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        tagsString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                value: paragraphStyle,
                                range: NSRange(location: 0, length: tagsString.length))
        
        self.attributedText = tagsString
    }
}

