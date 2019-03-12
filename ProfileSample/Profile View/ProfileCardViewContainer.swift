//
//  ProfileCardViewContainer.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

protocol ProfileCardViewDataSource {
    
    func numberOfCards() -> Int
    
    func superView() -> UIView
    
    func card(forItemAtIndex index: Int) -> ProfileView
    
    func viewForEmptyCards() -> UIView
    
}

protocol ProfileCardViewDelegate {
    
    func didRightSwipe(_ userObject: UserObject)
    
}


class ProfileCardViewContainer: UIView {
    
    @IBOutlet var profileCardViewContainer: UIView!
    @IBOutlet weak var leftSwipeImageView: UIImageView!
    @IBOutlet weak var rightSwipeImageView: UIImageView!
    @IBOutlet weak var leftImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageLeadingConstraint: NSLayoutConstraint!
    
    fileprivate var shapeLayer: CAShapeLayer!
    fileprivate var remainingCards: Int = 0
    fileprivate var emptyView: UIView!
    
    internal var delegate: ProfileCardViewDelegate?
    internal var currentIndex = 0
    internal var dataSource: ProfileCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    private var cardViews: [ProfileView] = []
    private var visibleCardViews: [ProfileView] {
        return subviews as? [ProfileView] ?? []
    }
    
    static let numberOfVisibleCards: Int = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileCardViewContainer", owner: self, options: nil)
        addSubview(profileCardViewContainer)
        profileCardViewContainer.frame = self.bounds
        profileCardViewContainer.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        profileCardViewContainer.layer.masksToBounds = false
        
        setupStackLayer()
    }
    
    private func setupStackLayer() {
        let xValue: CGFloat = 20
        let rect = CGRect(x: xValue, y: 60, width: UIScreen.main.bounds.width - (2 * xValue), height: 40)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 20)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = roundedRect.cgPath
        
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.opacity = 0.5
        shapeLayer.lineWidth = 1.0
    }
    
    func reloadData() {
        removeAllCardViews()
        
        guard let dataSource = dataSource else {
            return
        }
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, ProfileCardViewContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }
    
        emptyView = dataSource.viewForEmptyCards()
        insertSubview(self.emptyView, at: 0)
        
        setNeedsLayout()
    }
    
    private func addCardView(cardView: ProfileView, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        profileCardViewContainer.insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }

    private func setFrame(forCardView cardView: ProfileView, atIndex index: Int) {
        if index != 0 {
            cardView.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width - 20, height: self.bounds.height - 5.0)
        }
        
        cardView.lbl.text = cardView.userObject.fName
    }
    
    fileprivate func resetRightSwipeIcon() {
        if self.rightImageLeadingConstraint.constant > -100 {
            self.rightImageLeadingConstraint.constant = -100
        }
    }
    
    fileprivate func resetLeftSwipeIcon() {
        if self.leftImageLeadingConstraint.constant > -100 {
            self.leftImageLeadingConstraint.constant = -100
        }
    }
    
}

// MARK: - ProfileCardViewDelegate
extension ProfileCardViewContainer: ProfileViewDelegate {
    
    func swipingRight(_ alpha: CGFloat, distance: CGFloat) {
        resetLeftSwipeIcon()

        rightSwipeImageView.alpha = alpha

        let scale = min(alpha + 0.6, 1)
        rightSwipeImageView.transform = CGAffineTransform(scaleX: scale , y: scale)

        if rightImageLeadingConstraint.constant <= 30 {
            let value = min(distance / 10, 30)
            rightImageLeadingConstraint.constant += value
        }
    }
    
    func swipingLeft(_ alpha: CGFloat, distance: CGFloat) {
        resetRightSwipeIcon()
        
        leftSwipeImageView.alpha = alpha
        
        let scale = min(alpha + 0.6, 1)
        leftSwipeImageView.transform = CGAffineTransform(scaleX: scale , y: scale)
        
        if leftImageLeadingConstraint.constant <= 30 {
            let value = min(distance / 10, 30)
            leftImageLeadingConstraint.constant += value
        }
    }
    
    func stopSwiping() {
        UIView.animate(withDuration: 0.3, animations: {
            self.leftImageLeadingConstraint.constant = -100
            self.rightImageLeadingConstraint.constant = -100
            
            self.layoutIfNeeded()
        }) { (true) in
            self.leftSwipeImageView.alpha = 0
            self.rightSwipeImageView.alpha = 0
        }
    }
    
    func didRightSwipe(_ userObject: UserObject) {
        self.delegate?.didRightSwipe(userObject)
    }
    
    func didEndSwipe(onView view: ProfileView) {
        guard let dataSource = dataSource else {
            return
        }
        
        view.removeFromSuperview()
        cardViews.remove(at: 0)
        
        stopSwiping()
        
        if remainingCards > 0 {
            let newIndex = dataSource.numberOfCards() - remainingCards

            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
        }
        
        if cardViews.count > 0 {
            let nextView = cardViews[0]
            UIView.animate(withDuration: 0.2) {
                nextView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
                nextView.alpha = 1
                
                self.layoutIfNeeded()
            }
        }
        
        if cardViews.count == 1 {
            UIView.animate(withDuration: 0.2) {
                self.emptyView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
                self.emptyView.alpha = 1
                
                self.layoutIfNeeded()
            }
        }
    }
    
}
