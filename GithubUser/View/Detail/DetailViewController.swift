//
//  DetailViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 19/05/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userFollowersLabel: UILabel!
    
    @IBOutlet weak var userFollowingLabel: UILabel!
    
    @IBOutlet weak var userRepositoriesLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = DetailViewModel()
    
    var userName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getDetailUser(username: userName ?? "")
        
        collectData()
    }
    
    private func collectData() {
        viewModel.$uiState.sink(
            receiveValue: { uiState in
                switch uiState {
                case .loading:
                    self.activityIndicator.isHidden = false
                case .success(let detailUser):
                    self.activityIndicator.isHidden = true
                    self.userImageView.downloaded(from: detailUser.avatarURL ?? "")
                    self.userFollowersLabel.text = String(detailUser.followers ?? 0)
                    self.userFollowingLabel.text = String(detailUser.following ?? 0)
                    self.userRepositoriesLabel.text = String(detailUser.publicRepos ?? 0)
                    self.userNameLabel.text = detailUser.login
                    self.nameLabel.text = detailUser.name
                    self.userImageView.layer.cornerRadius = 6
                case .error(let error):
                    self.activityIndicator.isHidden = true
                }
            }
        ).store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
    }
}
