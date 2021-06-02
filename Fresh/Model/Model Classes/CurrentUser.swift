//
//  CurrentUser.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation

struct FollowSuccessResponse:Decodable{
    let success:String?
}

struct Username:Decodable{
    let username:String
}

struct ListOfUsers:Decodable{
    let followers:Array<Username>?
}

struct FollowErrorResponse:Decodable{
    let following_user:Array<String>?
    let non_field_errors:Array<String>?
}

class CurrentUser:User{
    let accessToken:String
    var followers:Array<User>
    var following:Array<User>
    let request=Request(url:"https://fresh2death.herokuapp.com")
    let validate=Validator()
    var delegate:RegisterUIUpdate?
    init(userId: Int, userName: String,accessToken: String){
        self.accessToken = accessToken
        followers=[]
        following=[]
        super.init(id: userId, username: userName)
    }
    
    func getFollower(){
        request.get(endpoint: "/followers", headers: ["Authorization":self.accessToken,"Content-Type":"application/json","Accept":"application/json"])
    }
    
    func getFollowing(){
        request.get(endpoint: "/following", headers: ["Authorization":self.accessToken,"Content-Type":"application/json","Accept":"application/json"])
    }
    
    func follow(user:User){
        let username:String=user.getUsername()
        request.post(endpoint: "/follow", body: ["following_user":username], headers: ["Authorization":self.accessToken,"Content-Type":"application/json","Accept":"application/json"])
        
    }
    
    func unfollow(user:User){
        let username:String=user.getUsername()
        request.delete(endpoint: "/unfollow", body: ["following_user":username], headers: ["Authorization":self.accessToken,"Content-Type":"application/json","Accept":"application/json"])
    }
    
}


extension CurrentUser:requestProtocol{
    
    //translates the errors from /follow to user readable response
    func translateFollowErrorMessage(error:FollowErrorResponse)->Array<ValidationResult>{
        var result:Array<ValidationResult>=[]
        if((error.non_field_errors) != nil){
            for e in error.non_field_errors!{
                switch e {
                    case "This field must be unique.":
                        result.append(ValidationResult(valid:false,type: "email",error:"Email Belongs To Another Account"))
                        break;
                    default:
                        break;
                }
            }
        }
        if((error.following_user) != nil){
            for e in error.following_user!{
                switch e {
                    case "Cannot follow yourself":
                        result.append(ValidationResult(valid:false,type: "user",error:"This field may not be null."))
                        break;
                    case "This field may not be null.":
                        result.append(ValidationResult(valid:false,type: "user",error:"User Does Not Exist"))
                        break;
                    case "Object with username="+" does not exist.":
                        result.append(ValidationResult(valid:false,type: "user",error:"User Does Not Exist"))
                        break;
                    default:
                        break;
                }
            }
        }
        return result
    }
    
    //handles all possible outcomes from the /follow api
    func addFollowerHandler(status:Int,data:Data,response:URLResponse){
        let decoder = JSONDecoder()
        switch status {
            case 200...299:
                let success: FollowSuccessResponse=try! decoder.decode(FollowSuccessResponse.self, from: data)
                print(success)
            case 400:
                let error: FollowErrorResponse = try! decoder.decode(FollowErrorResponse.self, from: data)
                self.delegate?.informUserErrorOccurred(errors: translateFollowErrorMessage(error: error))
            case 401:
                self.delegate?.informUserErrorOccurred(errors:validate.unauthorizedError())
            break;
            case 402...409:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
            default:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
        }
    }
    
    //handles all possible outcomes from the /unfollow api
    func unfollowHandler(status:Int,data:Data,response:URLResponse){
        let decoder = JSONDecoder()
        switch status {
            case 200...299:
                let success: FollowSuccessResponse=try! decoder.decode(FollowSuccessResponse.self, from: data)
                print(success)
            case 400:
                let error: FollowErrorResponse = try! decoder.decode(FollowErrorResponse.self, from: data)
                self.delegate?.informUserErrorOccurred(errors: translateFollowErrorMessage(error: error))
            case 401:
                self.delegate?.informUserErrorOccurred(errors:validate.unauthorizedError())
                break;
            case 404:
                self.delegate?.informUserErrorOccurred(errors:validate.userDoesNotExist())
            case 402...409:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
            default:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
        }
    }
    
    func getFollowersHandler(status:Int,data:Data,response:URLResponse){
        let decoder = JSONDecoder()
        switch status {
            case 200...299:
                let success: ListOfUsers=try! decoder.decode(ListOfUsers.self, from: data)
                print(success)
            case 400:
                let error: FollowErrorResponse = try! decoder.decode(FollowErrorResponse.self, from: data)
                self.delegate?.informUserErrorOccurred(errors: translateFollowErrorMessage(error: error))
            case 401:
                self.delegate?.informUserErrorOccurred(errors:validate.unauthorizedError())
            break;
            case 404:
                self.delegate?.informUserErrorOccurred(errors:validate.userDoesNotExist())
            case 402...409:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
            default:
                self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
        }
    }
    
    
    func onSuccess(status:Int,data:Data,response:URLResponse,requestMethod:String,endpoint:String){
        if(status==401){
            self.delegate?.informUserErrorOccurred(errors:validate.unauthorizedError())
        }
        //multiple endpoints so use different handlers
        switch endpoint {
            case "/followers":
                getFollowersHandler(status: status, data: data, response: response)
                break;
            case "/following":
                getFollowersHandler(status: status, data: data, response: response)
                break;
            case "/follow":
                addFollowerHandler(status: status, data: data, response: response)
                break;
            case "/unfollow":
                unfollowHandler(status: status, data: data, response: response)
                break;
            default:
                self.delegate?.informUserErrorOccurred(errors: validate.unknownError())
        }
    }
    
    func onError(error:Error){
        self.delegate?.informUserErrorOccurred(errors:validate.unknownError())
    }
}
