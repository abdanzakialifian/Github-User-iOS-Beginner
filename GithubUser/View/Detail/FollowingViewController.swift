//
//  FollowingViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 19/05/24.
//

import UIKit
import Combine

class FollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var followingTableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = DetailViewModel()
    
    private var users: [ListUsers] = []
    
    var userName: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.followingTableView.dataSource = self
        self.followingTableView.delegate = self
        
        self.initTableViewCell()
        
        viewModel.getFollowingUsers(username: userName ?? "")
        
        collectData()
    }
    
    private func collectData() {
        viewModel.$uiStateFollowing.sink(
            receiveValue: { uiState in
                switch uiState {
                case .loading :
                    self.activityIndicator.isHidden = false
                    self.errorMessageLabel.isHidden = true
                    self.followingTableView.isHidden = true
                case .success(let users) :
                    self.activityIndicator.isHidden = true
                    self.errorMessageLabel.isHidden = true
                    self.followingTableView.isHidden = false
                    self.users = users
                    DispatchQueue.main.async {
                        self.followingTableView.reloadData()
                    }
                case .error(let error) :
                    self.activityIndicator.isHidden = true
                    self.errorMessageLabel.isHidden = false
                    self.followingTableView.isHidden = true
                    self.errorMessageLabel.text = error
                }
            }
        )
        .store(in: &cancellables)
    }
    
    private func initTableViewCell() {
        followingTableView.register(
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
