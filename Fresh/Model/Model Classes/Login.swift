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
    
    func validate(email:String,password:String)->Bool{
        let results:Array<ValidationResult>=[self.validate.isValidEmail(email),self.validate.isValidPassword(password: password)]
        for result in results{
            if(result.valid==false){
               return false
            }
        }
        return true
    }
    
    func authenticate(email:String,password:String) throws{
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
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
        }
    }
    func onError(error:Error){
        self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
    }
}
