//
//  MissonService.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation
import Moya

enum MissionService {
    
    case getMission
    
}

extension MissionService: TargetType {
    
    var baseURL: URL {
        return URL(string: URLConstant.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getMission:
            return URLConstant.missionURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMission:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMission:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Bearer": UserDefaults.standard.string(forKey: "JWT_ACCESS_TOKEN")!
        ]
    }
}

