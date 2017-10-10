//
//  SurveyDetailAPI.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation

final class SurveyDetailAPI {
    
    fileprivate let PAGE_KEY = "page"
    fileprivate let PERPAGE_KEY = "per_page"
    fileprivate let TOKEN_KEY = "access_token"
    
    fileprivate var page = 1
    fileprivate var perPage = 10
    fileprivate let token = GlobalVariables.Session.authToken
    
    fileprivate let method:MethodType = MethodType.get
    fileprivate var baseURL = URLEnum.surveyDetailUrl
    
    init(page:Int, perPage:Int) {
        self.page = page
        self.perPage = perPage
    }
    
    func getUrl()->String{
        return baseURL
    }
    
    func getMethod()->MethodType {
        return method
    }
    
    func buildAPIParameter()throws ->[String:Any]?{
        
        if checkNilforString(token) {
            
            var params = [String:Any]()
            
            params[self.TOKEN_KEY] = self.token
            params[self.PAGE_KEY] = self.page
            params[self.PERPAGE_KEY] = self.perPage
            
            return params
        }
        throw GenericErrors.insufficientParameters
    }
}
