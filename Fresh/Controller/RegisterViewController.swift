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
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        renterTextField.delegate = self
        
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
        if (textField == emailTextField){
            let valid = validator.isValidEmail(emailTextField.text ?? "")
            if (valid.valid == false){
                emailValidator.text = "Please Check That Your Email Is Correct"
            }
            else {
                emailValidator.text = ""
            }
        }
    }
}
