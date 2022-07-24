//
//  Badge.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation

struct BadgesData: Codable {
    let badges: [Badge]
}

struct Badge: Codable {
    let id: Int
    let tier: Int
    let type: String
    let name: String
    let color: String
    let steps: Int
    let acquired: Bool
    let awardedAt: String
}
