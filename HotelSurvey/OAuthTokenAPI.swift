//
//  OAuthTokenAPI.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation

final class OAuthTokenAPI {
    
    fileprivate let GRANT_KEY = "grant_type"
    fileprivate let USERNAME_KEY = "username"
    fileprivate let PASSWORD_KEY = "password"
    
    fileprivate let grantType:String = "password"
    fileprivate var username:String = ""
    fileprivate var password:String = ""
    
    fileprivate let method:MethodType = MethodType.post
    fileprivate var baseURL = URLEnum.oAuthUrl
    
    init(username:String, password:String) {
        self.password = password
        self.username = username
    }
    
    func getUrl()->String{
        return baseURL
    }
    
    func getMethod()->MethodType {
        return method
    }
    
    func buildAPIParameter()throws ->[String:Any]?{
        
        if checkNilforString(username) {
            
            var params = [String:Any]()
            
            params[self.GRANT_KEY] = self.grantType
            params[self.USERNAME_KEY] = self.username
            params[self.PASSWORD_KEY] = self.password
            
            return params
        }
        throw GenericErrors.insufficientParameters
    }
}
