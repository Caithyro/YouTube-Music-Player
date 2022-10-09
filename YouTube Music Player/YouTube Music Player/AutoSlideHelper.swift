//
//  AutoSlideHelper.swift
//  YouTube Music Player
//
//  Created by Дмитрий Куприенко on 06.10.2022.
//

import UIKit

final class AutoSlideHelper {
    
    class func pageIndex(for currentPageIndex: Int,
                         totalPageCount: Int,
                         direction: UIPageViewController.NavigationDirection) -> Int {
        switch direction {
        case .reverse:
            return currentPageIndex > 0 ? currentPageIndex - 1 : totalPageCount - 1
        case .forward:
            fallthrough
        @unknown default:
            return currentPageIndex < totalPageCount - 1 ? currentPageIndex + 1 : 0
        }
    }
    
}
