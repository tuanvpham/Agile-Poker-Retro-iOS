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
        var oauth_token: String
        var oauth_token_secret: String
        var oauth_url: String
        var message: String
    }
    
    class jiraAuthOutput: NSObject, Codable{
        var message: String
        var token: String
        var email: String
        var username: String
        var access_token: String
        var secret_access_token: String
    }
    
    class jiraAuthInput: NSObject, Codable{
        var oauth_token: String
        var oauth_token_secret: String
        
        init(token: String, secret: String){
            self.oauth_token = token
            self.oauth_token_secret = secret
        }
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
