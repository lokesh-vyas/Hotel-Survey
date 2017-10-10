//
//  HomeViewController.swift
//  HotelSurvey
//
//  Created by Mayank on 09/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var spinner:UIActivityIndicatorView!
    
    fileprivate let homeInteractor:HomeInteractor = HomeInteractor()
    fileprivate var surveyData:[HotelSurvey] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeInteractor.surveyDetailDelegate = self
        self.checkSessionAvailability()
    }

    fileprivate func checkSessionAvailability() {
        self.spinner.startAnimating()
        if GlobalVariables.Session.authToken.isEmpty {
            homeInteractor.getOAuthData(username: "carlos@nimbl3.com", password: "antikera")
        } else {
            homeInteractor.getSurveyDetailData(page: 1, perPage: 10)
        }
    }

}

extension HomeViewController : SurveyDetailProtocol {
    
    func didGetSurveyDetailData(success:Bool, surveyData:[HotelSurvey], error:String?) {
        
        self.spinner.stopAnimating()
        
        if success {
            self.surveyData = surveyData
        } else {
            DialogManager.sharedInstance.showAlert(onViewController: self, withText: "HotelSurvey", withMessage: error ?? "")
        }
    }
    func didGetAuthToken(success:Bool, error:String?) {
        
        self.spinner.stopAnimating()
        
        if success == true {
            self.checkSessionAvailability()
        } else {
            DialogManager.sharedInstance.showAlert(onViewController: self, withText: "HotelSurvey", withMessage: error ?? "")
        }
    }
}
