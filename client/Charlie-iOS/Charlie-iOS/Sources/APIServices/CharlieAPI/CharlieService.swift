//
//  CharlieService.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation
import Moya

enum CharlieService {
    
    case getCharlie
    case putCharlie(headwear: Int, other: Int)
    
}

extension CharlieService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getCharlie, .putCharlie:
            return URLConstant.charlieURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharlie:
            return .get
        case .putCharlie:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .getCharlie:
            return .requestPlain
        case .putCharlie(let headwear, let other):
            return .requestParameters(parameters: [
                "headwear": headwear,
                "other": other
            ], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getCharlie, .putCharlie:
            return [
                "Content-Type": "application/json",
                "Bearer": UserDefaults.standard.string(forKey: "JWT_ACCESS_TOKEN")!
            ]
        }
    }
}

