//
//  databridge.swift
//  TableView
//
//  Created by Khutjo MAPUTLA on 2019/10/24.
//  Copyright © 2019 Khutjo MAPUTLA. All rights reserved.
//

import Foundation

class Dataridge{
    
    static let myobj =  Dataridge()
    var token: String
    var tokenset: Bool
    var profiledat: Any?
    var profileset: Bool
    
    
    init(){
        self.token = ""
        self.tokenset = false
        self.profiledat = 0
        self.profileset = false
    }
    
    func settoken(token: String){
        self.token = token
        self.tokenset = true
        
        print(self.token)
    }
    
    func setProfiledat(profiledat: Any){
        self.profiledat = profiledat
        self.profileset = true
        
        print(self.token)
    }
    
    func getIsTokenSet() -> Bool{
        return tokenset
    }
    
    func getisProfileset() -> Bool{
        return profileset
    }
    
    func getProfiledat() -> Any{
        return profiledat as Any
    }
    
    func getToken() -> String{
        return token
    }
    
}

