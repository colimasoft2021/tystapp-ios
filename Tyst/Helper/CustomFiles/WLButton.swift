//
//  WLButton.swift
//  WhiteLabelApp
//
//  Created by hb on 23/10/19.
//  Copyright © 2019 hb. All rights reserved.
//

import UIKit
//import HBLogger
@IBDesignable class WLButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(logEvent), for: .touchUpInside)
    
    }
    
    /// SwifterSwift: Corner radius of view; also inspectable from Storyboard.
       @IBInspectable var cornerRadius: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.masksToBounds = true
               layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
           }
       }
    
    
    /// Log the Button events in library
    @objc func logEvent() {
        
        var aFunctionName = ""
        var aClass = self.superview?.parentViewController
        
        if aClass is NavController
        {
            aClass = (aClass as! NavController).topViewController
        }
        
        
        for target in self.allTargets
        {
            if let aActions = self.actions(forTarget: target, forControlEvent: .touchUpInside)
            {
                for aStr in aActions
                {
                    print("Actions")
                    if aStr != "logEvent"
                    {
                        aFunctionName = aStr
                    }
                    print(aStr)
                }
                
            }
        }
        
        if let _ = aClass
        {
            GlobalUtility.logButtonEvent(functionName: aFunctionName, file: GlobalUtility.classNameAsString(obj: aClass!), name: aFunctionName)
        }
        
        
        
    }

}
