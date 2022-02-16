//
//  HotelSurveyData.swift
//  HotelSurvey
//
//  Created by Lokesh on 10/10/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import Foundation
import ObjectMapper


class HotelSurvey: Mappable {
    
    var coverImageUrl:String?
    var description:String?
    var title:String?
    var type:String?
    var id:String?
    
    required init?(map: Map)
    {
    }
    
    func mapping(map: Map)
    {
        coverImageUrl <- map["cover_image_url"]
        description <- map["description"]
        title <- map["title"]
        type <- map["type"]
        id <- map["id"]
    }
}
