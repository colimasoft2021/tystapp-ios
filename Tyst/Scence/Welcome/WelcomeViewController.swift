//
//  WelcomeViewController.swift
//  PickUpUser
//
//  Created by hb on 23/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: IBOutlet Constants
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var clnView: UICollectionView!
    
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var viewDone: UIView!
    @IBOutlet weak var viewPrevious: UIView!
    @IBOutlet weak var viewNext: UIView!
    
    var isfrom = ""
    
    var indexpath : IndexPath? = IndexPath(item: 0, section: 0 )
    var arrayOfImages = [UIImage(named: "page2")!,UIImage(named: "page3")!,UIImage(named: "page4")!,UIImage(named: "page5")!,UIImage(named: "page6")!,UIImage(named: "page7")!]
    var arryofImageScale : [UIImageView.ContentMode] = [.center,.scaleAspectFit,.center,.center,.scaleAspectFit]
    //var arrayOftext = ["1", "2", "3", "4", "5","6", "7"]
    
    let arrayOftext = [
                ["heading": "View Your Taxes", "desc": "Start viewing the total amount spent and tax applied against the transactions. Export the Estimated Sales Tax Report."],
                ["heading": "Link Bank Accounts", "desc": "Become a Premium Subscriber & Link your Bank Accounts for hassle free estimations of Sales Tax."],
                ["heading": "Differentiate in Taxed and Non Taxed Transactions", "desc": ""],
                ["heading": "Add Receipts Manually", "desc": "Add a receipt manually. Also document the receipt for future reference."],
                ["heading": "Get Your Transaction Details", "desc": "View Transaction Details. Add tips as they are non-taxable, Change Tax Amount if any error in the calculation or Change Category."],
                ["heading": "Change Estimated Sales Tax", "desc": "Change the Sales Tax on any transaction"]
    ]
    /// Insatance
    ///
    /// - Returns: WelcomeViewController
    class func instance() -> WelcomeViewController? {
        return StoryBoard.Welcome.board.instantiateViewController(withIdentifier: AppClass.WelcomeVC.rawValue) as? WelcomeViewController
    }
    
    //MARK: ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDone.addCircularShadow(20)
        btnPrevious.addCircularShadow(20)
        btnNext.addCircularShadow(20)
        self.navigationController?.navigationBar.isHidden = true
        if isfrom == "Setting" {
            self.btnBack.isHidden = false
            self.btnSkip.isHidden = true
        }else {
            self.btnBack.isHidden = true
            self.btnSkip.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    //MARK: IBAction
    @IBAction func btnSkipAction(_ sender: UIButton) {
        //PickUpUserSessionHandler.shared.savePopUpStatus(token: "1")
        
        UserDefaultsManager.tutorialFinish = "Yes"
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if let indexpath = self.clnView.indexPathsForVisibleItems.first {
            print(indexpath)
            let next = indexpath.row+1
            self.clnView.scrollToItem(at: IndexPath(item: next, section: 0), at: .right, animated: true)
        }
    }
    
    @IBAction func btnPreviousAction(_ sender: UIButton) {
        if let indexpath = self.clnView.indexPathsForVisibleItems.first {
            print(indexpath)
            let previous = indexpath.row-1
            self.clnView.scrollToItem(at: IndexPath(item: previous, section: 0), at: .left, animated: true)
        }
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        //PickUpUserSessionHandler.shared.savePopUpStatus(token: "1")
        if isfrom == "Setting" {
            self.navigationController?.popViewController(animated: true)
        }else {
            UserDefaultsManager.tutorialFinish = "Yes"
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: CollectionView Methods
extension WelcomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOftext.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let aIndextifier = "WelcomeCell"
        
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: aIndextifier, for: indexPath) as! WelcomeCell
        
        if let  _ = aCell.imgView
        {
            aCell.imgView.image = self.arrayOfImages[indexPath.row]
            //aCell.imgView.contentMode = self.arryofImageScale[indexPath.row]
        }
        if let  _ = aCell.lblText
        {
            aCell.lblText.text = self.arrayOftext[indexPath.row]["heading"]
        }
        
        if let  _ = aCell.lblDesc
        {
            aCell.lblDesc.text = self.arrayOftext[indexPath.row]["desc"]
        }
        
        if indexPath.row == 2 {
            aCell.viewTax.isHidden = false
        }else {
            aCell.viewTax.isHidden = true
        }
        
        return aCell
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: AppConstants.screenHeight - 100)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.changeButtonStatus(scrollView)
        
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.changeButtonStatus(scrollView)
    }
    
    
    func changeButtonStatus(_ scrollView:UIScrollView)
    {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = self.clnView.indexPathForItem(at: center) {
            self.indexpath = ip
            
            
            if indexpath?.row == 0 {
                self.viewPrevious.isHidden = true
                self.viewNext.isHidden = false
                self.viewDone.isHidden = true
                if isfrom != "Setting" {
                    self.btnSkip.isHidden = false
                }
                
            } else if indexpath?.row == 5 {
                self.viewPrevious.isHidden = false
                self.viewNext.isHidden = true
                self.viewDone.isHidden = false
                self.btnSkip.isHidden = true
            } else {
                self.viewPrevious.isHidden = false
                self.viewNext.isHidden = false
                self.viewDone.isHidden = true
                if isfrom != "Setting" {
                    self.btnSkip.isHidden = false
                }
            }
        }
    }
    
}
