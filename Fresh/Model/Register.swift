//
//  Register.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation

struct ValidationResult{
    var status:Bool;
    var error:String;
    
    init(status:Bool,error:String){
        self.status=status
        self.error=error
    }
}

enum ValidationError: Error {
    case runtimeError(String)
}

class Register{
    var email:String
    var username:String
    var password:String
    var confirmPassword:String
    init(email:String,username:String,password:String,confirmPassword:String) {
        self.email=email
        self.username=username
        self.password=password
        self.confirmPassword=confirmPassword
    }
    
    func validateWithRegex(value:String,regex:String)->Bool{
        let valuePred = NSPredicate(format:"SELF MATCHES %@", regex)
        return valuePred.evaluate(with: value)
    }
    
    func isValidEmail(_ email: String) -> ValidationResult {
        let status=validateWithRegex(value: email, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        let error:String = (status == false ? "Enter A Valid Email" : "")
        return ValidationResult(status:status,error:error)
    }
    
    func passwordMatches()->ValidationResult{
        let status=self.password==self.confirmPassword
        let error:String = (status == false ? "Passwords Do Not Match" : "")
        return ValidationResult(status:status,error:error)
    }
    
    func isValidUsername(_ username:String)->ValidationResult{
        let status=validateWithRegex(value: username, regex: "^[a-z0-9_.]*$")
        let error:String = (status == false ? "Username Can Only Contain Characters a-z,0-9,_,." : "")
        return ValidationResult(status:status,error:error)
    }
    
    func validate() throws {
        let results:Array<ValidationResult>=[isValidEmail(self.email),isValidUsername(self.username),passwordMatches()]
        for result in results{
            if(result.status==false){
                throw ValidationError.runtimeError(result.error)
            }
        }
    }
    
    func create() throws{
        try validate()
        
    }
}
