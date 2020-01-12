//
//  ZoomableImagePreviewBuilder.swift
//  ZoomableImagePreview
//
//  Created by Can Kincal on 11.01.2020.
//

import UIKit

public struct ZoomableImagePreviewBuilder {
    public static func make(images: [UIImage], presentationStyle: UIModalPresentationStyle = .fullScreen) -> ZoomableImagePreview {
        let slider = ImageSliderPageController(images: images)
        slider.modalPresentationStyle = presentationStyle
        return slider
    }
}
