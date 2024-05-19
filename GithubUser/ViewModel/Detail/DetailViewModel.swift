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
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
    }
}
