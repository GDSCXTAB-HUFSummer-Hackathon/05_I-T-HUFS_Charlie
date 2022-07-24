//
//  SignUpService.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation
import Moya

enum SignUpService {
    
    case postSignUp(username: String, password: String)
    
}

extension SignUpService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postSignUp:
            return URLConstant.signUpURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSignUp:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postSignUp(let username, let password):
            return .requestParameters(parameters: [
                "username": username,
                "password": password
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postSignUp:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}
