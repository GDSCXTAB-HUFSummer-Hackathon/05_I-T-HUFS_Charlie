//
//  HomeViewController.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import HealthKit
import Kingfisher
import PanModal
import SnapKit
import Then
import UIKit

class HomeViewController: UIViewController {
    
    private lazy var isLog: Bool = true
    
    private let healthStore = HKHealthStore()
    
    private let typeToRead = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!])
    
    private var stepCount: Int = 0
    
    private lazy var infoButton = UIButton().then {
        $0.setImage(UIImage(named: "ico_info")?.resized(to: CGSize(width: 34, height: 34)), for: .normal)
        $0.addTarget(self, action: #selector(didTapInfoButton), for: .touchUpInside)
    }
    
    private lazy var missionButton = UIButton().then {
        $0.setImage(UIImage(named: "ico_mission")?.resized(to: CGSize(width: 30, height: 30)), for: .normal)
        $0.addTarget(self, action: #selector(didTapMissionButton), for: .touchUpInside)
    }
    
    @objc func didTapInfoButton() {
        let vc = InfoModalViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.presentPanModal(vc)
    }
    
    @objc func didTapMissionButton() {
        let vc = MissionModalViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        self.presentPanModal(vc)
    }
    
    private lazy var homeProgressStackView = HomeProgressStackView()
    
    private lazy var charlieNumber: String = "3111"
    private lazy var charlieImageUrl = URL(string: "https://charlie-storage.s3.ap-northeast-2.amazonaws.com/images/\(charlieNumber).png")
    
    private lazy var charlieImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var stepCountLabel = UILabel().then {
        $0.text = "Charlie walked \(Formatter().numberFormatter(number: stepCount)) steps\nwith you today."
        $0.numberOfLines = 2
        $0.font = UIFont.D2Coding(size: 16)
        $0.setLabelLineHeight(lineHeight: 22)
    }
    
    private lazy var logButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Log", font: UIFont.D2Coding(size: 16))
        $0.setImage(UIImage(named: "ico_log")?.resized(to: CGSize(width: 80, height: 80)), for: .normal)
        $0.addTarget(self, action: #selector(didTapLogButton), for: .touchUpInside)
    }
    
    @objc func didTapLogButton() {
        self.navigationController?.pushViewController(LogViewController(), animated: false)
    }
    
    private lazy var badgesButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Collected", font: UIFont.D2Coding(size: 16))
        $0.setImage(UIImage(named: "ico_badges")?.resized(to: CGSize(width: 80, height: 80)), for: .normal)
        $0.addTarget(self, action: #selector(didTapBadgesButton), for: .touchUpInside)
    }
    
    @objc func didTapBadgesButton() {
        self.navigationController?.pushViewController(BadgeViewController(), animated: false)
    }
    
    private lazy var meButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Charlie", font: UIFont.D2Coding(size: 16))
        $0.setImage(UIImage(named: "ico_me")?.resized(to: CGSize(width: 80, height: 80)), for: .normal)
        $0.addTarget(self, action: #selector(didTapMeButton), for: .touchUpInside)
    }
    
    @objc func didTapMeButton() {
        self.navigationController?.pushViewController(MeViewController(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        requestAuthorization()
        getCharlie()
        getIsLog()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.setupNavigationItem(self)
        
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 8
        
        logButton.configuration = config
        badgesButton.configuration = config
        meButton.configuration = config
        
        setupLayout()
    }
    
}

extension HomeViewController {
    func configure() {
        if !HKHealthStore.isHealthDataAvailable() {
            print("권한 필요")
            requestAuthorization()
        } else {
            print("권한 있음")
            retrieveStepData()
        }
    }
    
    func requestAuthorization() {
        self.healthStore.requestAuthorization(toShare: nil, read: typeToRead, completion: { success, error in
            if error != nil {
                print(error.debugDescription)
            } else {
                if success {
                    print("권한 승인 완료")
                    self.retrieveStepData()
                } else {
                    print("권한 승인 실패")
                }
            }
        })
    }
    
    func retrieveStepData() {
                
        let stepType = HKSampleType.quantityType(forIdentifier: .stepCount)!
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("걸음 수 데이터 없음")
                return
            }
            
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCount = steps
            self.homeProgressStackView.stepCount = steps
            print("Total: \(steps)")
            DispatchQueue.main.async {
                self.changeInMainThread()
                self.homeProgressStackView.changeInMainThread()
            }
        }
        healthStore.execute(query)
    }
}


private extension HomeViewController {
    
    func changeInMainThread() {
        let pluralStep: String = self.stepCount == 1 ? "step" : "steps"
        self.stepCountLabel.text = "Charlie walked \(Formatter().numberFormatter(number: self.stepCount)) \(pluralStep) \nwith you today."
    }
    
    func setupLayout() {
        [
            infoButton,
            missionButton,
            homeProgressStackView,
            charlieImageView,
            stepCountLabel,
            logButton,
            badgesButton,
            meButton
        ].forEach { view.addSubview($0) }
        
        infoButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        missionButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
        
        homeProgressStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(infoButton.snp.bottom)
        }
        
        stepCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(charlieImageView.snp.bottom).offset(40)
        }
        
        charlieImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-95)
            $0.width.height.equalTo(240)
        }
        
        logButton.snp.makeConstraints {
            $0.centerY.equalTo(badgesButton.snp.centerY)
            $0.right.equalTo(badgesButton.snp.left).offset(-23)
            $0.width.equalTo(80)
            $0.height.equalTo(107)
        }
        
        badgesButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
            $0.width.equalTo(100)
            $0.height.equalTo(107)
        }
        
        meButton.snp.makeConstraints {
            $0.centerY.equalTo(badgesButton.snp.centerY)
            $0.left.equalTo(badgesButton.snp.right).offset(23)
            $0.width.equalTo(80)
            $0.height.equalTo(107)
        }
    }
}

extension HomeViewController {
    func getIsLog() {
        LogAPI.shared.getIsLog(completion: { (response) in
            switch response {
            case .success(let data):
                if let data = data as? IsLog {
                    self.isLog = data.res
                    if (self.isLog) {
                        print("putUserLog()")
                        self.putUserLog()
                    } else {
                        print("postUserLog()")
                        self.postUserLog()
                    }
                    self.getCharlie()
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
    
    func postUserLog() {
        LogAPI.shared.postUserLog(steps: self.stepCount, completion: { (response) in
            switch response {
            case .success(let data):
                print("success", data)
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
    
    func putUserLog() {
        LogAPI.shared.putUserLog(steps: self.stepCount, completion: { (response) in
            switch response {
            case .success(let data):
                print("success", data)
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
    
    func getCharlie() {
        CharlieAPI.shared.getCharlie(completion: { (response) in
            switch response {
            case .success(let data):
                if let data = data as? Charlie {
                    self.charlieNumber = String(data.body) + String(data.face) + String(data.headwear) + String(data.other)
                    self.charlieImageUrl = URL(string: "https://charlie-storage.s3.ap-northeast-2.amazonaws.com/images/\(self.charlieNumber).png")
                    self.charlieImageView.kf.setImage(with: self.charlieImageUrl)
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
