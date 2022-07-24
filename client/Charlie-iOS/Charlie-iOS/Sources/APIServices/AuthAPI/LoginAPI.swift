//
//  LoginAPI.swift
//  Charlie-iOS
//
//  Created by ji Won Jeoung on 2022/07/23.
//

import Foundation
import Moya

final class LoginAPI {
    
    static let shared = LoginAPI()
    var loginProvider = MoyaProvider<LoginService>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func postLogin(username: String, password: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        loginProvider.request(.postLogin(username: username, password: password)) { (result) in
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
        guard let decodedData = try? decoder.decode(GenericResponse<Login>.self, from: data)
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
