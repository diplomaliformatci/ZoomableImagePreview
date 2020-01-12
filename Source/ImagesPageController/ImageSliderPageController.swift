//
//  ImageSliderPageController.swift
//  PageControllerZoom
//
//  Created by Can Kincal on 10.01.2020.
//  Copyright © 2020 Can Kincal. All rights reserved.
//

import UIKit

extension NSObject {
    static var describe: String {
        return String(describing: self)
    }
    
    static var defaultBundle: Bundle {
        return Bundle(for: self)
    }
}

class ImageSliderPageController: UIViewController {
    init() {
        super.init(nibName: String(describing: Self.describe), bundle: Self.defaultBundle)
    }
    
    convenience init(images: [UIImage]) {
        self.init()
        self.images = images
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var currentIndex = 0
    var nextIndex: Int?
    var delegate: ZoomableImagePreviewDelegate?
    
    var images: [UIImage]!
    
    var backgroundColor: UIColor? {
        get { return pageController.backgroundColor }
        set { pageController.backgroundColor = newValue }
    }
    
    lazy var viewControllers: [PhotoZoomViewController] = {
        return images.enumerated().compactMap {
            let foo = PhotoZoomViewController(index: $0, image: $1)
            foo.delegate = self
            return foo
        }
    }()
    
    lazy var pageController: MyPageController = {
        let foo = MyPageController(transitionStyle: .scroll,
                                              navigationOrientation: .horizontal,
                                              options: [UIPageViewController.OptionsKey.interPageSpacing : view.bounds.width / 8])
        foo.dataSource = self
        foo.delegate = self
        foo.setViewControllers([viewControllers.first!], direction: .forward, animated: true, completion: nil)
        return foo
    }()
}


// MARK: - View Cycle
extension ImageSliderPageController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(pageController.view)
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
        zoomableImagePageWillChange(pageIndex: nextVC.pageIndex)
        nextIndex = nextVC.pageIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let index = nextIndex else { return }
        guard completed else { delegate?.zoomableImagePageDidCancelTransition(pageIndex: index); return }
        
        revertToDefaultZoomScale(viewControllers: previousViewControllers)
        currentIndex = index
        nextIndex = nil
        delegate?.zoomableImagePageDidChanged(pageIndex: currentIndex)
    }
    
    private func revertToDefaultZoomScale(viewControllers: [UIViewController]) {
        viewControllers.compactMap{ $0 as? PhotoZoomViewController }.forEach{ $0.revertToDefaultZoomScale() }
    }
}


// MARK: - Public Access
extension ImageSliderPageController: ZoomableImagePreview{
    func revertToDefaultZoomScale(pageIndex: Int) {
        let controller = viewControllers[pageIndex]
        self.revertToDefaultZoomScale(viewControllers: [controller])
    }
}

extension ImageSliderPageController: ZoomableImagePreviewDelegate{
    func zoomableImagePageDidCancelTransition(pageIndex: Int) {
        delegate?.zoomableImagePageDidCancelTransition(pageIndex: pageIndex)
    }
    
    func zoomableImagePageDidChanged(pageIndex: Int) {
        delegate?.zoomableImagePageDidChanged(pageIndex: pageIndex)
    }
    
    func zoomableImagePageWillChange(pageIndex: Int) {
        delegate?.zoomableImagePageWillChange(pageIndex: pageIndex)
    }
    
    func zoomableImagePageWillAppear(pageIndex: Int, contentView: UIView) {
        delegate?.zoomableImagePageWillAppear(pageIndex: pageIndex, contentView: contentView)
    }
}
