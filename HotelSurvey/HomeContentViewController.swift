//
//  HomeContentViewController.swift
//  HotelSurvey
//
//  Created by Mayank on 09/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import UIKit
import AlamofireImage

protocol HotelSelectionProtocol {
    func didHotelSelected(hotelSurvey:HotelSurvey)
}

class HomeContentViewController: UIViewController, StoryboardHandler {

    //MARK: - StoryboardHandler variables
    static var storyboardName = Storyboards.home
    
    @IBOutlet weak var hotelCoverImageview:UIImageView!
    @IBOutlet weak var hotelNameLabel:UILabel!
    @IBOutlet weak var hotelDescriptionLabel:UILabel!
    
    var hotelSelectionDelegate:HotelSelectionProtocol?
    var pageIndex:Int?
    var hotelSurvey:HotelSurvey?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL.init(string: hotelSurvey?.coverImageUrl ?? "") {
            self.hotelCoverImageview.af_setImage(withURL:url, placeholderImage: nil, imageTransition: .crossDissolve(0.3))
        }
        self.hotelNameLabel.text = self.hotelSurvey?.title ?? ""
        self.hotelDescriptionLabel.text = self.hotelSurvey?.description ?? ""
    }
    
    @IBAction func takeToSurveyTapped(_ sender: Any) {
        if let hotel = self.hotelSurvey {
            self.hotelSelectionDelegate?.didHotelSelected(hotelSurvey: hotel)
        }
    }
}
