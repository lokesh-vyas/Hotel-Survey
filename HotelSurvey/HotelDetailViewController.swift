//
//  HotelDetailViewController.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import UIKit

class HotelDetailViewController: UIViewController, StoryboardHandler {
    
    //MARK: - StoryboardHandler variables
    static var storyboardName = Storyboards.homeDetail

    //MARK: - Connections
    @IBOutlet weak var hotelNameLabel:UILabel!
    
    //MARK: - iVars
    var hotelName:String = ""
    
    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hotelNameLabel.text = hotelName
    }

}
