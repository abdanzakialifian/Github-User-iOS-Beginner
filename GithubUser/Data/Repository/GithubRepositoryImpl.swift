//
//  GithubRepositoryImpl.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation
import Alamofire
import Combine

class GithubRepositoryImpl : GithubRepository {
    // MARK : Singleton
    static let shared = GithubRepositoryImpl()
    
    let apiService = ApiService.shared
    
    let endPoint = EndPoint.shared
    
    func getListUsers(query: String) -> AnyPublisher<[ListUsers], AFError> {
        let parameters = [
            "q" : query.isEmpty ? "a" : query
        ] as [String: Any]
        
        return apiService.get(endPoint.searchUsers, model: ListUserResponse.self, parameters: parameters)
            .map { listUserResponse in
                return listUserResponse.items?.map { userItemResponse in
                    ListUsers(
                        login: userItemResponse.login,
                        id: userItemResponse.id,
                        avatarURL: userItemResponse.avatarURL
                    )
                } ?? []
            }
            .eraseToAnyPublisher()
    }
}
