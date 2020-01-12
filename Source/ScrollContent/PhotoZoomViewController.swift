//
//  PhotoZoomViewController.swift
//  PageControllerZoom
//
//  Created by Can Kincal on 10.01.2020.
//  Copyright © 2020 Can Kincal. All rights reserved.
//

import UIKit

class PhotoZoomViewController: UIViewController {
    
    // MARK: - Initialization Variables
    var image: UIImage!
    var pageIndex: Int?
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    convenience init(index: Int, image: UIImage) {
        self.init()
        self.image = image
        self.pageIndex = index
    }
    
    init() {
        super.init(nibName: String(describing: PhotoZoomViewController.self), bundle: Bundle(for: type(of: self)))
        self.modalPresentationStyle = .fullScreen
        print("initialized")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


// MARK: - View Cycle
extension PhotoZoomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.imageView.image = image
        
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

}


// MARK: - Zoom Scale
extension PhotoZoomViewController {
    private func updateZoomScaleForSize(_ size: CGSize) {
        
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minScale
        
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = minScale * 4
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        let contentHeight = yOffset * 2 + self.imageView.frame.height
        self.scrollView.contentSize = CGSize(width: self.scrollView.contentSize.width, height: contentHeight)
        UIView.animate(withDuration: 3.0, animations: view.layoutIfNeeded)
        
    }
}

// MARK: - Helpers
extension PhotoZoomViewController {
    private func configureImage() {
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        imageView.frame = CGRect(x: imageView.frame.origin.x,
                                 y: imageView.frame.origin.y,
                                 width: image.size.width,
                                 height: image.size.height)
    }
}

// MARK: - Public Access
extension PhotoZoomViewController {
    func revertToDefaultZoomScale() {
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
}

// MARK: - Scrollview Delegate
extension PhotoZoomViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(self.view.bounds.size)
    }
}
