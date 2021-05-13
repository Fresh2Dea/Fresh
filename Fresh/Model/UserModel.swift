//
//  UserModel.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation
public class User{
    let id:Int
    let username:String
    let posts:Array<Post>
    
    init(id:Int ,username:String , posts:Array<Post>) {
        self.id = id
        self.username = username
        self.posts = posts
    }
    
    func getUsername()->String{
        return self.username
    }
    
    func getId()->Int{
        return self.id
    }
    
    func getPosts()->Array<Post>{
        return self.posts
    }
    
}
