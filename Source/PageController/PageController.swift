//
//  PageController.swift
//  PageControllerZoom
//
//  Created by Can Kincal on 10.01.2020.
//  Copyright © 2020 Can Kincal. All rights reserved.
//

import UIKit

class MyPageController: UIPageViewController {
    lazy var scrollView: UIScrollView? = {
        let scrollView = view.subviews.filter({ $0.isKind(of: UIScrollView.self) }).first as! UIScrollView
        return scrollView
    }()
    
    var scrollEnabled: Bool! {
        willSet { scrollView?.isScrollEnabled = newValue }
    }
}
