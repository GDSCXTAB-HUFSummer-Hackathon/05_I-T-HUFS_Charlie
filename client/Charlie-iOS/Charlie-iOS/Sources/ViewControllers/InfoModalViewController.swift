//
//  InfoModalViewController.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import PanModal
import SnapKit
import Then
import UIKit

class InfoModalViewController: UIViewController {
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "ico_clear")?.resized(to: CGSize(width: 34, height: 34)), for: .normal)
        $0.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
    }
    
    @objc func didTapClearButton() {
        self.dismiss(animated: true)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "5 Levels of Charlie"
        $0.font = UIFont.D2CodingBold(size: 20)
    }
    
    let veryHealthyImageView = UIImageView().then {
        $0.image = UIImage(named: "img_veryhealthy")
        $0.contentMode = .scaleAspectFit
    }
    
    let healthyImageView = UIImageView().then {
        $0.image = UIImage(named: "img_healthy")
        $0.contentMode = .scaleAspectFit
    }
    
    let overweightImageView = UIImageView().then {
        $0.image = UIImage(named: "img_overweight")
        $0.contentMode = .scaleAspectFit
    }
    
    let obeseImageView = UIImageView().then {
        $0.image = UIImage(named: "img_obese")
        $0.contentMode = .scaleAspectFit
    }
    
    let veryObeseImageView = UIImageView().then {
        $0.image = UIImage(named: "img_veryobese")
        $0.contentMode = .scaleAspectFit
    }

    let veryHealthyLabel = UILabel().then {
        $0.text = "Very Healthy"
        $0.font = UIFont.D2CodingBold(size: 16)
    }
    
    let healthyLabel = UILabel().then {
        $0.text = "Healthy"
        $0.font = UIFont.D2CodingBold(size: 16)
    }
    
    let overweightLabel = UILabel().then {
        $0.text = "Overweight"
        $0.font = UIFont.D2CodingBold(size: 16)
    }
    
    let obeseLabel = UILabel().then {
        $0.text = "Obese"
        $0.font = UIFont.D2CodingBold(size: 16)
    }
    
    let veryObeseLabel = UILabel().then {
        $0.text = "Very Obese"
        $0.font = UIFont.D2CodingBold(size: 16)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
    }
}

extension InfoModalViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(660)
    }
    
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.2)
    }
    
    var shouldRoundTopCorners: Bool {
        return false
    }
}

private extension InfoModalViewController {
    func setupLayout() {
        [
            clearButton,
            titleLabel,
            veryHealthyImageView,
            healthyImageView,
            overweightImageView,
            obeseImageView,
            veryObeseImageView,
            veryHealthyLabel,
            healthyLabel,
            overweightLabel,
            obeseLabel,
            veryObeseLabel
        ].forEach { view.addSubview($0) }
        
        clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(82)
        }
        
        veryHealthyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.width.height.equalTo(100)
        }
        
        healthyImageView.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalTo(veryHealthyImageView.snp.bottom).offset(30)
            $0.width.height.equalTo(100)
        }
        
        overweightImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(70)
            $0.top.equalTo(healthyImageView.snp.bottom).offset(58)
            $0.width.height.equalTo(100)
        }
        
        obeseImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-70)
            $0.top.equalTo(veryObeseImageView.snp.bottom).offset(58)
            $0.width.height.equalTo(100)
        }
        
        veryObeseImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(veryHealthyImageView.snp.bottom).offset(30)
            $0.width.height.equalTo(100)
        }
        
        veryHealthyLabel.snp.makeConstraints {
            $0.centerX.equalTo(veryHealthyImageView.snp.centerX)
            $0.top.equalTo(veryHealthyImageView.snp.bottom).offset(8)
        }
        
        healthyLabel.snp.makeConstraints {
            $0.centerX.equalTo(healthyImageView.snp.centerX)
            $0.top.equalTo(healthyImageView.snp.bottom).offset(8)
        }
        
        overweightLabel.snp.makeConstraints {
            $0.centerX.equalTo(overweightImageView.snp.centerX)
            $0.top.equalTo(overweightImageView.snp.bottom).offset(8)
        }
        
        obeseLabel.snp.makeConstraints {
            $0.centerX.equalTo(obeseImageView.snp.centerX)
            $0.top.equalTo(obeseImageView.snp.bottom).offset(8)
        }
        
        veryObeseLabel.snp.makeConstraints {
            $0.centerX.equalTo(veryObeseImageView.snp.centerX)
            $0.top.equalTo(veryObeseImageView.snp.bottom).offset(8)
        }
    }
        
}
        
