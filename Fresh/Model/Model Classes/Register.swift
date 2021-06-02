//
//  Register.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation

//the object structure for an 400 error
struct RegisterErrorResponse:Decodable{
    let email:Array<String>?
    let username:Array<String>?
    let password:Array<String>?
}


//the object structure of a successful repsonse
struct RegisterSuccessResponse:Decodable{
    let success:String?
}

//registerviewcontroller delegates
protocol RegisterUIUpdate{
    func successfullyRegistered(msg:String)
    func informUserErrorOccurred(errors:Array<ValidationResult>)
}

class Register{
    let email:String
    let username:String
    let password:String
    let confirmPassword:String
    let request=Request(url:"https://fresh2death.herokuapp.com")
    let validate=Validator()
    var delegate:RegisterUIUpdate?
    init(email:String,username:String,password:String,confirmPassword:String) {
        self.email=email
        self.username=username
        self.password=password
        self.confirmPassword=confirmPassword
        request.delegate=self
    }
    
    //validates all the fields required to register
    func validateForm()->Bool {
        //array of validation function calls
        let results:Array<ValidationResult>=[self.validate.isValidEmail(self.email),self.validate.isValidUsername(self.username),self.validate.passwordMatches(password: self.password, confirmPassword: self.confirmPassword)]
            for result in results{
                if(result.valid==false){
                   return false
                }
            }
            return true
    }
    
    //translates api response to a response the user can more easily understand
    func translateErrorMessage(error:RegisterErrorResponse)->Array<ValidationResult>{
        var result:Array<ValidationResult>=[]
        if((error.email) != nil){
            for e in error.email!{
                switch e {
                case "This field must be unique.":
                    result.append(ValidationResult(valid:false,type: "email",error:"Email Belongs To Another Account"))
                    break;
                default:
                    break;
                }
            }
        }
        if((error.username) != nil){
            for e in error.username!{
                switch e {
                case "This field must be unique.":
                    result.append(ValidationResult(valid:false,type: "username",error:"Username Already Taken"))
                    break;
                default:
                    break;
                }
            }
        }
        if((error.password) != nil){
            for e in error.password!{
                switch e {
                case "This password is too common.":
                    result.append(ValidationResult(valid:false,type: "password",error:"Password Is Too Weak"))
                    break;
                default:
                    break;
                }
            }
        }
        return result
    }
    
    // validate the data and make an api request to register user
    func create(){
            request.post(endpoint: "/register", body: ["email" : self.email,"username": self.username,"password":self.password], headers: ["Content-Type":"application/json","Accept":"application/json"])
    }
}

extension Register:requestProtocol{
    func onSuccess(status:Int,data:Data,response:URLResponse,requestMethod:String,endpoint:String){
        //successfully received a response from the server
        //handle the response
        let decoder = JSONDecoder()
        switch status {
            case 200...299:
                self.delegate?.successfullyRegistered(msg: "Successfully Created Account")
            case 400:
                let error: RegisterErrorResponse = try! decoder.decode(RegisterErrorResponse.self, from: data)
                self.delegate?.informUserErrorOccurred(errors: translateErrorMessage(error: error))
                print(error)
            case 402...409:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
            default:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
        }
    }
    func onError(error:Error){
        self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
    }
}
