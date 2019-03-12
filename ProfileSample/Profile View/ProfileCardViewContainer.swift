//
//  ProfileCardViewContainer.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileCardViewContainer: UIView {
    
    @IBOutlet var profileCardViewContainer: UIView!
    
    var delegate: ProfileCardViewDelegate?
    
    private var areCornersRounded = false
    
    static let horizontalInset: CGFloat = 12.0
    
    static let verticalInset: CGFloat = 5.0
    internal var currentIndex = 0
    
    var dataSource: ProfileCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    private var cardViews: [ProfileView] = []
    
    private var visibleCardViews: [ProfileView] {
        return subviews as? [ProfileView] ?? []
    }
    
    fileprivate var remainingCards: Int = 0
    
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
        
        if let emptyView = dataSource.viewForEmptyCards() {
//            addEdgeConstrainedSubView(view: emptyView)
        }
        
        setNeedsLayout()
    }
    
    private func addCardView(cardView: ProfileView, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 1)
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
//            cardView.alpha = 0.5
        }
        cardView.roundCorners([.topLeft, .topRight], radius: 10)
        cardView.lbl.text = cardView.userObject.fName
    }
    
}

// MARK: - ProfileCardViewDelegate
extension ProfileCardViewContainer: ProfileViewDelegate {
    
    func didBeginSwipe(swipeValue: CGFloat, alpha: CGFloat) {
        guard let _ = dataSource else {
            return
        }
    
        if self.subviews.count > 1 {
            let newIndex = self.subviews.count - 2
            
            if let nextView = self.subviews[newIndex] as? ProfileView {
                nextView.alpha = alpha
                let xValue = max(0, nextView.frame.origin.x - swipeValue)
                let yValue = min(UIScreen.main.bounds.width, nextView.bounds.width + swipeValue)
                
                let frame = CGRect(x: xValue, y: nextView.frame.origin.y, width: yValue, height: nextView.bounds.height)
                nextView.frame = frame
            }
        }
    }
    
    func swipingLeft(_ alpha: CGFloat, distance: CGFloat) {
        self.delegate?.swipingLeft(alpha, distance: distance)
    }
    
    func swipingRight(_ alpha: CGFloat, distance: CGFloat) {
        self.delegate?.swipingRight(alpha, distance: distance)
    }
    
    func stopSwiping() {
        self.delegate?.stopSwiping()
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
        
        self.delegate?.stopSwiping()
        
        if remainingCards > 0 {
            let newIndex = dataSource.numberOfCards() - remainingCards

            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)

            if let nextView = self.subviews.last as? ProfileView {
                UIView.animate(withDuration: 0.2, animations: {
                    nextView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
                    nextView.alpha = 1
                    
                    self.layoutIfNeeded()
                }) { (true) in
//                    if self.subviews.count > 1 {
//                        let newIndex = self.subviews.count - 2
//                        
//                        if let nextView = self.subviews[newIndex] as? ProfileView {
//                            nextView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
//                            nextView.alpha = 1.0
//                        }
//                    }
                }
            }
        }
    }
    
}
