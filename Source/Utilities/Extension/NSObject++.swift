//
//  NSObject++.swift
//  ZoomableImagePreview
//
//  Created by Can Kincal on 12.01.2020.
//

import Foundation

extension NSObject {
    static var describe: String {
        return String(describing: self)
    }
    
    static var defaultBundle: Bundle {
        return Bundle(for: self)
    }
}
