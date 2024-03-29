//
//  Globals.swift
//  HotelSurvey
//
//  Created by Lokesh on 10/10/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import Foundation

let USER_DEFAULTS = UserDefaults.standard

struct GlobalVariables {
    
    static let networkError:String = "Sorry! Something is not here. Try again later."
    
    static let MaxPaginationLimit:Int = 20
    static let PaginationDifference:Int = 5

    //MARK: - Session Data
    struct Session {
        static var authToken:String {
            get {
                if let type = USER_DEFAULTS.value(forKey: UserDefaultsKeys.Session.authToken.rawValue) as? String {
                    return type
                } else {
                    return ""
                }
            }
            
            set(value) {
                
                if value.isEmpty {
                    USER_DEFAULTS.removeObject(forKey: UserDefaultsKeys.Session.authToken.rawValue)
                } else {
                    USER_DEFAULTS.set(value, forKey: UserDefaultsKeys.Session.authToken.rawValue)
                }
                USER_DEFAULTS.synchronize()
            }
        }
        
        static func clear() {
            Session.authToken = ""
        }
    }
    
    
}

enum UserDefaultsKeys {
    
    // MARK:- Session Data
    enum Session:String {
        case authToken = "authToken"
        
    }
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
