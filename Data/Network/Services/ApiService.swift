//
//  ApiService.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation
import Alamofire
import Combine

class ApiService {
    // MARK : Singleton
    static let shared = ApiService()
    
    let sessionManager: Session = {
        let headers: HTTPHeaders = [
            "Authorization": "",
        ]
        
        let networkLogger = NetworkLogger()
        
        let configuration = URLSessionConfiguration.af.default
        
        configuration.headers = headers
        
        configuration.waitsForConnectivity = true
        
        configuration.timeoutIntervalForRequest = 30
        
        return Session(configuration: configuration, eventMonitors: [networkLogger])
    }()
    
    let baseUrl = "https://api.github.com/"
    
    func get<T: Decodable>(_ endPointUrl: String, model: T.Type) -> AnyPublisher<T, AFError> {
        return sessionManager.request(baseUrl.appending(endPointUrl), method: .get)
            .validate()
            .publishDecodable(type: model)
            .value()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
