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
    private var channelsInfoDataArray: [StatisticsForChannelItems] = []
    private var uploadsIdsArray: [String] = []
    
    private let networkService = NetworkService.shared
    private let serialQueue = DispatchQueue.global()
    private let firstChannelId = "UCfM3zsQsOnfWNUppiycmBuw"
    private let secondChannelId = "UC0KAFLxIiaR_FFNYDL3utGw"
    private let thirdChannelId = "UCLQPinZNWKlLBF7C_m2YP3g"
    private let fourthChannelId = "UCAfvFXvjzEupwo2NtyDhRZA"
    private let activityIndicatorView = UIActivityIndicatorView(frame: CGRect(origin: CGPoint.zero,
                                                                              size: CGSize(width: 326, height: 183)))
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        dataSource = self
        self.isPagingEnabled = false
        setupUi()
        loadData { viewControllers in
            if let firstViewController = viewControllers.first {
                setViewControllers([firstViewController], direction: .forward, animated: true)
            }
            setupTimer()
        }
    }
    
    //MARK: - Private
    
    private func setupUi() {
        
        addTapGestureRecogniser()
        addActivityIndicatorView()
        decoratePageControl()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func addTapGestureRecogniser() {
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.showPlayerViewController(_:)))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
    
    private func addActivityIndicatorView() {
        
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    private func populateItems() {
        
        var indexForAppend = 0
        for _ in channelsInfoDataArray {
            let newItem = createCarouselItemController(with: channelsInfoDataArray[indexForAppend].snippet?.title,
                                                       with: channelsInfoDataArray[indexForAppend].snippet?.thumbnails?.statisticsForChannelHigh?.url,
                                                       with: channelsInfoDataArray[indexForAppend].statistics!.subscriberCount ?? "")
            itemsToPresent.append(newItem)
            indexForAppend += 1
        }
        indexForAppend = 0
        for _ in channelsInfoDataArray {
            uploadsIdsArray.append(channelsInfoDataArray[indexForAppend].contentDetails?.relatedPlaylists?.uploads ?? "")
            indexForAppend += 1
        }
        indexForAppend = 0
    }
    
    private func createCarouselItemController(with channelNameText: String?,
                                              with backgroundImageViewURLString: String?,
                                              with subscribersCountText: String) -> UIViewController {
        
        let viewController = UIViewController()
        viewController.view = CarouselItem(backgroundImageViewURLString: backgroundImageViewURLString,
                                           channelNameText: channelNameText,
                                           subscribersCountText: subscribersCountText)
        return viewController
    }
    
    private func decoratePageControl() {
        
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [CarouselViewController.self])
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray
        pageControl.isUserInteractionEnabled = false
    }
    
    private func viewControllerAtIndex(_ index: Int) -> UIViewController {
        
        guard index < itemsToPresent.count else { return UIViewController() }
        currentPageIndex = index
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
        return itemsToPresent[index]
    }
    
    @objc private func changePage() {
        
        currentPageIndex = AutoSlideHelper.pageIndex(for: currentPageIndex,
                                                     totalPageCount: itemsToPresent.count,
                                                     direction: .forward)
        guard let viewController = viewControllerAtIndex(currentPageIndex) as UIViewController? else { return }
        setViewControllers([viewController], direction: .forward, animated: true)
    }
    
    @objc private func showPlayerViewController(_ sender: UITapGestureRecognizer) {
        
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let playerViewController = main.instantiateViewController(withIdentifier:
                                                                        "PlayerViewController")
            as? PlayerViewController {
            playerViewController.galleryOrCarousel = 1
            playerViewController.playlistId = self.uploadsIdsArray[currentPageIndex]
            playerViewController.currentPage = self.currentPageIndex
            navigationController?.present(playerViewController, animated: true)
        }
    }
    
    private func setupTimer() {
        
        _ = Timer.scheduledTimer(timeInterval: 5,
                                 target: self,
                                 selector: #selector(changePage),
                                 userInfo: nil,
                                 repeats: true)
    }
    
    private func loadData(completion: (([UIViewController]) -> ())) {
        
        serialQueue.async {
            self.networkService.fetchDataForCarousel(channelId: self.firstChannelId) { items in
                self.channelsInfoDataArray = items
                self.populateItems()
            }
        }
        serialQueue.async {
            self.networkService.fetchDataForCarousel(channelId: self.secondChannelId) { items in
                self.channelsInfoDataArray = items
                self.populateItems()
            }
        }
        serialQueue.async {
            self.networkService.fetchDataForCarousel(channelId: self.thirdChannelId) { items in
                self.channelsInfoDataArray = items
                self.populateItems()
            }
        }
        serialQueue.async {
            self.networkService.fetchDataForCarousel(channelId: self.fourthChannelId) { items in
                self.channelsInfoDataArray = items
                self.populateItems()
            }
        }
        serialQueue.sync {
            completion(itemsToPresent)
        }
    }
}

extension CarouselViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
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
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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

extension UIPageViewController {
    
    var isPagingEnabled: Bool {
        get {
            var isEnabled: Bool = true
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set {
            for view in view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
