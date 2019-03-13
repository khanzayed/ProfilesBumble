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
//        setupHeaderView()
        self.profileTableView.register(UINib(nibName: "ProfileHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderTableViewCell")

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
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 350
        default:
            return 350
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 10:
            var cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
            
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "CellIdentifier")
                cell!.backgroundColor = UIColor.lightGray
            }
            
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderTableViewCell") as! ProfileHeaderTableViewCell
            cell.configure(withUser: userObject)
            
            return cell
        }
    }
    
    private func setupHeaderView()  {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 410))
        headerView.backgroundColor = .white

        let imageSize: CGFloat = 105
        let xImageFrame: CGFloat = (headerView.bounds.width - imageSize) / 2
        userImage = UIImageView(frame: CGRect(x: xImageFrame, y: 15, width: imageSize, height: imageSize))
        userImage.layer.cornerRadius = 52
        userImage.image = UIImage(named: "ic_test_user_1.png")
        userImage.clipsToBounds = true
        userImage.contentMode = .scaleAspectFill
        headerView.addSubview(userImage)

//        #EEEEEE
        let buttonSize: CGFloat = 40
        shareButton = UIButton(frame: CGRect(x: xImageFrame - buttonSize - 30, y: 80, width: buttonSize, height: buttonSize))
        shareButton.backgroundColor = UIColor(named: Colors.App_Light_Grey)
        shareButton.layer.cornerRadius =  20
        shareButton.setTitle("S", for: .normal)
        headerView.addSubview(shareButton)

        addToPinBox = UIButton(frame: CGRect(x: xImageFrame + imageSize + 30, y: 80, width: buttonSize, height: buttonSize))
        addToPinBox.backgroundColor = UIColor(named: Colors.App_Light_Grey)
        addToPinBox.layer.cornerRadius =  20
        addToPinBox.setTitle("+", for: .normal)
        headerView.addSubview(addToPinBox)

        let userNameLbl = UILabel(frame: CGRect(x: 20, y: 145, width: self.bounds.width - 40, height: 25))
        userNameLbl.font = UIFont.ProximaNovaExtrabold(fontSize: 20)
        userNameLbl.textColor = UIColor(named: Colors.App_Black)
        userNameLbl.textAlignment = .center
        userNameLbl.text = userObject.fullName
        headerView.addSubview(userNameLbl)

        let designationLbl = UILabel(frame: CGRect(x: 20, y: 175, width: self.bounds.width - 40, height: 20))
        designationLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
        designationLbl.textColor = UIColor(named: Colors.App_Grey)
        designationLbl.textAlignment = .center
        designationLbl.text = userObject.currentDesignation ?? ""
        headerView.addSubview(designationLbl)

        let companyNameLbl = UILabel(frame: CGRect(x: 20, y: 200, width: self.bounds.width - 40, height: 20))
        companyNameLbl.font = UIFont.ProximaNovaRegular(fontSize: 14)
        companyNameLbl.textColor = UIColor(named: Colors.App_Grey)
        companyNameLbl.textAlignment = .center
        companyNameLbl.text = userObject.currentCompany ?? ""
        headerView.addSubview(companyNameLbl)

        let locationLbl = UILabel(frame: CGRect(x: 20, y: 230, width: self.bounds.width - 40, height: 20))
        locationLbl.font = UIFont.ProximaNovaRegular(fontSize: 12)
        locationLbl.textColor = UIColor(named: Colors.App_Grey)
        locationLbl.textAlignment = .center
        locationLbl.text = "Bengaluru"
        headerView.addSubview(locationLbl)

        let pinViewSize: CGFloat = 185
        let blueTiePinView = UIView(frame: CGRect(x: (headerView.bounds.width - pinViewSize) / 2, y: 265, width: pinViewSize, height: 50))
        blueTiePinView.backgroundColor = UIColor(named: Colors.Primary_Blue)
        blueTiePinView.clipsToBounds = true
        blueTiePinView.layer.cornerRadius = 25
        headerView.addSubview(blueTiePinView)

        profileTableView.tableHeaderView = headerView
        
        headerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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

