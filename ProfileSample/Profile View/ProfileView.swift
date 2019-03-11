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
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    private func reset() {
        UIView.animate(withDuration: 0.4) {
            self.frame = CGRect(x: 0, y: 5, width: self.superview!.bounds.width, height: self.superview!.bounds.height - 5.0)
            self.alpha = 1
        }
    }
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
//        let xFromCenter = abs(self.center.x - self.superview!.center.x) / 2
        self.center = CGPoint(x: self.superview!.center.x + point.x, y: self.superview!.center.y) // + point.y)
        
//        let alpha = min(abs(xFromCenter) / alphaBaseValue, 1)
//        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
//        if xFromCenter > 0 { // Right
//            acceptImageView.image = UIImage(named: "accept")
//        } else {
//            acceptImageView.image = UIImage(named: "accept")
//        }
        
//        acceptImageView.alpha = abs(xFromCenter) / view.center.x
        
//        panGestureTranslation = gestureRecognizer.translation(in: self)
//        print(xFromCenter)
//        self.delegate?.didBeginSwipe(swipeValue: xFromCenter / 10, alpha: alpha)
        
        switch sender.state {
        case .ended:
        if self.center.x < 100 || self.center.x > self.superview!.frame.width - 100 {
            UIView.animate(withDuration: 0.4, animations: {
                self.center = CGPoint(x: self.center.x - 200, y: self.center.y + 150)
                self.alpha = 0
            }) { (true) in
                self.delegate?.didEndSwipe(onView: self)
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

