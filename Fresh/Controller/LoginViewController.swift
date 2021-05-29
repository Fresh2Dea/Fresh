//
//  ViewController.swift
//  Fresh
//
//  Created by Richard Basdeo on 5/10/21.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let auth=Login()
        auth.delegate=self
        do{
            try auth.authenticate(email:"sandiraramdat127@gmail.com",password: "howAboutNow18!")
        }catch ValidationError.EmailError(let errorMessage){
            print(errorMessage)
        }catch ValidationError.PasswordError(let errorMessage){
            print(errorMessage)
        }catch{
            
        }
    }
}

extension LoginViewController:LoginUIUpdate{
    
    func successfullyAuthenticated(userCredentials: LoginSuccessResponse){
        
    }
    func informUserErrorOccurred(errors:Array<ValidationResult>){
        DispatchQueue.main.async {
            
        }
    }
}
