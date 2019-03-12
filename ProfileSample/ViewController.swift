//
//  ViewController.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftSwipeImageView: UIImageView!
    @IBOutlet weak var rightSwipeImageView: UIImageView!
    @IBOutlet weak var leftImageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightImageLeadingConstraint: NSLayoutConstraint!
    
    var cardContainer: ProfileCardViewContainer!
    var users: [UserObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardContainer = ProfileCardViewContainer(frame: CGRect(x: 0, y: 60.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 60))
        cardContainer.delegate = self
        
        if let path = Bundle.main.path(forResource: "SampleExplore", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String : Any]] {
                    for object in jsonResult {
                        users.append(UserObject(details: object))
                    }
                                
                    cardContainer.dataSource = self
                    
                    view.addSubview(cardContainer)
                    view.sendSubviewToBack(cardContainer)
                }
            } catch {
                // handle error
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let xValue: CGFloat = 20
        let rect = CGRect(x: xValue, y: 60, width: UIScreen.main.bounds.width - (2 * xValue), height: 40)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 20)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = roundedRect.cgPath
        
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.opacity = 0.5
        shapeLayer.lineWidth = 1.0
        
        // add the new layer to our custom view
        self.view.layer.insertSublayer(shapeLayer, below: cardContainer.layer)
    }
    
}

extension ViewController: ProfileCardViewDataSource, ProfileCardViewDelegate {
    
    func numberOfCards() -> Int {
        return users.count
    }
    
    func card(forItemAtIndex index: Int) -> ProfileView {
        let cardView = ProfileView(frame: CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.cardContainer.bounds.height - 5.0))
        cardView.userObject = users[index]
        
        return cardView
    }
    
    func viewForEmptyCards() -> UIView? {
        return nil
    }
    
    func swipingRight(_ alpha: CGFloat, distance: CGFloat) {
        resetLeftSwipeIcon()
        
        rightSwipeImageView.alpha = alpha
        
        let scale = min(alpha + 0.4, 1)
        rightSwipeImageView.transform = CGAffineTransform(scaleX: scale , y: scale)
        
        if rightImageLeadingConstraint.constant <= 30 {
            let value = min(distance / 10, 30)
            rightImageLeadingConstraint.constant += value
        }
    }
    
    func swipingLeft(_ alpha: CGFloat, distance: CGFloat) {
        resetRightSwipeIcon()
        
        leftSwipeImageView.alpha = alpha
        
        let scale = min(alpha + 0.4, 1)
        leftSwipeImageView.transform = CGAffineTransform(scaleX: scale , y: scale)
        
        if leftImageLeadingConstraint.constant <= 30 {
            let value = min(distance / 10, 30)
            leftImageLeadingConstraint.constant += value
        }
    }
    
    private func resetRightSwipeIcon() {
        if self.rightImageLeadingConstraint.constant > -100 {
           self.rightImageLeadingConstraint.constant = -100
        }
    }
    
    private func resetLeftSwipeIcon() {
        if self.leftImageLeadingConstraint.constant > -100 {
            self.leftImageLeadingConstraint.constant = -100
        }
    }
    
    func stopSwiping() {
        UIView.animate(withDuration: 0.3, animations: {
            self.leftImageLeadingConstraint.constant = -100
            self.rightImageLeadingConstraint.constant = -100
            
            self.view.layoutIfNeeded()
        }) { (true) in
            self.leftSwipeImageView.alpha = 0
            self.rightSwipeImageView.alpha = 0
        }
    }
    
    func didRightSwipe(_ userObject: UserObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RightSwipeViewController") as! RightSwipeViewController
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
