//
//  UserService.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation
import Moya

enum UserService {
    
    case getUserInfo
    
}

extension UserService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo:
            return URLConstant.userInfoURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserInfo:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "JWT_ACCESS_TOKEN")!
            ]
        }
    }
}

