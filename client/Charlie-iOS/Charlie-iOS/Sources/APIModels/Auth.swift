//
//  Auth.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation

struct SignUp: Codable {
    let token: String
    let id: String
    let username: String
    let password: String
    let createdAt: String
}


struct Login: Codable {
    let token: String
    let id: String
    let username: String
    let createdAt: String
}
