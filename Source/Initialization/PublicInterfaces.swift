//
//  PublicInterfaces.swift
//  ZoomableImagePreview
//
//  Created by Can Kincal on 11.01.2020.
//

import Foundation

// zoom yapildi birakildi pageIndex
// in or out or dragging
// pageIndex page degisiimi

@objc public protocol ZoomableImagePreviewDelegate {
 func zoomableImagePageDidCancelTransition(pageIndex: Int)
 func zoomableImagePageDidChanged(pageIndex: Int)
 func zoomableImagePageWillChange(pageIndex: Int)
 func zoomableImagePageWillAppear(pageIndex: Int, contentView: UIView)
}

public protocol ZoomableImagePreview: UIViewController {
    var delegate: ZoomableImagePreviewDelegate? { get set }
    var backgroundColor: UIColor? { get set }
    
    func revertToDefaultZoomScale(pageIndex: Int)
    
}
