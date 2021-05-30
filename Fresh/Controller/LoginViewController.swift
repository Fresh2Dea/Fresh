//
//  ViewController.swift
//  Fresh
//
//  Created by Richard Basdeo on 5/10/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailHelperLabel: UILabel!
    let validator=Validator()
    @IBAction func emailTextFieldAction(_ sender: UITextField) {
        let valid=validator.isValidEmail(sender.text ?? "")
        if(valid.valid==false){
            emailHelperLabel.text="Please Check That Your Email Is Correct"
        }else{
            emailHelperLabel.text=""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailHelperLabel.font = emailHelperLabel.font.withSize(14)
        let emailField=FormField(textField: emailTextField)
        let passwordField=FormField(textField: passwordTextField)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let auth=Login()
        auth.delegate=self
        do{
            try auth.authenticate(email:"sandiraramdat127@gmail.com",password: "howAboutNow18!")
        }catch ValidationError.EmailError(let errorMessage){
            //display error message to user
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
