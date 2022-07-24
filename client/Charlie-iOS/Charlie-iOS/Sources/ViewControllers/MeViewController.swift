//
//  MeViewController.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import UIKit
import Then
import SnapKit

class MeViewController: UIViewController {
    
    let userName = UserDefaults.standard.string(forKey: "USER_NAME")!
    let userCreatedDate = UserDefaults.standard.string(forKey: "USER_CREATEDAT")!
    
    var headwearIndex: Int = 0
    var otherIndex: Int = 0
    
    let headwearScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    let headwearStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.backgroundColor = .white
    }
    var headwearArray = [UIButton]()
    
    private lazy var noneHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear1"), for: .normal)
    }
    private lazy var blueHeadbandHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear2"), for: .normal)
    }
    private lazy var greenHeadbandHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear3"), for: .normal)
    }
    private lazy var purpleHeadbandHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear4"), for: .normal)
    }
    private lazy var pirateHatHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear5"), for: .normal)
    }
    private lazy var cowboyHatHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear6"), for: .normal)
    }
    private lazy var chickenHatHeadwearButton = UIButton().then {
        $0.setImage(UIImage(named: "headwear7"), for: .normal)
    }
    
    private lazy var noneHeadwearLabel = UILabel().then {
        $0.text = "none"
    }
    private lazy var blueHeadbandHeadwearLabel = UILabel().then {
        $0.text = "blue\nheadband"
    }
    private lazy var greenHeadbandHeadwearLabel = UILabel().then {
        $0.text = "green\nheadband"
    }
    private lazy var purpleHeadbandHeadwearLabel = UILabel().then {
        $0.text = "purple\nheadband"
    }
    private lazy var pirateHatHeadwearLabel = UILabel().then {
        $0.text = "pirate hat"
    }
    private lazy var cowboyHatHeadwearLabel = UILabel().then {
        $0.text = "cowboy hat"
    }
    private lazy var chickenHatHeadwearLabel = UILabel().then {
        $0.text = "chicken hat"
    }
    
    let otherScrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    let otherStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.backgroundColor = .white
    }
    var otherArray = [UIButton]()
    
    private lazy var noneOtherButton = UIButton().then {
        $0.setImage(UIImage(named: "other1"), for: .normal)
    }
    private lazy var sunglassesOtherButton = UIButton().then {
        $0.setImage(UIImage(named: "other2"), for: .normal)
    }
    private lazy var bubbleOtherButton = UIButton().then {
        $0.setImage(UIImage(named: "other3"), for: .normal)
    }
    private lazy var sparklesOtherButton = UIButton().then {
        $0.setImage(UIImage(named: "other4"), for: .normal)
    }
    
    private lazy var noneOtherLabel = UILabel().then {
        $0.text = "none"
    }
    private lazy var sunglassesOtherLabel = UILabel().then {
        $0.text = "susplasses"
    }
    private lazy var bubbleOtherLabel = UILabel().then {
        $0.text = "..."
    }
    private lazy var sparklesOtherLabel = UILabel().then {
        $0.text = "sparkles"
    }
    
    private lazy var headwearLabel = UILabel().then {
        $0.font = UIFont.D2CodingBold(size: 16)
        $0.text = "headwear"
    }
    
    private lazy var otherLabel = UILabel().then {
        $0.font = UIFont.D2CodingBold(size: 16)
        $0.text = "other"
    }

    lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.D2CodingBold(size: 20)
        $0.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        $0.text = userName
    }
    
    lazy var userBioLabel = UILabel().then {
        $0.font = UIFont.D2Coding(size: 16)
        $0.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        $0.text = "walking charlie since \(userCreatedDate)"
    }
    
    private lazy var logoutButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Logout", font: UIFont.D2Coding(size: 16))
        $0.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    @objc func didTapLogoutButton() {
        UserDefaults.standard.removeObject(forKey: "JWT_ACCESS_TOKEN")
        self.view.window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        configureArray()
        getCharlie()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setupNavigationItem(self)
        view.backgroundColor = .white

        setupLayout()
    }
}

extension UILabel {
    func setupLabel() {
        self.font = UIFont.D2Coding(size: 12)
        self.numberOfLines = 2
        self.setLabelLineHeight(lineHeight: 14)
        self.textAlignment = .center
    }
}

extension MeViewController {
    
