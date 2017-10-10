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
            
            let json = JSON(dict).arrayValue
            print(json)
            
        }) { (error) in
            print(error)
        }
    }
}
