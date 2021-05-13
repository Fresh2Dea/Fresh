//
//  ViewController.swift
//  Fresh
//
//  Created by Richard Basdeo on 5/10/21.
//

import UIKit

class LoginViewController: UIViewController {

    let networking = Networking()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        networking.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        networking.attemptLogin(email: "sandiraramdat127@gmail.com", Password: "howAboutNow17!")
    }


}

extension LoginViewController: networkingProtocol {
    func registerSuccess() {
        print("Register Success")
    }
    
    func error(message: String) {
        print(message)
    }
    
    func loginSuccess(user: CurrentUser) {
        print(user.accessToken)
        print(user.username)
        print(user.id)
    }
    

}

