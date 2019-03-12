//
//  ProfileView.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileView: UIView {

    @IBOutlet var profileView: UIView!
    
    @IBOutlet weak var lbl: UILabel!
    
    internal var delegate: ProfileViewDelegate?
    internal var userObject: UserObject!
    
    private var panGestureRecognizer: UIPanGestureRecognizer?
    
    private var panGestureTranslation: CGPoint = .zero
    private var alphaBaseValue: CGFloat = UIScreen.main.bounds.width / 4
    
    var divisor : CGFloat!
    var top : CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    deinit {
        print("Deinit")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileView", owner: self, options: nil)
        addSubview(profileView)
        profileView.frame = self.bounds
        profileView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ProfileView.panGestureRecognized(_:)))
        self.panGestureRecognizer = panGestureRecognizer
        profileView.addGestureRecognizer(panGestureRecognizer)
        
        divisor = (self.bounds.height / 2) / 0.61
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    private func reset() {
        self.delegate?.stopSwiping()
        UIView.animate(withDuration: 0.4, animations: {
            self.transform = CGAffineTransform.identity
            self.frame = CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width,
                                height: self.superview!.bounds.height - 5.0)
            self.alpha = 1
        }) { (true) in
            
        }
    }
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
        let xFromCenter = self.center.x - self.superview!.center.x
        self.center = CGPoint(x: self.superview!.center.x + point.x, y: self.center.y)// superview!.center.y) // + point.y)
        
//        let alpha = min(abs(xFromCenter) / alphaBaseValue, 1)
//        let scale = min(100/abs(xFromCenter), 1)
        self.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 { // Right
            self.delegate?.swipingRight(abs(xFromCenter) / self.superview!.center.x, distance: xFromCenter)
        } else {
            self.delegate?.swipingLeft(abs(xFromCenter) / self.superview!.center.x, distance: -xFromCenter)
        }
        
//        panGestureTranslation = gestureRecognizer.translation(in: self)
//        print(xFromCenter)
//        self.delegate?.didBeginSwipe(swipeValue: xFromCenter / 10, alpha: alpha)
        
        switch sender.state {
        case .ended:
            if self.center.x < 50 {
                self.delegate?.didEndSwipe(onView: self)
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.center = CGPoint(x: self.center.x - UIScreen.main.bounds.width, y: self.center.y)
                    self.alpha = 0
                }) { (true) in
                    
                }
            } else if self.center.x > self.superview!.frame.width - 50 {
                self.delegate?.didEndSwipe(onView: self)
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.center = CGPoint(x: self.center.x + UIScreen.main.bounds.width, y: self.center.y)
                    self.alpha = 0
                }) { (true) in
                    self.delegate?.didRightSwipe(self.userObject)
                    
                }
            } else {
                reset()
            }
        default:
            break
        }
    }
    
}


extension UIView {
    
    internal func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.clipsToBounds = false
        
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = self.bounds
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}

