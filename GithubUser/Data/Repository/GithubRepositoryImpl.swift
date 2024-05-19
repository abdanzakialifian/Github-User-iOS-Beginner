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
    
    func getDetailUser(username: String) -> AnyPublisher<DetailUser, AFError> {
        return apiService.get(endPoint.detailUser.replacingOccurrences(of: "{username}", with: username), model: DetailUserResponse.self)
            .map { detailUserResponse in
                return DetailUser(
                    avatarURL: detailUserResponse.avatarURL,
                    followers: detailUserResponse.followers,
                    following: detailUserResponse.following,
                    publicRepos: detailUserResponse.publicRepos,
                    login: detailUserResponse.login,
                    name: detailUserResponse.name
                )
            }
            .eraseToAnyPublisher()
    }
    
    func getFollowerUsers(username: String) -> AnyPublisher<[ListUsers], Alamofire.AFError> {
        return apiService.get(endPoint.followersUser.replacingOccurrences(of: "{username}", with: username), model: [FollowerUsersResponse].self)
            .map { listFollowerResponse in
                return listFollowerResponse.map { userItemResponse in
                    ListUsers(
                        login: userItemResponse.login,
                        id: userItemResponse.id,
                        avatarURL: userItemResponse.avatarURL
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    func getFollowingUsers(username: String) -> AnyPublisher<[ListUsers], Alamofire.AFError> {
        return apiService.get(endPoint.followingUser.replacingOccurrences(of: "{username}", with: username), model: [FollowerUsersResponse].self)
            .map { listFollowerResponse in
                return listFollowerResponse.map { userItemResponse in
                    ListUsers(
                        login: userItemResponse.login,
                        id: userItemResponse.id,
                        avatarURL: userItemResponse.avatarURL
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
}
