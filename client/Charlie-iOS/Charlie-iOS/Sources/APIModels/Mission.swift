//
//  Misson.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation


struct Mission: Codable {
    let id: Int
    let name: String
    let title: String
    let startDate: String
    let endDate: String
    let steps: Int
    let ongoing: Bool
    let completedCount: Int
    let startDateFormatted: String
    let endDateFormatted: String
    let userCompleted: Bool
}
