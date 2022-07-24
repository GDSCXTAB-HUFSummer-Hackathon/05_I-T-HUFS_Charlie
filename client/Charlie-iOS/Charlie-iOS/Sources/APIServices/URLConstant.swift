//
//  URLConstant.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation

struct URLConstant {
    
    // MARK: - BASE
    
    static let baseURL = "https://charlie-server-production.up.railway.app"
    
    // MARK: - Auth
    
    // 회원가입 (POST)
    static let signUpURL = "/user/"
    
    // 로그인 (POST)
    static let loginURL = "/user/login"
    
    // MARK: - Charlie
    
    // 찰리 상태 조회 (GET), 찰리 커스텀 (PUT)
    static let charlieURL = "/charlie"
    
    // MARK: - Log
    
    // 걸음수 로그 존재 여부 조회 (GET)
    static let isLogURL = "/log/logExists"
    
    // 걸음수 로그 조회 (GET)
    static let logURL = "/log"
    
    // MARK: - Badge
    
    // 뱃지 보유 목록 조회 (GET)
    static let badgesURL = "/badge"
    
    // MARK: - UserInfo
    
    // 사용자 정보 조회 (GET)
    static let userInfoURL = "/user/mypage"
    
    // MARK: - Mission
    
    // 미션 정보 조회 (GET)
    static let missionURL = "/mission"
}
