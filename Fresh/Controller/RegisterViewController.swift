//
//  RegisterViewController.swift
//  Fresh
//
//  Created by deion bacchus on 5/28/21.
//

import UIKit

class RegisterViewController:UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let register=Register(email: "sandiraramdat127@gmail.com",username: "richard", password: "howAboutNow17!",confirmPassword:"howAboutNow17!")
        register.delegate=self
        do{
            try register.create()
        }catch ValidationError.EmailError(let errorMessage){
            print(errorMessage)
        }catch ValidationError.PasswordError(let errorMessage){
            print(errorMessage)
        }catch ValidationError.UsernameError(let errorMessage){
            print(errorMessage)
        }catch{
        }
    }

}

extension RegisterViewController:RegisterUIUpdate{
    func successfullyRegistered(msg: String){
        print(msg)
    }
    func informUserErrorOccurred(errors:Array<ValidationResult>){
        DispatchQueue.main.async {
            
        }
    }
}