    func getCharlie() {
        CharlieAPI.shared.getCharlie(completion: { (response) in
            switch response {
            case .success(let data):
                if let data = data as? Charlie {
                    self.headwearIndex = data.headwear - 1
                    self.otherIndex = data.other - 1
                    self.updateHeadwearArray()
                    self.updateOtherArray()
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
    
    func putCharlie() {
        CharlieAPI.shared.putCharlie(headwear: headwearIndex + 1, other: otherIndex + 1, completion: { (response) in
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
}

private extension MeViewController {
    
    func setupHeadwearButton(_ button: UIButton) {
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapHeadwearButton), for: .touchUpInside)
    }
    
    @objc func didTapHeadwearButton(_ sender: UIButton) {
        headwearIndex = headwearArray.firstIndex(of: sender)!
        updateHeadwearArray()
        putCharlie()
    }
    
    func setupOtherButton(_ button: UIButton) {
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapOtherButton), for: .touchUpInside)
    }
    
    @objc func didTapOtherButton(_ sender: UIButton) {
        otherIndex = otherArray.firstIndex(of: sender)!
        updateOtherArray()
        putCharlie()
    }
    
    func updateHeadwearArray() {
        for (index, button) in headwearArray.enumerated() {
            if index == headwearIndex {
                button.isSelected = true
                setButtonBorder(button)
            } else {
                button.isSelected = false
                button.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    func updateOtherArray() {
        for (index, button) in otherArray.enumerated() {
            if index == otherIndex {
                button.isSelected = true
                setButtonBorder(button)
            } else {
                button.isSelected = false
                button.layer.borderColor = UIColor.white.cgColor
            }
        }
    }
    
    func setButtonBorder(_ button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
    }
    
    func configureArray() {
        
        [
            noneHeadwearButton,
            blueHeadbandHeadwearButton,
            greenHeadbandHeadwearButton,
            purpleHeadbandHeadwearButton,
            pirateHatHeadwearButton,
            cowboyHatHeadwearButton,
            chickenHatHeadwearButton
        ].enumerated().forEach {
            headwearArray.append($1)
        }
        
        [
            noneOtherButton,
            sunglassesOtherButton,
            bubbleOtherButton,
            sparklesOtherButton
        ].enumerated().forEach {
            otherArray.append($1)
        }
    }
    
    func setupLayout() {
        [
            userNameLabel,
            userBioLabel,
            headwearLabel,
            headwearScrollView,
            otherLabel,
            otherScrollView,
            logoutButton
        ].forEach { view.addSubview($0) }
        
        [
            noneHeadwearButton,
            blueHeadbandHeadwearButton,
            greenHeadbandHeadwearButton,
            purpleHeadbandHeadwearButton,
            pirateHatHeadwearButton,
            cowboyHatHeadwearButton,
            chickenHatHeadwearButton
        ].forEach {
            headwearStackView.addArrangedSubview($0)
            setupHeadwearButton($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(80)
            }
        }
        
        [
            noneHeadwearLabel,
            blueHeadbandHeadwearLabel,
            greenHeadbandHeadwearLabel,
            purpleHeadbandHeadwearLabel,
            pirateHatHeadwearLabel,
            cowboyHatHeadwearLabel,
            chickenHatHeadwearLabel
        ].forEach {
            $0.setupLabel()
            headwearScrollView.addSubview($0)
        }
        
        [
            noneOtherButton,
            sunglassesOtherButton,
            bubbleOtherButton,
            sparklesOtherButton,
        ].forEach {
            otherStackView.addArrangedSubview($0)
            setupOtherButton($0)
            $0.snp.makeConstraints {
                $0.width.height.equalTo(80)
            }
        }
        
        [
            noneOtherLabel,
            sunglassesOtherLabel,
            bubbleOtherLabel,
            sparklesOtherLabel
        ].forEach {
            $0.setupLabel()
            otherScrollView.addSubview($0)
        }
        
        headwearScrollView.addSubview(headwearStackView)
        otherScrollView.addSubview(otherStackView)
        
        userNameLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(23)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
        }
        
        userBioLabel.snp.makeConstraints {
            $0.width.equalTo(280)
            $0.height.equalTo(19)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(12)
        }
        
        headwearLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.top.equalTo(userBioLabel.snp.bottom).offset(50)
        }
        
        headwearStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        headwearScrollView.snp.makeConstraints {
            $0.top.equalTo(headwearLabel.snp.bottom).offset(12)
            $0.width.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        noneHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(noneHeadwearButton.snp.centerX)
            $0.top.equalTo(noneHeadwearButton.snp.bottom).offset(8)
        }
        
        blueHeadbandHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(blueHeadbandHeadwearButton.snp.centerX)
            $0.top.equalTo(blueHeadbandHeadwearButton.snp.bottom).offset(8)
        }
        
        greenHeadbandHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(greenHeadbandHeadwearButton.snp.centerX)
            $0.top.equalTo(greenHeadbandHeadwearButton.snp.bottom).offset(8)
        }
        
        purpleHeadbandHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(purpleHeadbandHeadwearButton.snp.centerX)
            $0.top.equalTo(purpleHeadbandHeadwearButton.snp.bottom).offset(8)
        }
        
        pirateHatHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(pirateHatHeadwearButton.snp.centerX)
            $0.top.equalTo(pirateHatHeadwearButton.snp.bottom).offset(8)
        }
        
        cowboyHatHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(cowboyHatHeadwearButton.snp.centerX)
            $0.top.equalTo(cowboyHatHeadwearButton.snp.bottom).offset(8)
        }
        
        chickenHatHeadwearLabel.snp.makeConstraints {
            $0.centerX.equalTo(chickenHatHeadwearButton.snp.centerX)
            $0.top.equalTo(chickenHatHeadwearButton.snp.bottom).offset(8)
        }
        
        otherLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.top.equalTo(headwearScrollView.snp.bottom).offset(40)
        }
        
        otherStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        otherScrollView.snp.makeConstraints {
            $0.top.equalTo(otherLabel.snp.bottom).offset(12)
            $0.width.equalToSuperview()
            $0.height.equalTo(116)
        }
        
        noneOtherLabel.snp.makeConstraints {
            $0.centerX.equalTo(noneOtherButton.snp.centerX)
            $0.top.equalTo(noneOtherButton.snp.bottom).offset(8)
        }
        
        sunglassesOtherLabel.snp.makeConstraints {
            $0.centerX.equalTo(sunglassesOtherButton.snp.centerX)
            $0.top.equalTo(sunglassesOtherButton.snp.bottom).offset(8)
        }
        
        bubbleOtherLabel.snp.makeConstraints {
            $0.centerX.equalTo(bubbleOtherButton.snp.centerX)
            $0.top.equalTo(bubbleOtherButton.snp.bottom).offset(8)
        }
        
        sparklesOtherLabel.snp.makeConstraints {
            $0.centerX.equalTo(sparklesOtherButton.snp.centerX)
            $0.top.equalTo(sparklesOtherButton.snp.bottom).offset(8)
        }
        
        logoutButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
}
