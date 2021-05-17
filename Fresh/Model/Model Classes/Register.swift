//
//  Register.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation

struct ValidationResult{
    var valid:Bool;
    var error:String;
    var type:String
    init(valid:Bool,type:String,error:String){
        self.valid=valid
        self.type=type
        self.error=error
    }
}

enum ValidationError: Error {
    case EmailError(String)
    case PasswordError(String)
    case UsernameError(String)
    case UnknowError(String)
}

enum RegisterAPIError: Error{
    case WeakPasswordError(String)
    case UniqueUsername(String)
    case EmailExists(String)
    case UnexpectedError(String)
}

struct RegisterErrorResponse:Decodable{
    let email:Array<String>?
}

struct RegisterSuccessResponse:Decodable{
    let success:String?
}

protocol UIUpdate{
    func updateUI(msg:String)
}
class Register{
    let email:String
    let username:String
    let password:String
    let confirmPassword:String
    let request=Request(url:"https://fresh2death.herokuapp.com")
    var delegate:UIUpdate?
    init(email:String,username:String,password:String,confirmPassword:String) {
        self.email=email
        self.username=username
        self.password=password
        self.confirmPassword=confirmPassword
        request.delegate=self
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
    
    func passwordMatches()->ValidationResult{
        let status=self.password==self.confirmPassword
        let error:String = (status == false ? "Passwords Do Not Match" : "")
        return ValidationResult(valid:status,type:"password",error:error)
    }
    
    func isValidUsername(_ username:String)->ValidationResult{
        let status=validateWithRegex(value: username, regex: "^[a-z0-9_.]*$")
        let error:String = (status == false ? "Username Can Only Contain Characters a-z,0-9,_,." : "")
        return ValidationResult(valid:status,type:"username",error:error)
    }
    
    func validate() throws {
        let results:Array<ValidationResult>=[isValidEmail(self.email),isValidUsername(self.username),passwordMatches()]
        for result in results{
            if(result.valid==false){
                switch result.type{
                    case "email":
                        throw ValidationError.EmailError(result.error)
                    case "username":
                        throw ValidationError.UsernameError(result.error)
                    case "password":
                        throw ValidationError.PasswordError(result.error)
                    default:
                        throw ValidationError.UnknowError("Unkown Error Occurred")
                }
            }
        }
    }
    
    func create() throws{
        do{
            try validate()
            try request.post(endpoint: "/register", body: ["email" : self.email,"username": self.username,"password":self.password], headers: ["Content-Type":"application/json","Accept":"application/json"])
        }catch {
            
        }
    }
}

extension Register:requestProtocol{
    func onSuccess(status:Int,data:Data,response:URLResponse){
        //successfully received a response from the server
        //handle the response
        let decoder = JSONDecoder()
        switch status {
            case 200...299:
                print("Register Successful")
                let success: RegisterSuccessResponse=try! decoder.decode(RegisterSuccessResponse.self, from: data)
                print(success)
            case 400...499:
                print("Register Error")
                let error: RegisterErrorResponse = try! decoder.decode(RegisterErrorResponse.self, from: data)
                self.delegate?.updateUI(msg: "someError")
                print(error)
            default:
                print("Server Down")
        }
    }
    func onError(error:Error){
        print("Error Happened")
    }
}
