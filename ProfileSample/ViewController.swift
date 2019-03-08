//
//  ViewController.swift
//  ProfileSample
//
//  Created by admin on 08/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cardContainer: ProfileCardViewContainer!
    var users: [UserObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardContainer = ProfileCardViewContainer(frame: CGRect(x: 0, y: 60.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 60))
    
        if let path = Bundle.main.path(forResource: "SampleExplore", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String : Any]] {
                    for object in jsonResult {
                        users.append(UserObject(details: object))
                    }
                                
                    cardContainer.dataSource = self
                    
                    view.addSubview(cardContainer)
                }
            } catch {
                // handle error
            }
        }
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
////        cardContainer.roundCorners([.topLeft, .topRight], radius: 30)
//    }

//    override func viewDidAppear(_ animated: Bool) {
//        let xValue: CGFloat = 40
//        let rect = CGRect(x: xValue, y: 60, width: UIScreen.main.bounds.width - (2 * xValue), height: 40)
//        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 20)
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = roundedRect.cgPath
//        
//        shapeLayer.strokeColor = UIColor.clear.cgColor
//        shapeLayer.fillColor = UIColor.white.cgColor
//        shapeLayer.opacity = 0.5
//        shapeLayer.lineWidth = 1.0
//        
//        // add the new layer to our custom view
//        self.view.layer.insertSublayer(shapeLayer, below: cardContainer.layer)
//    }
}

extension ViewController: ProfileCardViewDataSource {
    
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
    
}
