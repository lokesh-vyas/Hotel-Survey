//
//  HomeViewController.swift
//  HotelSurvey
//
//  Created by Mayank on 09/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, StoryboardHandler {
    
    //MARK: - StoryboardHandler variables
    static var storyboardName = Storyboards.home

    @IBOutlet weak var spinner:UIActivityIndicatorView!
    @IBOutlet weak var pagingView:UIView!

    fileprivate let homeInteractor:HomeInteractor = HomeInteractor()
    fileprivate var surveyData:[HotelSurvey] = []
    fileprivate var pageViewController:UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.homeInteractor.surveyDetailDelegate = self
        self.checkSessionAvailability()
    }

    @IBAction func reloadButtonTapped(_ sender: Any) {
        for view in self.pagingView.subviews {
            view.removeFromSuperview()
        }
        self.checkSessionAvailability()
    }
    //MARK: - Helper's
    
    func setNavigationBar() {
        self.title = "SURVEYS"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
    
    fileprivate func checkSessionAvailability() {
        self.spinner.startAnimating()
        if GlobalVariables.Session.authToken.isEmpty {
            homeInteractor.getOAuthData(username: "carlos@nimbl3.com", password: "antikera")
        } else {
            homeInteractor.getSurveyDetailData(page: 1, perPage: 10)
        }
    }
    
    
    fileprivate func setupPagination() {
        let startVC = self.viewControllerAtIndex(index: 0)
        let vc = [startVC]
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
        self.pageViewController.setViewControllers(vc, direction: .forward, animated: true, completion: nil)
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        self.pageViewController.view.frame = self.pagingView.bounds
        self.addChildViewController(self.pageViewController!)
        self.pagingView.addSubview(self.pageViewController.view)
    }
    
    fileprivate func viewControllerAtIndex(index:Int) -> HomeContentViewController {
        
        let homeContentViewController = UIStoryboard.instantiateViewController() as HomeContentViewController
        homeContentViewController.pageIndex = index
        homeContentViewController.hotelSurvey = self.surveyData[index]
        return homeContentViewController
        
    }

}

extension HomeViewController: UIPageViewControllerDataSource , UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! HomeContentViewController).pageIndex
        
        if index == 0 || index == nil {
            return nil
        }
        index = index! - 1
        return viewControllerAtIndex(index:index!)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! HomeContentViewController).pageIndex
        
        if index == nil {
            return nil
        }
        index = index! + 1
        if index == self.surveyData.count {
            return nil
        }
        return viewControllerAtIndex(index:index!)
    }
}

extension HomeViewController : SurveyDetailProtocol {
    
    func didGetSurveyDetailData(success:Bool, surveyData:[HotelSurvey], error:String?) {
        self.spinner.stopAnimating()
        if success {
            self.surveyData = surveyData
            self.setupPagination()
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
