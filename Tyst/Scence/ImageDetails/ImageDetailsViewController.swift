//
//  ImageDetailsViewController.swift
//
//  Created by hb on 26/07/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

/// This class is used to display multiple photos with swipe left and right manner.
class ImageDetailsViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var clctnView: UICollectionView!
    var imgStr = [""]
    var scrollTo = 0
    
    // MARK: View lifecycle
    /// Method is called when view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let aIndPath = IndexPath(item: self.scrollTo, section: 0)
            self.clctnView.scrollToItem(at: aIndPath, at: .left, animated: false)
        }
    }
    
    /// Instance
    ///
    /// - Returns: ImageDetailsViewController
    class func instance() -> ImageDetailsViewController? {
        return StoryBoard.ImageDetails.board.instantiateViewController(withIdentifier: AppClass.ImageDetailsVC.rawValue) as? ImageDetailsViewController
    }
    
    /// Method is called when view did appears
    ///
    /// - Parameter animated: animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Dismiss full screen view
    ///
    /// - Parameter sender: WLButton
    @IBAction func btnDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension ImageDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgStr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageDetailsCollectionViewCell
        cell.imgReceipt.setImage(with: imgStr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 40)
    }
}
