//
//  BadgeModalViewController.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Kingfisher
import UIKit
import Then
import SnapKit
import PanModal

class BadgeModalViewController: UIViewController {
    var hasBadge:Bool = true
    var badgeName:String = ""
    var badgeSteps:Int = 0
    var badgeAwardedAt:String = ""
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "ico_clear")?.resized(to: CGSize(width: 34, height: 34)), for: .normal)
        $0.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
    }
    
    @objc func didTapClearButton() {
        self.dismiss(animated: true)
    }
    
    lazy var badgeImage = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let selectBadgeName:String = hasBadge ? badgeName : "gray"
        let url = URL(string: "https://charlie-storage.s3.ap-northeast-2.amazonaws.com/badges/\(selectBadgeName).png")
        $0.kf.setImage(with: url)
    }
    
    lazy var descriptionLabel = UILabel().then {
        $0.font = UIFont.D2Coding(size: 18)
        $0.numberOfLines = 2
        $0.text = "Charlie walked \n \(Formatter().numberFormatter(number: badgeSteps)) steps with you."
        $0.setLabelLineHeight(lineHeight: 25)
        $0.textAlignment = .center
    }
    
    lazy var awardLabel = UILabel().then{
        $0.textColor = UIColor(red: 0.312, green: 0.312, blue: 0.312, alpha: 1)
        $0.layer.cornerRadius = 20
        $0.font = UIFont.D2Coding(size: 16)
        $0.text = hasBadge ? "Awarded on \(badgeAwardedAt)" : "Not awarded yet"
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
}

extension BadgeModalViewController:PanModalPresentable {
    
    var panScrollable: UIScrollView? {
            return nil
        }
        var shortFormHeight: PanModalHeight {
            return .contentHeight(360)
        }
        var panModalBackgroundColor: UIColor {
            return UIColor.black.withAlphaComponent(0.2)
        }
        var shouldRoundTopCorners: Bool {
            return false
        }

    
    func setupLayout() {
        view.backgroundColor = UIColor(ciColor: .white)
        
        view.addSubview(badgeImage)
        view.addSubview(descriptionLabel)
        view.addSubview(awardLabel)
        view.addSubview(clearButton)
        
        badgeImage.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(100)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(180)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        awardLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(270)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        clearButton.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
}
