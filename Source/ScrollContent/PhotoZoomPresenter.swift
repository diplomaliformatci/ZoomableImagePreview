//
//  PhotoZoomPresenter.swift
//  ZoomableImagePreview
//
//  Created by Can Kincal on 11.01.2020.
//

import Foundation

internal protocol PhotoZoomPresenterProtocol {
    func calculateConstraintsForSize(viewSize: CGSize, presentationSize: CGSize, result: (_ xOffset: CGFloat, _ yOffset: CGFloat, _ contentHeight: CGFloat) -> ())
    func calculateZoomScaleForSize(viewSize: CGSize, presentationSize: CGSize?, scaleFactor: CGFloat, result: (_ minScale: CGFloat, _ maxScale: CGFloat) -> ())
}

internal class PhotoZoomPresenter: PhotoZoomPresenterProtocol {
    func calculateConstraintsForSize(viewSize: CGSize, presentationSize: CGSize, result: (_ xOffset: CGFloat, _ yOffset: CGFloat, _ contentHeight: CGFloat) -> ()) {
        
        let differenceHeight = ( viewSize.height - presentationSize.height )
        let differenceWidth =  ( viewSize.width - presentationSize.width )
        
        let yOffset = max(.zero, differenceHeight).halfOfIt
        let xOffset = max(.zero, differenceWidth).halfOfIt
        let contentHeight = yOffset * 2 + presentationSize.height
        
        result(xOffset, yOffset, contentHeight)
    }
    
    func calculateZoomScaleForSize(viewSize: CGSize, presentationSize: CGSize?, scaleFactor: CGFloat, result: (_ minScale: CGFloat, _ maxScale: CGFloat) -> ()) {
        guard let presentationSize = presentationSize else { return }
        
        let widthScale = viewSize.width / presentationSize.width
        let heightScale = viewSize.height / presentationSize.height
        let minScale = min(widthScale, heightScale)
        
        result(minScale, minScale * scaleFactor)
    }
}

internal extension CGFloat {
    @inlinable var halfOfIt: CGFloat {
        return self / 2
    }
}
