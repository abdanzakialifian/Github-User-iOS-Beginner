//
//  UiState.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation

enum UiState<T> {
    case loading
    case success(T)
    case error(String)
}
