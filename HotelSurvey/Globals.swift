//
//  Globals.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation

let USER_DEFAULTS = UserDefaults.standard

struct GlobalVariables {
    
    static var networkError:String = "Sorry! Something is not here. Try again later."
    
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
