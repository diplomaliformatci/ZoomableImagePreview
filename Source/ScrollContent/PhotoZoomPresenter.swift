//
//  PhotoZoomPresenter.swift
//  ZoomableImagePreview
//
//  Created by Can Kincal on 11.01.2020.
//

import Foundation

internal protocol PhotoZoomPresenterProtocol {
    func calculateConstraintsForSize(result: (_ xOffset: CGFloat, _ yOffset: CGFloat, _ contentHeight: CGFloat) -> (), viewSize: CGSize, presentationSize: CGSize)
    func calculateZoomScaleForSize(result: (_ minScale: CGFloat, _ maxScale: CGFloat) -> (), viewSize: CGSize, presentationSize: CGSize?, scaleFactor: CGFloat)
}

internal class PhotoZoomPresenter: PhotoZoomPresenterProtocol {
    func calculateConstraintsForSize( result: (_ xOffset: CGFloat, _ yOffset: CGFloat, _ contentHeight: CGFloat) -> (), viewSize: CGSize, presentationSize: CGSize) {
        
        let differenceHeight = ( viewSize.height - presentationSize.height )
        let differenceWidth =  ( viewSize.width - presentationSize.width )
        
        let yOffset = max(.zero, differenceHeight).halfOfIt
        let xOffset = max(.zero, differenceWidth).halfOfIt
        let contentHeight = yOffset * 2 + presentationSize.height
        
        result(xOffset, yOffset, contentHeight)
    }
    
    func calculateZoomScaleForSize(result: (_ minScale: CGFloat, _ maxScale: CGFloat) -> (), viewSize: CGSize, presentationSize: CGSize?, scaleFactor: CGFloat) {
        guard let presentationSize = presentationSize else { return }
        
        let widthScale = viewSize.width / presentationSize.width
        let heightScale = viewSize.height / presentationSize.height
        let minScale = min(widthScale, heightScale)
        
        result(minScale, minScale * scaleFactor)
    }
}
