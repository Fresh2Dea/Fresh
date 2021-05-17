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
        networking.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let register=Register(email: "sandiraramdat127@gmail.com",username: "richard", password: "howAboutNow17!",confirmPassword:"howAboutNow17!")
        do{
            try register.create()
        }catch{
            print(error)
        }
        //networking.attemptLogin(email: "sandiraramdat127@gmail.com", Password: "howAboutNow17!")
    }


}

extension LoginViewController: networkingProtocol {
    func registerSuccess() {
        print("Register Success")
    }
    
    func registerSuccess2() {
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

extension LoginViewController:UIUpdate{
    func updateUI(msg: String){
        print(msg)
    }
}
