//
//  Log.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation

struct LogsData: Codable {
    let logs: [Log]
}

struct Log: Codable {
    let steps: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case steps
        case date = "dateStringified"
    }
}

struct IsLog: Codable {
    let res: Bool
}

struct Steps: Codable {
    let steps: Int
}
