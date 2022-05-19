//
//  PageViewController.swift
//  PracticeAndStudyUI
//
//  Created by app on 2022/05/19.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    //MARK: Properties
    var viewList: [UIViewController] = {
        let storyboard = UIStoryboard(name: "PageVC", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "RedViewController")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "YellowViewController")
        let vc3 = storyboard.instantiateViewController(withIdentifier: "GreenViewController")
        
        return [vc1, vc2, vc3]
    }()
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return viewList.firstIndex(of: vc) ?? 0
    }
    
    var completeHandler: ((Int)->())?

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        self.delegate = self
        
        if let firstVC = viewList.first {
            self.setViewControllers([firstVC], direction: .forward, animated: true)
        }
    }
    
    //MARK: Functions
    func setPreviousViewControllerFromIndex(index: Int) {
        if index < 0 || index >= viewList.count { return }
        self.setViewControllers([viewList[index]], direction: .reverse, animated: true)
        completeHandler?(currentIndex)
    }
    
    func setNextViewControllerFromIndex(index: Int) {
        if index < 0 || index >= viewList.count { return }
        self.setViewControllers([viewList[index]], direction: .forward, animated: true)
        completeHandler?(currentIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewList.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        
        if previousIndex < 0 { return nil }
        
        return viewList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewList.firstIndex(of: viewController) else { return nil }
        
        let nextIndex = index + 1
        
        if nextIndex == viewList.count { return nil }
        
        return viewList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            completeHandler?(currentIndex)
        }
    }

}
