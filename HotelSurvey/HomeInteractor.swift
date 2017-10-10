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

class HomeInteractor {
    
    fileprivate let networkWrapper = NetworkWrapper.sharedInstance
    
    func getSurveyDetailData(page:Int, perPage:Int) {
        
        networkWrapper.getSurveyDetailData(page: page, perPage: perPage, onSuccess: { (dict) in
            
            if let json = JSON(dict).arrayObject {
                print(json)
                if let survey = Mapper<HotelSurvey>().mapArray(JSONObject: json) {
                    print(survey.first?.coverImageUrl ?? "")
                }
            }
            
            
        }) { (error) in
            print(error)
        }
    }
}
