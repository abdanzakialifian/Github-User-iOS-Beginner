//
//  NetworkLogger.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation
import Alamofire

class NetworkLogger : EventMonitor {
    func requestDidFinish(_ request: Request) {
        debugPrint(request.description)
    }
    
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            debugPrint(json)
        }
    }
}
