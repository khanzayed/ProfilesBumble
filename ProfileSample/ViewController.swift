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
    var shapeLayer: CAShapeLayer!
    
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
        
}

extension ViewController: ProfileCardViewDataSource {
    
    func superView() -> UIView {
        return self.view
    }
    
    func numberOfCards() -> Int {
        return users.count
    }
    
    func card(forItemAtIndex index: Int) -> ProfileView {
        let cardView = ProfileView(frame: CGRect(x: 0, y: 5.0, width: UIScreen.main.bounds.width, height: self.cardContainer.bounds.height - 5.0))
        cardView.userObject = users[index]
        
        return cardView
    }
    
    func viewForEmptyCards() -> UIView {
        let emptyView = EmptyView(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 40, height: self.cardContainer.bounds.height))
        emptyView.alpha = 0.5
        
        return emptyView
    }
    
}

extension ViewController: ProfileCardViewDelegate {
    
    func didRightSwipe(_ userObject: UserObject) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RightSwipeViewController") as! RightSwipeViewController
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
