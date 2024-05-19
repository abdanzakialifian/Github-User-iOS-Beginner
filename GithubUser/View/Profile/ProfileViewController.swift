//
//  ProfileViewController.swift
//  GithubUser
//
//  Created by Abdan Zaki Alifian on 19/05/24.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageView.layer.cornerRadius = 8
    }
}
