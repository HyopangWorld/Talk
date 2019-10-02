//
//  Chat.swift
//  Talk
//
//  Created by 김효원 on 02/10/2019.
//  Copyright © 2019 HyowonKim. All rights reserved.
//

import ObjectMapper

struct Chat: Mappable {
    var users: Dictionary<String, Bool> = [:] // 채팅에 참여하는 사람
    var comments: Dictionary<String, Comment> = [:] // 채팅 내용
    
    init?(map: Map) {
        users <- map["users"]
        comments <- map["comments"]
    }
    
    mutating func mapping(map: Map) {
    
    }
    
    struct Comment: Mappable {
        var uid: String?
        var message: String?
        
        init?(map: Map) {
            uid <- map["uid"]
            message <- map["message"]
        }
        
        mutating func mapping(map: Map) {
            
        }
        
    }
    
}
