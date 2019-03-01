//
//  Models.swift
//  ACC
//
//  Created by Leonardo Araque on 1/27/19.
//  Copyright © 2019 Leonardo Araque. All rights reserved.
//

import Foundation
class Models: NSObject, Codable{
    class LoginInput: NSObject, Codable{
        var email: String
        var password: String

        init(email: String, password: String){
            self.email = email
            self.password = password
        }
    }
    
    class LoginOutput: NSObject, Codable{
        var token: String
        var email: String
        var username: String
    }
    
    class session: NSObject, Codable{
        var id: Int
        var title: String
        var session_type: String
        var owner_id: Int
        var owner_username: String
        var owner_email: String
    }
    
    class webSocketRetro: NSObject, Codable{
        var item_type: String
        var item_text: String
        
        init(type: String, text: String){
            self.item_text = text
            self.item_type = type
        }
    }
    
    
}
