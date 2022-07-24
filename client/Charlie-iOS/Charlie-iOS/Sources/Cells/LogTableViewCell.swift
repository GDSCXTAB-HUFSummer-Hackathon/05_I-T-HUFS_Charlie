//
//  LogTableViewCell.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import UIKit
import SnapKit
import Then

class LogTableViewCell: UITableViewCell {
    
    static let identifier = "LogTableViewCell"
    
    private lazy var stepsLabel = UILabel().then {
        $0.font = UIFont.D2CodingBold(size: 16)
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font = UIFont.D2Coding(size: 16)
    }

    func setupView(steps: String, date: String) {
        setupLayout()
        stepsLabel.text = steps + " steps"
        dateLabel.text = date
    }
    
}

private extension LogTableViewCell {
    func setupLayout() {
        [
            stepsLabel,
            dateLabel
        ].forEach { addSubview($0) }
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        stepsLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(stepsLabel.snp.bottom).offset(8)
            $0.left.bottom.right.equalToSuperview().inset(16)
        }
    }
}
