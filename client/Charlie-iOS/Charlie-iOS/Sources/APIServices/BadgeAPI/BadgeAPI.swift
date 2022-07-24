//
//  BadgeAPI.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation
import Moya

final class BadgeAPI {
    
    static let shared = BadgeAPI()
    var badgeProvider = MoyaProvider<BadgeService>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func getUserBadges(completion: @escaping (NetworkResult<Any>) -> Void) {
        badgeProvider.request(.getUserBadges) { (result) in
            switch result {
            case .success(let response):
                let statusCode = response.statusCode
                let data = response.data
                
                let networkResult = self.judgeStatus(by: statusCode, data)
                completion(networkResult)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func judgeStatus(by statusCode: Int, _ data: Data) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(GenericResponse<BadgesData>.self, from: data)
        else {
            return .pathErr
        }
        switch statusCode {
        case 200:
            return .success(decodedData.data)
        case 400..<500:
            return .requestErr(decodedData.message)
        case 500:
            return .serverErr
        default:
            return .networkFail
        }
    }
}
