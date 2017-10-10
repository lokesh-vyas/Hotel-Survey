//
//  HomeInteractor.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

protocol SurveyDetailProtocol {
    func didGetSurveyDetailData(success:Bool, surveyData:[HotelSurvey], error:String?)
    func didGetAuthToken(success:Bool, error:String?)
}

class HomeInteractor {
    
    
    fileprivate let networkWrapper = NetworkWrapper.sharedInstance
    var surveyDetailDelegate:SurveyDetailProtocol?
    
    
    
    func getSurveyDetailData(page:Int, perPage:Int) {
        
        networkWrapper.getSurveyDetailData(page: page, perPage: perPage, onSuccess: { (dict) in
            
            if let json = JSON(dict).arrayObject {
                print(json)
                if let survey = Mapper<HotelSurvey>().mapArray(JSONObject: json) , survey.count > 0 {
                    self.surveyDetailDelegate?.didGetSurveyDetailData(success: true, surveyData: survey, error: nil)
                    return
                }
            }
            self.surveyDetailDelegate?.didGetSurveyDetailData(success: false, surveyData: [], error: GlobalVariables.networkError)
            
        }) { (error) in
            self.surveyDetailDelegate?.didGetSurveyDetailData(success: false, surveyData: [], error: error)
        }
    }
    
    func getOAuthData(username:String, password:String) {
        
        networkWrapper.getOAuthData(username: username, password: password, onSuccess: { (dict) in
            
            let json = JSON(dict)
            
            if let authToken = json["access_token"].string {
                GlobalVariables.Session.authToken = authToken
                self.surveyDetailDelegate?.didGetAuthToken(success: true, error: nil)
                return
            }
            self.surveyDetailDelegate?.didGetAuthToken(success: false, error: GlobalVariables.networkError)
            
            
        }) { (error) in
            self.surveyDetailDelegate?.didGetAuthToken(success: false, error: error)

        }
        
    }
}
