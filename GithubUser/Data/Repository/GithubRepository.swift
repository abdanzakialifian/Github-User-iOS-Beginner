//
//  GithubRepository.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation
import Combine
import Alamofire

protocol GithubRepository {
    func getListUsers(query: String) -> AnyPublisher<[ListUsers], AFError>
    func getDetailUser(username: String) -> AnyPublisher<DetailUser, AFError>
    func getFollowerUsers(username: String) -> AnyPublisher<[ListUsers], AFError>
    func getFollowingUsers(username: String) -> AnyPublisher<[ListUsers], AFError>
}
