//
//  SignUpViewController.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import SnapKit
import Then
import UIKit

class SignUpViewController: UIViewController {

    let signUpLabel = UILabel().then {
        $0.text = "Sign Up"
        $0.font = UIFont.D2CodingBold(size: 20)
    }
    
    let userNameLabel = UILabel().then {
        $0.text = "Username"
        $0.font = UIFont.D2Coding(size: 16)
    }

    let userNameField = UITextField().then {
        $0.resignFirstResponder()
        $0.returnKeyType = .done
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.keyboardType = .asciiCapable
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.placeholder = "userName"
        $0.tintColor = .black
        $0.font = UIFont.D2Coding(size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
    }
    
    let passwordLabel = UILabel().then {
        $0.text = "PASSWORD"
        $0.font = UIFont.D2Coding(size: 16)
    }

    let passwordField = UITextField().then {
        $0.returnKeyType = .done
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.keyboardType = .asciiCapable
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.placeholder = "password"
        $0.tintColor = .black
        $0.font = UIFont.D2Coding(size: 16)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        $0.leftViewMode = .always
        $0.isSecureTextEntry = true
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setButtonAttributedTitle(text: "Sign Up", font: UIFont.D2CodingBold(size: 20), color: .white)
        $0.backgroundColor = .black
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
    }
    
    @objc func didTapSignUpButton() {
        self.postSignUp()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationController?.setupNavigationItem(self)
        
        userNameField.delegate = self
        passwordField.delegate = self
        
        setupLayout()
    }

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField {
            passwordField.becomeFirstResponder()
        } else {
            passwordField.resignFirstResponder()
        }
        
        return true
    }
}

private extension SignUpViewController {
    func setupLayout() {
        [
            signUpLabel,
            userNameLabel,
            userNameField,
            passwordLabel,
            passwordField,
            signUpButton
        ].forEach { view.addSubview($0) }
        
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(23)
            $0.left.equalToSuperview().offset(16)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(16)
        }
        
        userNameField.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(60)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(userNameField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(16)
        }
        
        passwordField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(60)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(passwordField.snp.bottom).offset(40)
            $0.right.equalToSuperview().offset(-16)
            $0.width.equalTo(160)
            $0.height.equalTo(55)
        }
    }
}

extension SignUpViewController {
    func postSignUp() {
        SignUpAPI.shared.postSignUp(username: userNameField.text!, password: passwordField.text!, completion: { (response) in
            switch response {
            case .success(let data):
                if let userData = data as? SignUp {
                    UserDefaults.standard.setValue(userData.token, forKey: "JWT_ACCESS_TOKEN")
                    UserDefaults.standard.setValue(userData.username, forKey: "USER_NAME")
                    UserDefaults.standard.setValue(userData.createdAt, forKey: "USER_CREATEDAT")
                    self.navigationController?.pushViewController(HomeViewController(), animated: false)
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
