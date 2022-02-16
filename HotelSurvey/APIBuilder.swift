//
//  APIBuilder.swift
//  HotelSurvey
//
//  Created by Lokesh on 10/10/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import Foundation

class APIBuilder {
    
    static func buildSurveyDetailAPI(page:Int, perPage:Int) -> (SurveyDetailAPI, [String:Any]?) {
        let apiObject = SurveyDetailAPI(page:page, perPage:perPage)
        
        var params: [String:Any]? {
            do {
                let temp = try apiObject.buildAPIParameter()
                return temp!
            } catch {
                print("Error building Survey Detail Params")
                return nil
            }
        }
        return (apiObject, params)
    }
    
    static func buildOAuthAPI(username:String, password:String) -> (OAuthTokenAPI, [String:Any]?) {
        let apiObject = OAuthTokenAPI(username:username, password:password)
        
        var params: [String:Any]? {
            do {
                let temp = try apiObject.buildAPIParameter()
                return temp!
            } catch {
                print("Error building OAuth Params")
                return nil
            }
        }
        return (apiObject, params)
    }
}
