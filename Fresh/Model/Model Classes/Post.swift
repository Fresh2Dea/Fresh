//
//  Post.swift
//  Fresh
//
//  Created by deion bacchus on 5/12/21.
//

import Foundation
class Post{
    let id:Int
    let image:String
    let caption:String
    let user:String
    init(id:Int,user:String,image:String,caption:String){
        self.id=id
        self.user=user
        self.image=image
        self.caption=caption
    }
}
