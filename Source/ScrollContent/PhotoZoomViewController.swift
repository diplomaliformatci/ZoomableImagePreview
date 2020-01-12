//
//  PhotoZoomViewController.swift
//  PageControllerZoom
//
//  Created by Can Kincal on 10.01.2020.
//  Copyright © 2020 Can Kincal. All rights reserved.
//

import UIKit

internal class PhotoZoomViewController: UIViewController {
    
    // MARK: - Initialization Variables
    var pageIndex: Int!
    var image: UIImage!
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Delegates
    var presenter: PhotoZoomPresenterProtocol?
    var delegate: ZoomableImagePreviewDelegate?
    convenience init(index: Int, image: UIImage) {
        self.init()
        self.presenter = PhotoZoomPresenter()
        self.image = image
        self.pageIndex = index
    }
    
    init() {
        super.init(nibName: String(describing: Self.describe), bundle: Self.defaultBundle)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


// MARK: - View Cycle
extension PhotoZoomViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView?.delegate = self
        self.imageView.image = image
        configureImage()
        scrollView?.backgroundColor = .black
        updateZoomScaleForSize(view.bounds.size)
        updateConstraintsForSize(view.bounds.size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.zoomableImagePageWillAppear(pageIndex: pageIndex, contentView: scrollView)
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
        presenter?.calculateZoomScaleForSize(viewSize: size,
                                             presentationSize: imageView?.bounds.size,
                                             scaleFactor: 4.0, result: { (minScale, maxScale) in
            scrollView?.minimumZoomScale = minScale
            scrollView?.zoomScale = minScale
            scrollView?.maximumZoomScale = maxScale
        })
    }
    
    private func updateConstraintsForSize(_ size: CGSize) {
        presenter?.calculateConstraintsForSize(
            viewSize: size,
            presentationSize: imageView.frame.size,
            result: { (xOffset, yOffset, contentHeight) in
                imageViewTopConstraint.constant = yOffset
                imageViewBottomConstraint.constant = yOffset
                imageViewLeadingConstraint.constant = xOffset
                imageViewLeadingConstraint.constant = xOffset
                scrollView?.contentSize = CGSize(width: scrollView?.contentSize.width ?? 0, height: contentHeight)
                view.layoutIfNeeded()
        })
        
    }
}

// MARK: - Helpers
extension PhotoZoomViewController {
    private func configureImage() {
        if #available(iOS 11, *) {
            scrollView?.contentInsetAdjustmentBehavior = .never
        }
        imageView.frame = CGRect(x: imageView.frame.origin.x,
                                 y: imageView.frame.origin.y,
                                 width: image.size.width,
                                 height: image.size.height)
    }
}

// MARK: - Change Scale
extension PhotoZoomViewController {
    func revertToDefaultZoomScale() {
        scrollView?.zoomScale = scrollView?.minimumZoomScale ?? 1
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
