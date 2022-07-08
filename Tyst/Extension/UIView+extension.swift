//
//  UIView+extension.swift
//  WhiteLabel
//
//  Created by hb on 03/09/19.
//  Copyright © 2019 hb. All rights reserved.
//


import Foundation
import UIKit
import SKPhotoBrowser

extension UIView {
    
    /// Get ParentView Controller of the Given UIView
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    
    /// Add Rounded corner
    ///
    /// - Parameter radius: Radius of the corners
    func setRoundCorner(radius:CGFloat) {
       // self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /// Add Reounded corner with shadow
    ///
    /// - Parameter cornerRe: Radius of the corners
    func setCornerRadiusAndShadow(cornerRe: CGFloat){
       // self.layer.cornerRadius = cornerRe
        self.setShadow()
    }
    
    
    //    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
    //        layer.masksToBounds = false
    //        layer.shadowColor = color.cgColor
    //        layer.shadowOpacity = opacity
    //        layer.shadowOffset = offSet
    //        layer.shadowRadius = radius
    //
    //        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    //        layer.shouldRasterize = true
    //        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    //    }
    
    /// Add shadow
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 2
    }
    
    /// Add Border to the View
    ///
    /// - Parameters:
    ///   - color: Color of the border
    ///   - size: Width of the border
    func setBorder(color:UIColor = UIColor.clear, size:CGFloat = 1) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = size
    }
    
    /// Set Rounded border along with Border Color
    ///
    /// - Parameters:
    ///   - radius: Radius of the corners
    ///   - color: Color of the border
    ///   - size: Width of the border
    func setRoundBorder(radius:CGFloat, color:UIColor = UIColor.clear, size:CGFloat = 1) {
        self.setRoundCorner(radius: radius)
        self.setBorder(color: color, size: size)
    }
    
    /// Method used to apply corner radius to speicific corners
    ///
    /// - Parameters:
    ///   - corners: Accepts the array of type UIRectCorner
    ///   - radius:Radius of the corners
    func roundCorners(corners:UIRectCorner, radius: CGFloat,bounds:CGRect = CGRect.zero) {
        
        let aApplyBound = bounds == CGRect.zero ? self.bounds : bounds
        
        let path = UIBezierPath(roundedRect:aApplyBound, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    
    
    
    /// Add Shadow to the View to particular Position
    ///
    /// - Parameter position: Accepts the enum value shadowPosition to specify the position of the shadow
    func addViewShadowAtPosition( position:shadowPosition, height :CGFloat =  3.0, color:UIColor = UIColor.lightGray)
    {
        var aRect : CGRect!
        if position == .bottom
        {
            aRect = CGRect(x: 0, y: frame.size.height/2, width: frame.size.width, height: frame.size.height/2)
        }
        else if position == .top
        {
            aRect = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height/2)
        }
        else if position == .line
        {
            aRect = CGRect(x: 0, y: frame.size.height-2, width: frame.size.width, height: 2)
        }
        else
        {
            aRect = CGRect(x: -2, y: -2, width: frame.size.width + 2, height: frame.size.height + 2)
        }
        
        let shadowPath = UIBezierPath(rect: aRect)
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 1.0
    }
    
    
    /// Add Circular shadow around view
    ///
    /// - Parameter radius: Radius of the shadow
    func addCircularShadow(_ radius:CGFloat)
    {
        let aRect = CGRect(x: 0, y: -2, width: frame.size.width + 2, height: frame.size.height + 2)
        let shadowPath = UIBezierPath(roundedRect: aRect , cornerRadius: radius)
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowPath = shadowPath.cgPath
        layer.shadowRadius = 1.0
        
    }
    
    func addOnePixelShadowWithColor( _ color : UIColor = UIColor.gray)
    {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 1.0
    }
    
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
   
    
    /// SwifterSwift: Height of view.
    var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    /// SwifterSwift: Check if view is in RTL format.
    var isRightToLeft: Bool {
        if #available(iOS 10.0, *, tvOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return false
        }
    }
    
    /// SwifterSwift: Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    /// SwifterSwift: Size of view.
    var size: CGSize {
        get {
            return frame.size
        }
        set {
            width = newValue.width
            height = newValue.height
        }
    }
    
    
    
    /// SwifterSwift: Width of view.
    var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    /// SwifterSwift: x origin of view.
    // swiftlint:disable:next identifier_name
    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    /// SwifterSwift: y origin of view.
    // swiftlint:disable:next identifier_name
    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    
    /// SwifterSwift: Recursively find the first responder.
    func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var index = 0
        repeat {
            let view = views[index]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            index += 1
        } while index < views.count
        return nil
    }
    
    /// SwifterSwift: Set some or all corners radiuses of view.
    ///
    /// - Parameters:
    ///   - corners: array of corners to change (example: [.bottomLeft, .topRight]).
    ///   - radius: radius for selected corners.
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    /// SwifterSwift: Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    /// SwifterSwift: Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /// SwifterSwift: Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// SwifterSwift: Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    /// SwifterSwift: Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    /// SwifterSwift: Remove all subviews in view.
    func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// SwifterSwift: Remove all gesture recognizers from view.
    func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }
    
    /// SwifterSwift: Attaches gesture recognizers to the view.
    ///
    /// Attaching gesture recognizers to a view defines the scope of the represented
    /// gesture, causing it to receive touches hit-tested to that view and all of its
    /// subviews. The view establishes a strong reference to the gesture recognizers.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be added to the view.
    func addGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            addGestureRecognizer(recognizer)
        }
    }
    
    /// SwifterSwift: Detaches gesture recognizers from the receiving view.
    ///
    /// This method releases gestureRecognizers in addition to detaching them from the view.
    ///
    /// - Parameter gestureRecognizers: The array of gesture recognizers to be removed from the view.
    func removeGestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]) {
        for recognizer in gestureRecognizers {
            removeGestureRecognizer(recognizer)
        }
    }
    
    
    /// SwifterSwift: Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
    
    
    /// SwifterSwift: Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..)
    @available(iOS 9, *) func addConstraints(withFormat: String, views: UIView...) {
        // https://videos.letsbuildthatapp.com/
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withFormat, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /// SwifterSwift: Anchor all sides of the view into it's superview.
    @available(iOS 9, *)
    func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let left = leftAnchor.constraint(equalTo: superview.leftAnchor)
            let right = rightAnchor.constraint(equalTo: superview.rightAnchor)
            let top = topAnchor.constraint(equalTo: superview.topAnchor)
            let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
    
    /// SwifterSwift: Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @available(iOS 9, *)
    @discardableResult
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    /// SwifterSwift: Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *)
    func anchorCenterXToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// SwifterSwift: Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *)
    func anchorCenterYToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// SwifterSwift: Anchor center X and Y into current view's superview
    @available(iOS 9, *)
    func anchorCenterSuperview() {
        // https://videos.letsbuildthatapp.com/
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    /// SwifterSwift: Search all superviews until a view with the condition is found.
    ///
    /// - Parameter predicate: predicate to evaluate on superviews.
    func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) {
            return superview
        }
        return superview?.ancestorView(where: predicate)
    }
    
    /// SwifterSwift: Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: class of the view to search.
    func ancestorView<T: UIView>(withClass name: T.Type) -> T? {
        return ancestorView(where: { $0 is T }) as? T
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

}
