//
//  Formatter+Extension.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Then

extension Formatter {
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter().then {
            $0.numberStyle = .decimal
        }
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
}
