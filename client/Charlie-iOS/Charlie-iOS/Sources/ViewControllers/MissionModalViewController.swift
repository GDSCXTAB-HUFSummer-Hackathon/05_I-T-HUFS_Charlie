//
//  MissonViewController.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import PanModal
import SnapKit
import Then
import UIKit

class MissionModalViewController: UIViewController {
    
    private lazy var missionTitle: String = ""
    private lazy var missionStartDate: String = ""
    private lazy var missionEndDate: String = ""
    private lazy var missionName: String = ""
    private lazy var missonCompletedUserNumber: Int = 261
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "ico_clear")?.resized(to: CGSize(width: 34, height: 34)), for: .normal)
        $0.addTarget(self, action: #selector(didTapClearButton), for: .touchUpInside)
    }
    
    @objc func didTapClearButton() {
        self.dismiss(animated: true)
    }
    
    let titleLabel = UILabel().then {
        $0.text = "Mission"
        $0.font = UIFont.D2CodingBold(size: 18)
        $0.textAlignment = .center
    }
    
    lazy var missionStickerImage = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    lazy var missionDescriptionLabel = UILabel().then {
        $0.font = UIFont.D2CodingBold(size: 18)
        $0.numberOfLines = 2
        $0.text = ""
        $0.setLabelLineHeight(lineHeight: 20.88)
        $0.textAlignment = .center
    }
    
    lazy var missionEndDateLabel = UILabel().then {
        $0.font = UIFont.D2Coding(size: 16)
        $0.text = ""
        $0.setLabelLineHeight(lineHeight: 18.56)
        $0.textAlignment = .center
    }
    
    lazy var missionCompletedNumberLabel = UILabel().then {
        $0.font = UIFont.D2Coding(size: 14)
        $0.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        $0.text = ""
        $0.setLabelLineHeight(lineHeight: 19.6)
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        getMission()
        setupLayout()
    }
}

extension MissionModalViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(484)
    }
    
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.2)
    }
    
    var shouldRoundTopCorners: Bool {
        return false
    }
}

private extension MissionModalViewController {
    
    func setupLayout() {
        [
            clearButton,
            titleLabel,
            missionStickerImage,
            missionDescriptionLabel,
            missionEndDateLabel,
            missionCompletedNumberLabel
        ].forEach { view.addSubview($0) }
        
        clearButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(82)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        missionStickerImage.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(120)
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        missionDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(missionStickerImage.snp.bottom).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        missionEndDateLabel.snp.makeConstraints {
            $0.top.equalTo(missionDescriptionLabel.snp.bottom).offset(20)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        missionCompletedNumberLabel.snp.makeConstraints{
            $0.top.equalTo(missionEndDateLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension MissionModalViewController {
    func getMission() {
        MissionAPI.shared.getMission( completion: { [self] (response) in
            switch response {
            case .success(let data):
                print(data)
                if let data = data as? Mission {
                    self.missionTitle = data.title
                    self.missionStartDate = data.startDateFormatted
                    self.missionEndDate = data.endDateFormatted
                    self.missionName = data.name
                    self.missonCompletedUserNumber = data.completedCount
                    
                    let stickerName:String = data.userCompleted ? "mission\(data.id)" : "mission\(data.id)_gray"
                    print(stickerName)
                    let url = URL(string: "https://charlie-storage.s3.ap-northeast-2.amazonaws.com/stickers/\(stickerName).png")
                //https://charlie-storage.s3.ap-northeast-2.amazonaws.com/stickers/mission1_gray.png
                    
                    DispatchQueue.main.async {
                        self.missionDescriptionLabel.text = "\(self.missionTitle)"
                        
                        let pluralCharlie: String = self.missonCompletedUserNumber == 1 ? "Charlie" : "Charlies"
                        self.missionCompletedNumberLabel.text = "\(self.missonCompletedUserNumber) \(pluralCharlie) completed this mission"
                        
                        self.missionEndDateLabel.text = "ends on \(self.missionEndDate)"
                        
                        self.missionStickerImage.kf.setImage(with: url)
                    }
                }
            case .requestErr(let message):
                print("requestErr", message)
            case .pathErr:
                print(".pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        })
    }
}
