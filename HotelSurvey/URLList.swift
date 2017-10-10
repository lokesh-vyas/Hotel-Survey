//
//  URLList.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation

enum Base:String {
    case baseUrl = "https://nimbl3-survey-api.herokuapp.com"
}

struct URLEnum {
    static var surveyDetailUrl = Base.baseUrl.rawValue + "/surveys.json"
}

enum MethodType:String {
    case get = "GET"
    case post = "POST"
}
