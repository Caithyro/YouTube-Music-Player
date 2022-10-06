//
//  CarouselViewController.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 04.10.2022.
//

import UIKit

class CarouselViewController: UIPageViewController {
    
    private var itemsToPresent: [UIViewController] = []
    private var currentPageIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        populateItems()
        if let firstViewController = itemsToPresent.first {
            setViewControllers([firstViewController], direction: .forward, animated: true)
        }
        setupTimer()
    }
    
    private func populateItems() {
        
        let text = ["some", "body", "once", "told"]
        let backgroundColor: [UIColor] = [.green, .yellow, .cyan, .brown]
        
        for (index, t) in text.enumerated() {
            let newItem = createCarouselItemController(with: t, with: backgroundColor[index])
            itemsToPresent.append(newItem)
        }
    }
    
    private func createCarouselItemController(with titleText: String?, with color: UIColor?) -> UIViewController {
        
        let viewController = UIViewController()
        viewController.view = CarouselItem(titleText: titleText, background: color)
        
        return viewController
    }
    
    private func decoratePageControl() {
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [CarouselViewController.self])
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
    }
    
    private func viewControllerAtIndex(_ index: Int) -> UIViewController {
        
        guard index < itemsToPresent.count else { return UIViewController() }
        currentPageIndex = index
        return itemsToPresent[index]
    }
    
    @objc private func changePage() {
        
        currentPageIndex = AutoSlideHelper.pageIndex(for: currentPageIndex,
                                                     totalPageCount: itemsToPresent.count,
                                                     direction: .forward)
        guard let viewController = viewControllerAtIndex(currentPageIndex) as UIViewController? else { return }
        setViewControllers([viewController], direction: .forward, animated: true)
    }
    
    private func setupTimer() {
        
        _ = Timer.scheduledTimer(timeInterval: 5,
                                         target: self,
                                         selector: #selector(changePage),
                                         userInfo: nil,
                                         repeats: true)
    }

}

extension CarouselViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = itemsToPresent.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return itemsToPresent.last
        }
        
        guard itemsToPresent.count > previousIndex else {
            return nil
        }
        
        return itemsToPresent[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = itemsToPresent.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        guard itemsToPresent.count != nextIndex else {
            return itemsToPresent.first
        }
        
        guard itemsToPresent.count > nextIndex else {
            return nil
        }
        
        return itemsToPresent[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return itemsToPresent.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        guard let firstViewController = viewControllers?.first,
              let firstViewControllerIndex = itemsToPresent.firstIndex(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
    
}
