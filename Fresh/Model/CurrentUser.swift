//
//  CurrentUser.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation
class CurrentUser:User{
    let accessToken:String
    var followers:Array<User>
    var following:Array<User>
    
    
    init(userId: Int, userName: String, Posts: [Post], accessToken: String, followers: [User], following: [User]){
        self.accessToken = accessToken
        self.followers = followers
        self.following = following
        super.init(id: userId, username: userName, posts: Posts)
        
    }
    
    func login(email:String,password:String){
        
    }
    
    func getFollower(){
        
    }
    
    func getFollowing(){
        
    }
    
    func follow(user:User){
        let username:String=user.getUsername()
        
    }
    
    func unfollow(user:User){
        let username:String=user.getUsername()
    }
    
}
