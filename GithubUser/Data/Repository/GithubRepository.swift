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
}
