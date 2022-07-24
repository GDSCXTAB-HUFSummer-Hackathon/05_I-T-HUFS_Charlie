//
//  UserAPI.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation
import Moya

final class UserAPI {
    
    static let shared = UserAPI()
    var userProvider = MoyaProvider<UserService>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func getUserInfo(completion: @escaping (NetworkResult<Any>) -> Void) {
        userProvider.request(.getUserInfo) { (result) in
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
        guard let decodedData = try? decoder.decode(GenericResponse<UserInfo>.self, from: data)
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
