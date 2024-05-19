//
//  FollowersViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 19/05/24.
//

import UIKit
import Combine

class FollowersViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = DetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectData()
    }
    
    private func collectData() {
        viewModel.$uiStateFollowers.sink(
            receiveValue: { uiState in
                switch uiState {
                case .loading :
                    ""
                case .success(let users) :
                    debugPrint("CEK \(users)")
                case .error(let error) :
                    debugPrint("CEK \(error)")
                }
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
