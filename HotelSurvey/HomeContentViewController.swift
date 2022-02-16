//
//  HomeContentViewController.swift
//  HotelSurvey
//
//  Created by Lokesh on 09/10/17.
//  Copyright © 2017 Lokesh. All rights reserved.
//

import UIKit
import AlamofireImage

protocol HotelSelectionProtocol {
    func didHotelSelected(hotelSurvey:HotelSurvey)
}

class HomeContentViewController: UIViewController, StoryboardHandler {

    //MARK: - StoryboardHandler variables
    static var storyboardName = Storyboards.home
    
    //MARK: - Connections
    @IBOutlet weak var hotelCoverImageview:UIImageView!
    @IBOutlet weak var hotelNameLabel:UILabel!
    @IBOutlet weak var hotelDescriptionLabel:UILabel!
    
    //MARK: - iVars
    var hotelSelectionDelegate:HotelSelectionProtocol?
    var pageIndex:Int?
    var hotelSurvey:HotelSurvey?

    
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL.init(string: hotelSurvey?.coverImageUrl ?? "") {
            self.hotelCoverImageview.af_setImage(withURL:url, placeholderImage: #imageLiteral(resourceName: "hotelplaceholder_image"), imageTransition: .crossDissolve(0.3))
        }
        self.hotelNameLabel.text = self.hotelSurvey?.title ?? ""
        self.hotelDescriptionLabel.text = self.hotelSurvey?.description ?? ""
    }
    
    
    //MARK: - Action Method's
    @IBAction func takeToSurveyTapped(_ sender: Any) {
        if let hotel = self.hotelSurvey {
            self.hotelSelectionDelegate?.didHotelSelected(hotelSurvey: hotel)
        }
    }
}
