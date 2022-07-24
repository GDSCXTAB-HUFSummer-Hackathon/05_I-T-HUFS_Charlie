//
//  LoginService.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation
import Moya

enum LoginService {
    
    case postLogin(username: String, password: String)
    
}

extension LoginService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .postLogin:
            return URLConstant.loginURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postLogin(let username, let password):
            return .requestParameters(parameters: [
                "username": username,
                "password": password
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .postLogin:
            return [
                "Content-Type": "application/json"
            ]
        }
    }
}
