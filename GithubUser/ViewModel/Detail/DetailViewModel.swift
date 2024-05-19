//
//  Det.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 19/05/24.
//

import Foundation
import Combine

class DetailViewModel : ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var uiState: UiState<DetailUser> = UiState.loading
    
    @Published var uiStateFollowers: UiState<[ListUsers]> = UiState.loading
    
    @Published var uiStateFollowing: UiState<[ListUsers]> = UiState.loading
    
    func getDetailUser(username: String) {
        self.uiState = .loading
        
        GithubRepositoryImpl.shared.getDetailUser(username: username)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.uiState = .error(error.localizedDescription)
                    }
                    
                },
                receiveValue: { detailUser in
                    self.uiState = .success(detailUser)
                    
                }
            )
            .store(in: &cancellables)
        
        getFollowerUsers(username: username)
        
        getFollowingUsers(username: username)
    }
    
    private func getFollowerUsers(username: String) {
        self.uiStateFollowers = .loading
        
        GithubRepositoryImpl.shared.getFollowerUsers(username: username)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.uiStateFollowers = .error(error.localizedDescription)
                    }
                },
                receiveValue: { users in
                    self.uiStateFollowers = .success(users)
                }
            )
            .store(in: &cancellables)
    }
    
    private func getFollowingUsers(username: String) {
        self.uiStateFollowing = .loading
        
        GithubRepositoryImpl.shared.getFollowingUsers(username: username)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.uiStateFollowing = .error(error.localizedDescription)
                    }
                },
                receiveValue: { users in
                    self.uiStateFollowing = .success(users)
                }
            )
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
    }
}
