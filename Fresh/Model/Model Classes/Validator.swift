//
//  Validator.swift
//  Fresh
//
//  Created by deion bacchus on 5/27/21.
//

import Foundation

struct ValidationResult{
    var valid:Bool;
    var error:String;
    var type:String
    init(valid:Bool,type:String,error:String){
        self.valid=valid // describes if field is valid
        self.type=type //which field has the error
        self.error=error //safe error message that can be displayed to users
    }
}

//client side errors for validating register data
enum ValidationError: Error {
    case EmailError(String)
    case PasswordError(String)
    case UsernameError(String)
    case UnknowError(String)
}

class Validator{
    init(){
        
    }
    
    func validateWithRegex(value:String,regex:String)->Bool{
        let valuePred = NSPredicate(format:"SELF MATCHES %@", regex)
        return valuePred.evaluate(with: value)
    }
    
    func isValidEmail(_ email: String) -> ValidationResult {
        let status=validateWithRegex(value: email, regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        let error:String = (status == false ? "Enter A Valid Email" : "")
        return ValidationResult(valid:status,type:"email",error:error)
    }
    
    func passwordMatches(password:String,confirmPassword:String)->ValidationResult{
        let status=password==confirmPassword
        let error:String = (status == false ? "Passwords Do Not Match" : "")
        return ValidationResult(valid:status,type:"password",error:error)
    }
    
    func passwordValid(password:String)->ValidationResult{
        var valid=false
        if(password.count>=6 && password.count<=100){
            valid=true
        }
        let error:String = (valid == false ? "Password Is Not Valid" : "")
        return ValidationResult(valid:valid,type:"password",error:error)
    }
    
    func isValidUsername(_ username:String)->ValidationResult{
        let status=validateWithRegex(value: username, regex: "^[a-z0-9_.]*$")
        let error:String = (status == false ? "Username Can Only Contain Characters a-z,0-9,_,." : "")
        return ValidationResult(valid:status,type:"username",error:error)
    }
    
    func unauthorizedError()->Array<ValidationResult>{
        return [ValidationResult(valid: false, type: "authorization", error: "Unauthorized, Please Login")]
    }
    
    func userDoesNotExist()->Array<ValidationResult>{
        return [ValidationResult(valid: false, type: "nonexistentuser", error: "User Not Found")]
    }
    
    func unknownError()->Array<ValidationResult>{
        return [ValidationResult(valid: false, type: "unknown", error: "Unknown Error Occurred")]
    }
    
}
