//
//  RegisterViewController.swift
//  Fresh
//
//  Created by deion bacchus on 5/28/21.
//

import UIKit

class RegisterViewController:UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var renterTextField: UITextField!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var emailValidator: UILabel!
    @IBOutlet weak var usernameValidator: UILabel!
    @IBOutlet weak var passwordValidator: UILabel!
    @IBOutlet weak var renterValidator: UILabel!
    
    
    let validator = Validator()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Styling.customButton(for: signUpButtonOutlet)
        
        emailValidator.font = emailValidator.font.withSize(14)
        usernameValidator.font = usernameValidator.font.withSize(14)
        passwordValidator.font = passwordValidator.font.withSize(14)
        renterValidator.font = renterValidator.font.withSize(14)
        
        Styling.textFieldStyle(textField: emailTextField)
        emailTextField.delegate = self
        
        Styling.textFieldStyle(textField: usernameTextField)
        usernameTextField.delegate = self
        
        Styling.textFieldStyle(textField: passwordTextField)
        passwordTextField.delegate = self
        
        Styling.textFieldStyle(textField: renterTextField)
        renterTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        let register = Register(email: "sandiraramdat127@gmail.com",
                                username: "richard",
                                password: "howAboutNow17!",
                                confirmPassword:"howAboutNow17!")
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

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        switch textField {
        case emailTextField:
            let valid = validator.isValidEmail(emailTextField.text ?? "")
            if valid.valid == false {
                emailValidator.text = "Please Check That Your Email Is Correct"
            }
            else {
                emailValidator.text = ""
            }
        case passwordTextField:
            let valid = validator.isValidPassword(password: passwordTextField.text ?? "")
            if valid.valid == false {
                passwordValidator.text = "Minimum Of 6 Characters"
            }
            else {
                passwordValidator.text = ""
            }
        case usernameTextField:
            let valid = validator.isValidUsername(usernameTextField.text ?? "")
            if valid.valid == false {
                usernameValidator.text = "Can't Use this username."
            }
            else {
                usernameValidator.text = ""
            }
        default:
            let validate = validator.passwordMatches(password: passwordTextField.text ?? ""
                                                     , confirmPassword: renterTextField.text ?? "")
            if validate.valid == false {
                renterValidator.text = "Passwords don't match."
            }
            else{
                renterValidator.text = ""
            }
        }
    }
}
