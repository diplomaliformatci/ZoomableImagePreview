//
//  ViewController.swift
//  ZoomableImagePreview
//
//  Created by Can Kincal on 01/11/2020.
//  Copyright (c) 2020 Can Kincal. All rights reserved.
//

import UIKit
import ZoomableImagePreview

class ViewController: UIViewController {

    var images: [UIImage] {
        return (1...3).compactMap{ UIImage(named: "sample\($0)") }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let slider = ZoomableImagePreviewBuilder.make(images: images)
        slider.delegate = self
        slider.backgroundColor = .red
        self.present(slider, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: ZoomableImagePreviewDelegate {
    func zoomableImagePageDidCancelTransition(pageIndex: Int) {
        print("zoomableImgePAgedidCancelTransition")
    }
    
    func zoomableImagePageDidChanged(pageIndex: Int) {
        print("zoomableImageDidChanged")
    }
    
    func zoomableImagePageWillChange(pageIndex: Int) {
        print("zoomableImageWillchange")
    }
    
    func zoomableImagePageWillAppear(pageIndex: Int, contentView: UIView) {
        contentView.backgroundColor = .purple
    }
}

