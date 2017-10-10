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
    @IBOutlet weak var pageControl:UIPageControl!

    fileprivate let homeInteractor:HomeInteractor = HomeInteractor()
    fileprivate var surveyData:[HotelSurvey] = [] {
        didSet {
            if surveyData.count > 0 {
                self.pageControl.isHidden = false
                self.pageControl.numberOfPages = surveyData.count
                self.navigationController?.navigationBar.isHidden = false
            } else {
                self.pageControl.isHidden = true
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }
    fileprivate var pageViewController:UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.homeInteractor.surveyDetailDelegate = self
        self.checkSessionAvailability()
        self.pageControl.transform = CGAffineTransform(rotationAngle: .pi/2)
    }

    @IBAction func reloadButtonTapped(_ sender: Any) {
        for view in self.pagingView.subviews {
            view.removeFromSuperview()
        }
        self.surveyData.removeAll()
        self.checkSessionAvailability()
    }
    //MARK: - Helper's
    
    func setNavigationBar() {
        self.title = "SURVEYS"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
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
        
        if var index = (viewController as? HomeContentViewController)?.pageIndex, index > 0  {
            index = index - 1
            return viewControllerAtIndex(index:index)
        }
        
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if var index = (viewController as? HomeContentViewController)?.pageIndex {
            index = index + 1
            if index == self.surveyData.count {
                return nil
            }
            return viewControllerAtIndex(index:index)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished == true {
            if let vc = pageViewController.viewControllers?.first as? HomeContentViewController {
                self.pageControl.currentPage = vc.pageIndex ?? 0
            }
        }
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
