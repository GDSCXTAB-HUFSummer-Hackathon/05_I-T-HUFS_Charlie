//
//  HomeProgressStackView.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import SnapKit
import Then
import UIKit

class HomeProgressStackView: UIStackView {
    
    var stepCount: Int = 0

    private lazy var percentLabel = UILabel().then {
        $0.text = "\(self.stepCount >= 10000 ? 100 : self.stepCount/100)%"
        $0.font = UIFont.D2CodingBold(size: 18)
        $0.textColor = .black
    }
    
    private lazy var progressStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 2
        $0.backgroundColor = .white
    }
    
    private lazy var progressImage1 = UIImageView()
    private lazy var progressImage2 = UIImageView()
    private lazy var progressImage3 = UIImageView()
    private lazy var progressImage4 = UIImageView()
    private lazy var progressImage5 = UIImageView()
    private lazy var progressImage6 = UIImageView()
    private lazy var progressImage7 = UIImageView()
    private lazy var progressImage8 = UIImageView()
    private lazy var progressImage9 = UIImageView()
    private lazy var progressImage10 = UIImageView()
    
    private lazy var leftBracket = UIImageView().then {
        $0.image = UIImage(named: "img_leftbracket")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    private lazy var rightBracket = UIImageView().then {
        $0.image = UIImage(named: "img_rightbracket")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImageView {
    func setupProgressImage() {
        self.image = UIImage(named: "img_progress")?.withRenderingMode(.alwaysTemplate)
        self.contentMode = .scaleAspectFit
        self.tintColor = .white
    }
}

extension HomeProgressStackView {
    
    func changeInMainThread() {
        self.percentLabel.text = "\(self.stepCount >= 10000 ? 100 : self.stepCount/100)%"
        configureProgressStackView()
    }
    
    func configureProgressStackView() {
        
        if (self.stepCount >= 10000) {  // 걸음 수가 10000 이상일 때 label, bracket tintColor green으로 변경
            percentLabel.textColor = UIColor(named: "Green1")
            leftBracket.tintColor = UIColor(named: "Green1")
            rightBracket.tintColor = UIColor(named: "Green1")
        }
        
        [
            progressImage1,
            progressImage2,
            progressImage3,
            progressImage4,
            progressImage5,
            progressImage6,
            progressImage7,
            progressImage8,
            progressImage9,
            progressImage10
        ].enumerated().forEach {
            if (self.stepCount >= 10000) { // 걸음 수가 10000 이상일 때 progressImage tintColor green으로 변경
                $1.tintColor = UIColor(named: "Green1")
            } else if (($0 + 1) * 10 <= self.stepCount/100) {  // 걸음수가 10000 미만일 때 걸음수 퍼센트 만큼 progressImage tintColor black으로 변경
                $1.tintColor = .black
            } else {
                $1.tintColor = .white
            }
        }
    }
    
    func setupLayout() {
        
        [
            percentLabel,
            progressStackView,
            leftBracket,
            rightBracket
        ].forEach { addSubview($0) }
        
        [
            progressImage1,
            progressImage2,
            progressImage3,
            progressImage4,
            progressImage5,
            progressImage6,
            progressImage7,
            progressImage8,
            progressImage9,
            progressImage10
        ].forEach {
            $0.setupProgressImage()
            progressStackView.addArrangedSubview($0)
        }

        percentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        progressStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(percentLabel.snp.bottom).offset(12)
            $0.width.equalTo(298)
            $0.height.equalTo(16)
        }
        
        leftBracket.snp.makeConstraints {
            $0.centerY.equalTo(progressStackView.snp.centerY)
            $0.right.equalTo(progressStackView.snp.left).offset(-2)
        }
        
        rightBracket.snp.makeConstraints {
            $0.centerY.equalTo(progressStackView.snp.centerY)
            $0.left.equalTo(progressStackView.snp.right).offset(2)
        }
    }
}

