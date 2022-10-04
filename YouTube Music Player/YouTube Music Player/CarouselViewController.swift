//
//  CarouselViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit

class CarouselViewController: UIPageViewController {
    
    fileprivate var items: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        populateItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
    }
    
    fileprivate func populateItems() {
        
        let text = ["some", "body", "once", "told"]
        let backgroundColor: [UIColor] = [.green, .yellow, .cyan, .brown]
        
        for (index, t) in text.enumerated() {
            let c = createCarouselItemController(with: t, with: backgroundColor[index])
            items.append(c)
        }
    }
    
    fileprivate func createCarouselItemController(with titleText: String?, with color: UIColor?) -> UIViewController {
        
        let c = UIViewController()
        c.view = CarouselItem(titleText: titleText, background: color)
        
        return c
    }
    
    fileprivate func decoratePageControl() {
        
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [CarouselViewController.self])
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
    }

}

extension CarouselViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return items.last
        }
        
        guard items.count > previousIndex else {
            return nil
        }
        
        return items[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = items.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard items.count != nextIndex else {
            return items.first
        }
        
        guard items.count > nextIndex else {
            return nil
        }
        
        return items[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return items.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = items.index(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
    
}
