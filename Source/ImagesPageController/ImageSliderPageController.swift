//
//  ImageSliderPageController.swift
//  PageControllerZoom
//
//  Created by Can Kincal on 10.01.2020.
//  Copyright © 2020 Can Kincal. All rights reserved.
//

import UIKit

class ImageSliderPageController: UIViewController {
    
    init() {
        super.init(nibName: String(describing: ImageSliderPageController.self), bundle: Bundle(for: type(of: self)))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var currentIndex = 0
    var nextIndex: Int?
    
    let images: [UIImage] =
        [ UIImage(named: "sample")!,
          UIImage(named: "sample2")!,
          UIImage(named: "sample")! ]
    
    lazy var viewControllers: [UIViewController] = {
        return images.enumerated().compactMap {
            let vc = PhotoZoomViewController(index: $0, image: $1)
            return vc
        }
    }()
    
    lazy var pageController: MyPageController = {
        let pageController = MyPageController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: [UIPageViewController.OptionsKey.interPageSpacing : view.bounds.width / 8])
        pageController.dataSource = self
        pageController.delegate = self
        pageController.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
        return pageController
    }()
}


// MARK: - View Cycle
extension ImageSliderPageController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(pageController.view)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}


// MARK: - PageViewController DataSource
extension ImageSliderPageController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return currentIndex != 0 ? viewControllers[currentIndex - 1] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return currentIndex < images.count - 1 ? viewControllers[currentIndex + 1] : nil
    }
}

// MARK: - PageViewController Delegate
extension ImageSliderPageController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? PhotoZoomViewController else {
            return
        }
        
        nextIndex = nextVC.pageIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard
            completed,
            let index = nextIndex else { return }
        revertToDefaultZoomScale(viewControllers: previousViewControllers)
        currentIndex = index
        nextIndex = nil
    }
    
    private func revertToDefaultZoomScale(viewControllers: [UIViewController]) {
        viewControllers.compactMap{ $0 as? PhotoZoomViewController }.forEach{ $0.revertToDefaultZoomScale() }
    }
}
