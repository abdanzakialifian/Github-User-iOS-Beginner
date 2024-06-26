//
//  EndPoint.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation

class EndPoint {
    // MARK : Singleton
    static let shared = EndPoint()
    
    let searchUsers = "search/users"
    let detailUser = "users/{username}"
    let followersUser = "users/{username}/followers"
    let followingUser = "users/{username}/following"
}
