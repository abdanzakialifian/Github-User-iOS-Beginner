//
//  ViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 11/05/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    @IBOutlet weak var userTableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let viewModel = HomeViewModel()
    
    private var users: [ListUsers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTableView.dataSource = self
        
        self.initTableViewCell()
        
        collectData()
        
        initTextField()
    }
    
    private func collectData() {
        viewModel.$uiState.sink(
            receiveValue: { uiState in
                switch uiState {
                case .loading :
                    self.activityIndicator.isHidden = false
                    self.errorMessageLabel.isHidden = true
                    self.userTableView.isHidden = true
                case .success(let users) :
                    self.activityIndicator.isHidden = true
                    self.errorMessageLabel.isHidden = true
                    self.userTableView.isHidden = false
                    self.users = users
                    DispatchQueue.main.async {
                        self.userTableView.reloadData()
                    }
                case .error(let error) :
                    self.activityIndicator.isHidden = true
                    self.errorMessageLabel.isHidden = false
                    self.userTableView.isHidden = true
                    self.errorMessageLabel.text = error
                }
            }
        )
        .store(in: &cancellables)
        
        viewModel.$queryDebounce
            .removeDuplicates()
            .sink { searchQuery in
                self.viewModel.getListUsers(query: searchQuery)
            }
            .store(in: &cancellables)
    }
    
    private func initTableViewCell() {
        userTableView.register(
            UINib(
                nibName: "UserTableViewCell",
                bundle: nil
            ),
            forCellReuseIdentifier: "UserCell"
        )
    }
    
    private func initTextField() {
        searchTextField.autocorrectionType = UITextAutocorrectionType.no
        searchTextField.layer.cornerRadius = 10
        searchTextField.layer.borderWidth = 0.8
        searchTextField.addTarget(self, action: #selector(textChange), for: .editingChanged)
    }
    
    @objc func textChange(_ textField: UITextField) {
        viewModel.performSearch(query: textField.text ?? "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell {
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

