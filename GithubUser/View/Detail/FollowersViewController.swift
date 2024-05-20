//
//  FollowersViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 19/05/24.
//

import UIKit
import Combine

class FollowersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var followersTableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = DetailViewModel()
    
    private var users: [ListUsers] = []
    
    var userName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.followersTableView.dataSource = self
        self.followersTableView.delegate = self
        
        self.initTableViewCell()
        
        viewModel.getFollowerUsers(username: userName ?? "")
        
        collectData()
    }
    
    private func collectData() {
        viewModel.$uiStateFollowers.sink(
            receiveValue: { uiState in
                switch uiState {
                case .loading :
                    self.activityIndicator.isHidden = false
                    self.errorMessageLabel.isHidden = true
                    self.followersTableView.isHidden = true
                case .success(let users) :
                    self.activityIndicator.isHidden = true
                    self.errorMessageLabel.isHidden = true
                    self.followersTableView.isHidden = false
                    self.users = users
                    DispatchQueue.main.async {
                        self.followersTableView.reloadData()
                    }
                case .error(let error) :
                    self.activityIndicator.isHidden = true
                    self.errorMessageLabel.isHidden = false
                    self.followersTableView.isHidden = true
                    self.errorMessageLabel.text = error
                }
            }
        )
        .store(in: &cancellables)
    }
    
    private func initTableViewCell() {
        followersTableView.register(
            UINib(
                nibName: Constant.shared.followersTableViewCell,
                bundle: nil
            ),
            forCellReuseIdentifier: Constant.shared.followersCellId
        )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.shared.followersCellId, for: indexPath) as? FollowersTableViewCell {
            let user = self.users[indexPath.row]
            cell.userImageView.downloaded(from: user.avatarURL ?? "")
            cell.usernameLabel.text = user.login
            cell.userImageView.layer.cornerRadius = 8
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    deinit {
        cancellables.forEach {
            $0.cancel()
        }
    }
}
