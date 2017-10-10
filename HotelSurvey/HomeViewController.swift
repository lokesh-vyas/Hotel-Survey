//
//  HomeViewController.swift
//  HotelSurvey
//
//  Created by Mayank on 09/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    fileprivate let homeInteractor:HomeInteractor = HomeInteractor()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeInteractor.getSurveyDetailData(page: 1, perPage: 10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
