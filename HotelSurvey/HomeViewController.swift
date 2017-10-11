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

    //MARK: - Connections
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    @IBOutlet weak var pagingView:UIView!
    @IBOutlet weak var pageControl:UIPageControl!

    //MARK: - iVars
    fileprivate var initialPaginationCount:Int = 10
    fileprivate var isPaginating:Bool = false
    fileprivate let homeInteractor:HomeInteractor = HomeInteractor()
    fileprivate var pageViewController:UIPageViewController!
    fileprivate var surveyData:[HotelSurvey] = [] {
        didSet {
            if surveyData.count > 0 {
                self.pageControl.isHidden = false
                self.pageControl.numberOfPages = surveyData.count
                self.navigationController?.navigationBar.isHidden = false
            } else {
                self.pageControl.currentPage = 0
                self.pageControl.isHidden = true
                self.navigationController?.navigationBar.isHidden = true
            }
        }
    }

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.homeInteractor.surveyDetailDelegate = self
        self.makeAPICalls()
        self.pageControl.transform = CGAffineTransform(rotationAngle: .pi/2)
    }

    
    //MARK: - Action Method's
    @IBAction func reloadButtonTapped(_ sender: Any) {
        for view in self.pagingView.subviews {
            view.removeFromSuperview()
        }
        self.resetValuesOnReload()
        self.getSurveyData()
    }
    
    
    //MARK: - Helper's
    func setNavigationBar() {
        self.title = "SURVEYS"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    
    fileprivate func showSpinner() {
        self.spinner.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    fileprivate func hideSpinner() {
        self.spinner.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
    
    fileprivate func resetValuesOnReload() {
        self.isPaginating = false
        self.surveyData.removeAll()
        self.initialPaginationCount = 10
    }
    
    fileprivate func makeAPICalls() {

        if homeInteractor.isSessionAvailable() {
            self.getOAuthData()
        } else {
            self.getSurveyData()
        }
    }

    
    //MARK: - Api Call's
    fileprivate func getSurveyData() {
        self.showSpinner()
        homeInteractor.getSurveyDetailData(page: 1, perPage: initialPaginationCount)
    }
    
    fileprivate func getOAuthData() {
        self.showSpinner()
        homeInteractor.getOAuthData(username: "carlos@nimbl3.com", password: "antikera")
    }
    
    
    //MARK: - Pagination Method's
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
        homeContentViewController.hotelSelectionDelegate = self
        return homeContentViewController
        
    }
    
    fileprivate func makePaginationCall(pageIndex:Int) {
        if pageIndex == (self.surveyData.count - 2) {
            if initialPaginationCount < GlobalVariables.MaxPaginationLimit {
                self.isPaginating = true
                initialPaginationCount += GlobalVariables.PaginationDifference
                self.getSurveyData()
            }
        }
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
                self.makePaginationCall(pageIndex: vc.pageIndex ?? 0)
            }
        }
    }
}

extension HomeViewController : SurveyDetailProtocol {
    
    func didGetSurveyDetailData(success:Bool, surveyData:[HotelSurvey], error:String?) {
        self.hideSpinner()
        if success {
            self.surveyData = surveyData
            if !isPaginating {
                self.setupPagination()
            }
        } else {
            DialogManager.sharedInstance.showAlert(onViewController: self, withText: "HotelSurvey", withMessage: error ?? "")
        }
    }
    func didGetAuthToken(success:Bool, error:String?) {
        
        self.hideSpinner()
        
        if success == true {
            self.getSurveyData()
        } else {
            DialogManager.sharedInstance.showAlert(onViewController: self, withText: "HotelSurvey", withMessage: error ?? "")
        }
    }
}

extension HomeViewController : HotelSelectionProtocol {
    func didHotelSelected(hotelSurvey:HotelSurvey) {
        let hotelDetailVC = UIStoryboard.instantiateViewController() as HotelDetailViewController
        hotelDetailVC.hotelName = hotelSurvey.title ?? ""
        self.navigationController?.pushViewController(hotelDetailVC, animated: true)
    }
}
