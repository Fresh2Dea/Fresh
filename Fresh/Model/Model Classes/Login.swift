//
//  Login.swift
//  Fresh
//
//  Created by deion bacchus on 5/27/21.
//

import Foundation

struct LoginSuccessResponse:Decodable{
    let id:Int?
    let token:String?
    let username:String?
}

struct LoginErrorResponse:Decodable{
    let error:String?
}

protocol LoginUIUpdate{
    func successfullyAuthenticated(userCredentials:LoginSuccessResponse)
    func informUserErrorOccurred(errors:Array<ValidationResult>)
}

class Login{
    let request=Request(url:"https://fresh2death.herokuapp.com")
    let validate=Validator()
    var delegate:LoginUIUpdate?
    init(){
        request.delegate=self
    }
    
    func validate(email:String,password:String)throws{
        let results:Array<ValidationResult>=[self.validate.isValidEmail(email),self.validate.passwordValid(password: password)]
        for result in results{
            if(result.valid==false){
                switch result.type{
                    case "email":
                        throw ValidationError.EmailError(result.error)
                    case "password":
                        throw ValidationError.PasswordError(result.error)
                    default:
                        throw ValidationError.UnknowError("Unkown Error Occurred")
                }
            }
        }
    }
    
    func authenticate(email:String,password:String) throws{
            try self.validate(email: email, password: password)
            request.post(endpoint: "/login", body: ["email" : email,"password":password], headers: ["Content-Type":"application/json","Accept":"application/json"])
        
    }
}

extension Login:requestProtocol{
    func onSuccess(status:Int,data:Data,response:URLResponse,requestMethod:String,endpoint:String){
        //successfully received a response from the server
        //handle the response
        let decoder = JSONDecoder()
        switch status {
            case 200...299:
                let responseBody: LoginSuccessResponse=try! decoder.decode(LoginSuccessResponse.self, from: data)
                self.delegate?.successfullyAuthenticated(userCredentials: responseBody)
            case 401:
                self.delegate?.informUserErrorOccurred(errors:validate.unauthorizedError())
            default:
                print("Server Down")
        }
    }
    func onError(error:Error){
        print("Error Happened")
    }
}
