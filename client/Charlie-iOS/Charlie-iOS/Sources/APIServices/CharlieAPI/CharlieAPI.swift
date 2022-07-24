//
//  CharlieAPI.swift
//  Charlie-iOS
//
//  Created by Hyowon Jeon on 2022/07/23.
//

import Foundation
import Moya

final class CharlieAPI {
    
    static let shared = CharlieAPI()
    var charlieProvider = MoyaProvider<CharlieService>(plugins: [MoyaLoggingPlugin()])
    
    public init() { }
    
    func getCharlie(completion: @escaping (NetworkResult<Any>) -> Void) {
        charlieProvider.request(.getCharlie) { (result) in
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
    
    func putCharlie(headwear: Int, other: Int, completion: @escaping (NetworkResult<Any>) -> Void) {
        charlieProvider.request(.putCharlie(headwear: headwear, other: other)) { (result) in
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
        guard let decodedData = try? decoder.decode(GenericResponse<Charlie>.self, from: data)
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
