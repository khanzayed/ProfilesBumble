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
    
    private var areCornersRounded = false
    
    static let horizontalInset: CGFloat = 12.0
    
    static let verticalInset: CGFloat = 5.0
    internal var currentIndex = 0
    
    var dataSource: ProfileCardViewDataSource? {
        didSet {
            reloadData()
        }
    }
    
    var delegate: ProfileCardViewDelegate?
    
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
    
    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
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
        
//        self.sendSubviewToBack(self.profileCardViewContainer)
    }
    
    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    /// Sets the frame of a card view provided for a given index. Applies a specific
    /// horizontal and vertical offset relative to the index in order to create an
    /// overlay stack effect on a series of cards.
    ///
    /// - Parameters:
    ///   - cardView: card view to update frame on
    ///   - index: index used to apply horizontal and vertical insets
    private func setFrame(forCardView cardView: ProfileView, atIndex index: Int) {
        if index != 0 {
            cardView.frame = CGRect(x: 40, y: 0, width: UIScreen.main.bounds.width - 80, height: self.bounds.height)
            cardView.alpha = 0.5
        }
        cardView.roundCorners([.topLeft, .topRight], radius: 30)
        cardView.lbl.text = cardView.userObject.fName
    }
    
}

// MARK: - ProfileCardViewDelegate
extension ProfileCardViewContainer: ProfileViewDelegate, ProfileCardViewDelegate {
    
    func didSelect(card: ProfileView, atIndex index: Int) {
        print("didSelect \(index)")
    }
    
    func didTap(view: ProfileView) {

    }
    
    func didBeginSwipe(onView view: ProfileView) {
        // React to Swipe Began?
    }
    
    func changeView(onView view: ProfileView) {
        
    }
    
    func didEndSwipe(onView view: ProfileView) {
        guard let dataSource = dataSource else {
            return
        }
        
        view.removeFromSuperview()
        cardViews.remove(at: 0)
        
        if remainingCards > 0 {
            let newIndex = dataSource.numberOfCards() - remainingCards

            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)

//            DispatchQueue.main.async {
//                self.cardViews[0].frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
//                self.cardViews[0].alpha = 1
//            }
            if let nextView = self.subviews.last as? ProfileView {
                
                UIView.animate(withDuration: 0.2, animations: {
                    nextView.frame = CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.bounds.height - 5.0)
                    nextView.alpha = 1
                    nextView.transform = CGAffineTransform(scaleX: 1, y: 1)

                    self.layoutIfNeeded()
                })

            }
            

            
//            // Update all existing card's frames based on new indexes, animate frame change
//            // to reveal new card from underneath the stack of existing cards.
//            for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
//                UIView.animate(withDuration: 0.2, animations: {
//                    cardView.center = self.center
//                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
//                    self.layoutIfNeeded()
//                })
//            }
        }
    }
    
}
