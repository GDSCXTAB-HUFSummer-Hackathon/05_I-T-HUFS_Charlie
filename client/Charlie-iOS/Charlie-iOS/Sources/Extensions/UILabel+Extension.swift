//
//  UILabel+Extension.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import UIKit

extension UILabel {
    func setLabelLineHeight(lineHeight: CGFloat) {
        let attrString = NSMutableAttributedString(string: self.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
