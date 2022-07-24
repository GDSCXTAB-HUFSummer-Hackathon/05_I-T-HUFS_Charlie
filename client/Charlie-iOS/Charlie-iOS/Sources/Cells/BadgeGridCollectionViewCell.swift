//
//  GridCollectionViewCell.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import UIKit
import Then
import SnapKit

class BadgeGridCollectionViewCell: UICollectionViewCell {
    var badgeImage: UIImageView!
    static var id: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }
    
    private func configure() {
        badgeImage = UIImageView()
        
        contentView.addSubview(badgeImage)
        badgeImage.snp.makeConstraints {
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
    }
}
