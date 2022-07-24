//
//  LogService.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation
import Moya

enum LogService {
    
    case getIsLog
    case getUserLog
    case postUserLog(steps: Int)
    case putUserLog(steps: Int)
    
}

extension LogService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getIsLog:
            return URLConstant.isLogURL
        case .getUserLog, .postUserLog, .putUserLog:
            return URLConstant.logURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getIsLog, .getUserLog:
            return .get
        case .postUserLog:
            return .post
        case .putUserLog:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getIsLog, .getUserLog:
            return .requestPlain
        case .postUserLog(let steps):
            return .requestParameters(parameters: [
                "steps": steps
            ], encoding: JSONEncoding.default)
        case .putUserLog(let steps):
            return .requestParameters(parameters: [
                "steps": steps
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getIsLog, .getUserLog, .postUserLog, .putUserLog:
            return [
                "Content-Type": "application/json",
                "Bearer": UserDefaults.standard.string(forKey: "JWT_ACCESS_TOKEN")!
            ]
        }
    }
}
