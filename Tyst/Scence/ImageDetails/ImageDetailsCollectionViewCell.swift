//
//  ImageDetailsCollectionViewCell.swift
//  Tyst
//
//  Created by hb on 11/12/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class ImageDetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var imgReceipt: UIImageView!
    
    
    override func awakeFromNib() {
         super.awakeFromNib()
         let aTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTapScrollView(recognizer:)))
         imgReceipt.addGestureRecognizer(aTapGesture)
         aTapGesture.numberOfTapsRequired = 2
     }
     
     func viewForZooming(in scrollView: UIScrollView) -> UIView? {
         return imgReceipt
     }
     
    
     
     @IBAction func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
         if scrlView.zoomScale == 1 {
             scrlView.zoom(to: zoomRectForScale(scale: scrlView.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
         } else {
             scrlView.setZoomScale(1, animated: true)
         }
     }
     
     func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
         var zoomRect = CGRect.zero
         zoomRect.size.height = imgReceipt.frame.size.height / scale
         zoomRect.size.width  = imgReceipt.frame.size.width  / scale
         let newCenter = imgReceipt.convert(center, from: scrlView)
         zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
         zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
         return zoomRect
     }
    
    
}
