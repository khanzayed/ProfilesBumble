//
//  ProfileView.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate {
    
    func swipingRight(_ alpha: CGFloat, distance: CGFloat)
    
    func swipingLeft(_ alpha: CGFloat, distance: CGFloat)
    
    func stopSwiping()
    
    func didEndRightSwipe(_ userObject: UserObject)
    
    func didEndSwipe(onView view: ProfileView)
    
    func hasStartedScrolling(isScrollingUp: Bool)
    
}

class ProfileView: UIView {

    @IBOutlet var profileView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    fileprivate var userImage: UIImageView!
    fileprivate var shareButton: UIButton!
    fileprivate var addToPinBox: UIButton!
    fileprivate var isScrollingUp = false
    fileprivate var isScrollingDown = false
    
    internal var delegate: ProfileViewDelegate?
    internal var userObject: UserObject! {
        didSet {
            self.setupTableView()
        }
    }
    
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
    
    deinit {
        print("Deinit called on ProfileView")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.roundCorners([.topLeft, .topRight, .bottomLeft, .bottomRight], radius: 30)
    }
    
    private func reset() {
        self.delegate?.stopSwiping()
        UIView.animate(withDuration: 0.4) {
            self.transform = CGAffineTransform.identity
            self.frame = CGRect(x: 0, y: 5, width: UIScreen.main.bounds.width,
                                height: self.superview!.bounds.height - 5.0)
            self.alpha = 1
        }
    }
    
    @objc private func panGestureRecognized(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
        let xFromCenter = self.center.x - self.superview!.center.x
        self.center = CGPoint(x: self.superview!.center.x + point.x, y: self.center.y)
        
        self.transform = CGAffineTransform(rotationAngle: xFromCenter / divisor)
        
        if xFromCenter > 0 { // Right
            self.delegate?.swipingRight(abs(xFromCenter) / self.superview!.center.x, distance: xFromCenter)
        } else {
            self.delegate?.swipingLeft(abs(xFromCenter) / self.superview!.center.x, distance: -xFromCenter)
        }
        
        switch sender.state {
        case .ended:
            if self.center.x < 50 {
                self.delegate?.didEndSwipe(onView: self)
                
                UIView.animate(withDuration: 0.4) {
                    self.center = CGPoint(x: self.center.x - UIScreen.main.bounds.width, y: self.center.y)
                    self.alpha = 0
                }
            } else if self.center.x > self.superview!.frame.width - 50 {
                self.delegate?.didEndSwipe(onView: self)
                
                UIView.animate(withDuration: 0.4, animations: {
                    self.center = CGPoint(x: self.center.x + UIScreen.main.bounds.width, y: self.center.y)
                    self.alpha = 0
                }) { (true) in
                    self.delegate?.didEndRightSwipe(self.userObject)
                    
                }
            } else {
                reset()
            }
        default:
            break
        }
    }
    
}

extension ProfileView: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func setupTableView() {
        self.profileTableView.register(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderTableViewCell")
        self.profileTableView.register(UINib(nibName: "ProfileObjectivesTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileObjectivesTableViewCell")
        self.profileTableView.register(UINib(nibName: "ProfileAboutMeTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileAboutMeTableViewCell")

        self.profileTableView.dataSource = self
        self.profileTableView.delegate = self

        DispatchQueue.main.async {
            self.profileTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return userObject.headerCellHeight
        case 1:
            return userObject.objectivesCellHeight
        case 2:
            return userObject.aboutMeCellHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileObjectivesTableViewCell") as! ProfileObjectivesTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileAboutMeTableViewCell") as! ProfileAboutMeTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
                cell!.backgroundColor = UIColor.lightGray
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

extension ProfileView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: self)
        if isScrollingUp == false, velocity.y < 0 { //up
            isScrollingUp = true
            isScrollingDown = false
            self.delegate?.hasStartedScrolling(isScrollingUp: true)
        } else if isScrollingDown == false, velocity.y > 0 { //down
            isScrollingDown = true
            isScrollingUp = false
            self.delegate?.hasStartedScrolling(isScrollingUp: false)
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

