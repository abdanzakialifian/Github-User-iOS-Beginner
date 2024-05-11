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
    
    func getListUsers() -> AnyPublisher<[ListUsers], AFError> {
        return apiService.get("users", model: [ListUsersResponse].self)
            .map { listUsersResponses in
                return listUsersResponses.map { userResponse in
                    ListUsers(
                        login: userResponse.login,
                        id: userResponse.id,
                        avatarURL: userResponse.avatarURL
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
