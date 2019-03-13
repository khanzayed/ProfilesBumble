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
    @IBOutlet weak var bottomsViewBottomConstraint: NSLayoutConstraint! //0
    @IBOutlet weak var bottomButtonsView: UIView!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var undoButton: UIButton!
    @IBOutlet weak var reachOutButton: UIButton!
    
    fileprivate var remainingCards: Int = 0
    fileprivate var displacement: CGFloat = UIScreen.main.bounds.height
    fileprivate var emptyView: UIView!
    fileprivate var gradientLayer: CAGradientLayer?
    fileprivate var divisor:CGFloat!
    
    internal var delegate: ProfileCardViewDelegate?
    internal var dataSource: ProfileCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    private var cardViews: [ProfileView] = []
    private var lastCardView: ProfileView?

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
        
        passButton.layer.cornerRadius = passButton.bounds.height / 2
        reachOutButton.layer.cornerRadius = reachOutButton.bounds.height / 2
        
        divisor = (self.bounds.height / 2) / 0.41
    }
    
    func reloadData() {
        removeAllCardViews()
        addGradientLayer()
        
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
    
    private func addGradientLayer() {
        if self.gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer!.colors = [ UIColor.white.withAlphaComponent(0.0).cgColor,
                                UIColor.white.withAlphaComponent(1.0).cgColor,
                                UIColor.white.withAlphaComponent(1.0).cgColor]
            gradientLayer!.locations = [0.0 , 1.0]
            gradientLayer!.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer!.endPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer!.frame = CGRect(x: 0.0, y: 0.0, width: self.bottomButtonsView.bounds.width, height: self.bottomButtonsView.bounds.height)
            
            self.bottomButtonsView.layer.insertSublayer(gradientLayer!, at: 0)
        }
    }
    
    private func removeAllCardViews() {
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
        
        lastCardView = nil
        cardViews = []
        
        undoButton.isEnabled = false
    }
    
    fileprivate func removeLastCard() {
        lastCardView = nil
        
        undoButton.isEnabled = false
    }
    
    fileprivate func setLastCard(withView view: ProfileView) {
        lastCardView = view
        
        undoButton.isEnabled = true
    }

    private func enableActionButtons() {
        passButton.isEnabled = true
        reachOutButton.isEnabled = true
    }
    
    private func disableActionButtons() {
        passButton.isEnabled = false
        reachOutButton.isEnabled = false
    }
    
    private func setFrame(forCardView cardView: ProfileView, atIndex index: Int) {
        if index != 0 {
            cardView.frame = CGRect(x: 10, y: 5, width: UIScreen.main.bounds.width - 20, height: self.bounds.height - 5.0)
        }
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
    
    fileprivate func handleNextCard(dataSource: ProfileCardViewDataSource) {
        cardViews.remove(at: 0)
        
        if remainingCards > 0 {
            let newIndex = dataSource.numberOfCards() - remainingCards
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
        }
        
        if cardViews.count > 0 {
            let nextView = cardViews[0]
            UIView.animate(withDuration: 0.6, animations: {
                nextView.transform = CGAffineTransform(scaleX: UIScreen.main.bounds.width / nextView.bounds.width , y: 1)
                
                self.layoutIfNeeded()
            }) { (true) in
                nextView.transform = CGAffineTransform.identity
                nextView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)

                self.enableActionButtons()
            }
        } else {
            self.enableActionButtons()
        }
        
        if cardViews.count == 1 {
            UIView.animate(withDuration: 0.2) {
                self.emptyView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
                self.emptyView.alpha = 1
                
                self.layoutIfNeeded()
            }
        }
    }
    
    private func swipeCardOnButtonTap(isSwipeRight: Bool, animationDuration: TimeInterval) {
        guard let dataSource = dataSource else {
            return
        }
        
        if cardViews.count > 0 {
            removeLastCard()
            disableActionButtons()
            
            let card = cardViews[0]
            let xFromCenter = (isSwipeRight) ? (card.center.x + displacement) : (card.center.x - displacement)
            
            UIView.animate(withDuration: animationDuration, animations: {
                card.transform = CGAffineTransform(rotationAngle: xFromCenter / self.divisor)
                card.center = CGPoint(x:xFromCenter, y: card.center.y)
            }) { (true) in
                if isSwipeRight {
                    self.delegate?.didRightSwipe(card.userObject)
                }
            }
            
            if !isSwipeRight {
                setLastCard(withView: card)
            }
            
            handleNextCard(dataSource: dataSource)
        }
    }
    
    private func handleCurrentCard() {
        if cardViews.count > 1 {
            let currentView = cardViews[1]
            UIView.animate(withDuration: 0.6, animations: {
                currentView.transform = CGAffineTransform(scaleX: (UIScreen.main.bounds.width - 20) / currentView.bounds.width , y: 1)
                
                self.layoutIfNeeded()
            }) { (true) in
                currentView.frame = CGRect(x: 10, y: 5.0, width: UIScreen.main.bounds.width - 20, height: self.bounds.height - 5.0)
            }
        }
    }
    
    private func swipeBackCardOnButtonTap(animationDuration: TimeInterval) {
        removeLastCard()
        
        let card = cardViews[0]
        
        UIView.animate(withDuration: animationDuration) {
            card.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
            card.center = CGPoint(x: self.center.x, y: card.center.y)
        }
        
        handleCurrentCard()
    }
    
    @IBAction func passButtonTapped(_ sender: UIButton) {
        swipeCardOnButtonTap(isSwipeRight: false, animationDuration: 1.0)
    }
    
    @IBAction func undoButtonTapped(_ sender: UIButton) {
        guard let _ = dataSource, let card = lastCardView else {
            return
        }
        
        cardViews.insert(card, at: 0)
        swipeBackCardOnButtonTap(animationDuration: 1.0)
    }
    
    @IBAction func reachOutButtonTapped(_ sender: UIButton) {
        swipeCardOnButtonTap(isSwipeRight: true, animationDuration: 1.0)
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
        
        if cardViews.count > 1 {
            let backViewValue = min(max(cardViews[1].bounds.width / distance, 0), 20)
            cardViews[1].transform = CGAffineTransform(scaleX: (UIScreen.main.bounds.width - backViewValue) / cardViews[1].bounds.width , y: 1)
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
        
        if cardViews.count > 1 {
            let backViewValue = min(max(cardViews[1].bounds.width / distance, 0), 20)
            cardViews[1].transform = CGAffineTransform(scaleX: (UIScreen.main.bounds.width - backViewValue) / cardViews[1].bounds.width , y: 1)
        }
    }
    
    func stopSwiping() {
        UIView.animate(withDuration: 0.3, animations: {
            self.leftImageLeadingConstraint.constant = -100
            self.rightImageLeadingConstraint.constant = -100
            
            if self.cardViews.count > 1 {
                self.cardViews[1].transform = CGAffineTransform.identity
            }
            
            self.layoutIfNeeded()
        }) { (true) in
            self.leftSwipeImageView.alpha = 0
            self.rightSwipeImageView.alpha = 0
        }
    }
    
    func didEndRightSwipe(_ userObject: UserObject) {
        self.delegate?.didRightSwipe(userObject)
    }
    
    func didEndSwipe(onView view: ProfileView) {
        guard let dataSource = dataSource else {
            return
        }
        
        removeLastCard()
        setLastCard(withView: view)
        
        stopSwiping()
        handleNextCard(dataSource: dataSource)
    }
    
    func hasStartedScrolling(isScrollingUp: Bool) {
        if isScrollingUp {
            UIView.animate(withDuration: 0.2) {
                self.bottomsViewBottomConstraint.constant = 20
                
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.bottomsViewBottomConstraint.constant = 0
                
                self.layoutIfNeeded()
            }
        }
    }
    
}
