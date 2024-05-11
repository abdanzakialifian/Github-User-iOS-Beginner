//
//  ViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.getListUsers()
        
        viewModel.$uiState.sink(
            receiveValue: { uiState in
                switch uiState {
                case .loading :
                    ""
                case .success(let users) :
                    ""
                case .error(let error) :
                    ""
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

