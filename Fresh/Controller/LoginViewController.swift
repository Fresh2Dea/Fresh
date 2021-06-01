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
    @IBOutlet weak var passwordHelperLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    let validator=Validator()
    let auth=Login()
    
    var email:String="";
    var password:String="";
    
    //keeping track of if the button enabled or disabled
    var buttonEnabled:Bool=false;

    
    func enableButton(){
        signInButton.isEnabled=true
        signInButton.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        buttonEnabled=true
    }
    
    func disableButton(){
        signInButton.isEnabled=false
        signInButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        buttonEnabled=false
    }
    
    //checks if both fields are valid, if valid enable the auth button
    func checkFormComplete(){
        let result=auth.validate(email: self.email, password: self.password)
        if(result==true){
            enableButton()
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        attemptLogin()
    }

    @IBAction func emailBeingTyped(_ sender: UITextField) {
        let valid=validator.isValidEmail(sender.text ?? "")
        self.email=sender.text ?? ""
        if(valid.valid==false){
            emailHelperLabel.text="Please Check That Your Email Is Correct"
            if(buttonEnabled){
                disableButton()
            }
        }else{
            //remove helper text,assign current string to email and check if form complete
            emailHelperLabel.text=""
            checkFormComplete()
        }
    }

    @IBAction func passwordBeingTyped(_ sender: UITextField) {
        let valid=validator.isValidPassword(password:sender.text ?? "")
        self.password=sender.text ?? ""
        if(valid.valid==false){
            passwordHelperLabel.text="Minimum Of 6 Characters"
            if(buttonEnabled){
                disableButton()
            }
        }else{
            //remove helper text,assign current string to password and check if form complete
            passwordHelperLabel.text=""
            checkFormComplete()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth.delegate=self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailHelperLabel.font = emailHelperLabel.font.withSize(14)
        passwordHelperLabel.font = passwordHelperLabel.font.withSize(14)
        passwordTextField.isSecureTextEntry = true
        signInButton.layer.cornerRadius = 3
        disableButton()
        let toast=Toast()
        toast.showToast(message: "Invalid Email/Password Combination", view: self)
        FormField(textField: emailTextField)
        FormField(textField: passwordTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func attemptLogin(){
        do{
            disableButton()
            try auth.authenticate(email:email,password: password)
        }catch{
            let toast=Toast()
            toast.showToast(message: "Unexpected Error", view: self)
        }
    }
}

extension LoginViewController:LoginUIUpdate{
    
    func successfullyAuthenticated(userCredentials: LoginSuccessResponse){
        //create a user object and pass it to the feedviewcontroller
        print(userCredentials)
    }
    
    func informUserErrorOccurred(errors:Array<ValidationResult>){
        // display a toast informing the user of what error occurred
        DispatchQueue.main.async {
            self.enableButton()
            for error in errors{
                let toast=Toast()
                //check the validator class to see all the different types of errors
                switch error.type{
                    case "authorization":
                        toast.showToast(message: "Invalid Email/Password Combination", view: self)
                    default:
                        toast.showToast(message: "Unknown Error Occured,Try Again", view: self)
                }
            }
        }
    }
}
