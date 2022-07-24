//
//  UIButton+Extension.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import UIKit

extension UIButton {
    func setButtonAttributedTitle(text: String, font: UIFont, color: UIColor = .black) {
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: font, .foregroundColor: color])
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
