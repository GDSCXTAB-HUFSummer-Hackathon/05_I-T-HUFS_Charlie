//
//  WelcomeViewController.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Lottie
import SnapKit
import Then
import UIKit

class WelcomeViewController: UIViewController {
    
    let charlieAnimationView = AnimationView(name: "charlie-lottie")
    
    private lazy var signUpButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Sign Up", font: UIFont.D2CodingBold(size: 20), color: .white)
        $0.backgroundColor = .black
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    @objc func didTapSignUpButton() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: false)
    }
    
    private lazy var logInButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Log In", font: UIFont.D2CodingBold(size: 20))
        $0.addTarget(self, action: #selector(didTapLogInButton), for: .touchUpInside)
    }
    
    @objc func didTapLogInButton() {
        self.navigationController?.pushViewController(LogInViewController(), animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playCharlieAnimation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationController?.setupNavigationItem(self)
        setupLayout()
        playCharlieAnimation()
    }
    
}

private extension WelcomeViewController {
    func playCharlieAnimation() {
        charlieAnimationView.loopMode = .loop
        charlieAnimationView.play()
    }
    
    func setupLayout() {
        [
            charlieAnimationView,
            signUpButton,
            logInButton
        ].forEach { view.addSubview($0) }
        
        charlieAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-115)
            $0.width.height.equalTo(240)
        }
        
        signUpButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(charlieAnimationView.snp.bottom).offset(40)
            $0.width.equalTo(160)
            $0.height.equalTo(55)
        }
        
        logInButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(signUpButton.snp.bottom).offset(16)
            $0.width.equalTo(160)
            $0.height.equalTo(55)
        }
    }
}
