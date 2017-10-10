//
//  StoryboardInstantiateHandler.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation

import UIKit

enum Storyboards : String {
    case home = "Main"
}

protocol StoryboardHandler : NSObjectProtocol {
    static var restoreIdentifier : String { get }
    static var storyboardName : Storyboards { get }
}

extension StoryboardHandler {
    static var restoreIdentifier : String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    class func instantiateViewController<T:UIViewController>() -> T where T:StoryboardHandler {
        guard let controller = UIStoryboard(name: T.storyboardName.rawValue, bundle: nil).instantiateViewController(withIdentifier: T.restoreIdentifier) as? T else{
            fatalError("Could not instantiate controller with identifier: \(T.restoreIdentifier)")
        }
        return controller
    }
}
