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
    
    @Published private var query: String = ""
    
    @Published var uiState: UiState = UiState.success([ListUsers]())
    
    @Published var queryDebounce: String = ""
    
    func performSearch(query: String) {
        self.query = query
        
        $query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .assign(to: \.queryDebounce, on: self)
            .store(in: &cancellables)
    }
    
    func getListUsers(query: String) {
        self.uiState = .loading
        
        GithubRepositoryImpl.shared.getListUsers(query: query)
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
