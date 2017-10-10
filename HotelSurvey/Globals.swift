//
//  Globals.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation

struct GlobalVariables {
    static var accessToken: String = "ce454691e0ee41b2dfd88eb12de8178e15cd3fe9e1c1a73056b25ee9ecc7613b"
}

enum GenericErrors: Error{
    case insufficientParameters
}

func checkNilforString(_ str:String?)->Bool{
    if let checkStr = str {
        if checkStr.isEmpty{
            return false
        }
        return true
    }
    return false
}
