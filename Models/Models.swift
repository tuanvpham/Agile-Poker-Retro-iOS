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
    
    
    
    
    
}
