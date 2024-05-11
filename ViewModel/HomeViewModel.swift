//
//  HomeViewModel.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import Foundation
import Combine
import Alamofire

class HomeViewModel : ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var uiState: UiState = UiState.success([ListUsers]())
    
    func getListUsers() {
        self.uiState = .loading
        
        GithubRepositoryImpl.shared.getListUsers()
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        self.uiState = .error(error.localizedDescription)
                    }
                },
                receiveValue: { users in
                    self.uiState = .success(users)
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
