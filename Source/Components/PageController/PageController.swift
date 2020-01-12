//
//  PageController.swift
//  PageControllerZoom
//
//  Created by Can Kincal on 10.01.2020.
//  Copyright © 2020 Can Kincal. All rights reserved.
//

import UIKit

internal class MyPageController: UIPageViewController {
    lazy var scrollView: UIScrollView? = {
        let scrollView = view.subviews.filter({ $0.isKind(of: UIScrollView.self) }).first as! UIScrollView
        return scrollView
    }()
    
    var scrollEnabled: Bool! {
        willSet { scrollView?.isScrollEnabled = newValue }
    }
    
    var backgroundColor: UIColor? {
        get {
            guard
                let color = view.backgroundColor else { return nil }
            return color
        }
        
        set {
            self.view.backgroundColor = newValue
        }
    }
    
}
