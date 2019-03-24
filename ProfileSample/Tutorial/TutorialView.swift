//
//  TutorialView.swift
//  ProfileSample
//
//  Created by Faraz on 24/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

struct TutorialContentAttributes {
    
    var title: String!
    var subtitle: String!
    var contentOffset: CGFloat!
    var buttonText: String!
    
    init(title: String, subtitle: String, buttonText: String, contentOffset: CGFloat) {
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
        self.contentOffset = contentOffset
    }
    
}

enum TutorialPoints: Int {
    case HomeScreen = 0
    case ObjectivesCell
    case AppluadsCell
    case ReachOutButton
    case PassButton
    case UndoButton
}

class TutorialView: UIView {
    
    @IBOutlet var tutorialView: UIView!
    @IBOutlet var blackBackground: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var blackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var contentScrollView: UIScrollView!
    @IBOutlet weak var ctaButton: UIButton!
    
    var cardContainer: ProfileCardViewContainer!
    var users = [UserObject]()
    var isAnimating = false
    
    let contents : [TutorialContentAttributes] = [
        TutorialContentAttributes(title: "Home Screen",
                                  subtitle: "On the Home screen, you will see the profiles of professionals whose objectives match with yours at that moment.",
                                  buttonText: "Start", contentOffset: 0),
        TutorialContentAttributes(title: "Networking Objectives",
                                  subtitle: "The blue tick(s) indicates the Objectives of the professionals which complement your current networking objectives.",
                                  buttonText: "Next", contentOffset: 350),
        TutorialContentAttributes(title: "Applauded Fortes",
                                  subtitle: "The blue dot indicates that your fortes have been applauded. The number denotes the number of professionals who have applauded you.",
                                  buttonText: "Next", contentOffset: 900),
        TutorialContentAttributes(title: "Reach Out",
                                  subtitle: "Swipe right or tap here to Reach Out to the professional",
                                  buttonText: "Next", contentOffset: 0),
        TutorialContentAttributes(title: "Pass Profile",
                                  subtitle: "Swipe left or tap here to pass the profile",
                                  buttonText: "Next", contentOffset: 0),
        TutorialContentAttributes(title: "Undo Profile",
                                  subtitle: "Tap here to recall the last passed profile",
                                  buttonText: "Next", contentOffset: 0)
        
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("TutorialView", owner: self, options: nil)
        addSubview(tutorialView)
        tutorialView.frame = self.bounds
        tutorialView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        tutorialView.backgroundColor = .clear
        
        ctaButton.layer.cornerRadius = ctaButton.bounds.height / 2
        setupProfileView()
    }
    
    deinit {
        print("Deinit called on TutorialView")
    }
    
    private func setupProfileView() {
        cardContainer = ProfileCardViewContainer(frame: CGRect(x: 0, y: 75.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 60))
        
        if let path = Bundle.main.path(forResource: "SampleThreeUsers", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String : Any]] {
                    for object in jsonResult {
                        users.append(UserObject(details: object))
                    }
                    
                    cardContainer.dataSource = self
                    tutorialView.insertSubview(cardContainer, belowSubview: blackBackground)
                    cardContainer.undoButton.isSelected = true
                    
                    setupContentView()
                }
            } catch {
                // handle error
            }
        }

    }
    
    private func setupContentView() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
    
        let subtitleAttributes: [NSAttributedString.Key:Any] = [NSAttributedString.Key.paragraphStyle : paragraphStyle,
                                                                NSAttributedString.Key.font: UIFont.ProximaNovaSemiBold(fontSize: 14)]
        
        var xValue: CGFloat = 0
        for content in contents {
            let contentView = UIView(frame: CGRect(x: xValue, y: 0,
                                                   width: UIScreen.main.bounds.width, height: 153))
            contentView.backgroundColor = .clear
            
            let titleLbl = UILabel(frame: CGRect(x: 20, y: 25, width: UIScreen.main.bounds.width - 40, height: 25))
            titleLbl.textColor = .white
            titleLbl.font = UIFont.ProximaNovaBold(fontSize: 18)
            titleLbl.text = content.title
            
            let subtitleLbl = UILabel(frame: CGRect(x: 20, y: 55, width: UIScreen.main.bounds.width - 40, height: 90))
            subtitleLbl.textColor = .white
            subtitleLbl.numberOfLines = 0
            subtitleLbl.attributedText = NSAttributedString(string: content.subtitle, attributes: subtitleAttributes)
            subtitleLbl.sizeToFit()
            
            contentView.addSubview(titleLbl)
            contentView.addSubview(subtitleLbl)
            
            
            xValue += UIScreen.main.bounds.width
            
            contentScrollView.addSubview(contentView)
        }
        
        contentScrollView.contentSize = CGSize(width: xValue, height: 153)
        showBlackBackground()
    }
    
    private func showBlackBackground() {
        UIView.animate(withDuration: 0.4, delay: 0.5, options: [], animations: {
            self.blackBackground.alpha = 0.95
        }, completion: nil)
    }

    @IBAction func ctaButtonTapped(_ sender: UIButton) {
        if isAnimating == true {
            return
        }
        
        let nextTag = sender.tag + 1
        self.pageControl.currentPage = nextTag - 1
        
        if nextTag < contents.count - 1 {
            isAnimating = true
            UIView.animate(withDuration: 0.4, animations: {
                let xValue = CGFloat(nextTag) * UIScreen.main.bounds.width
                self.contentScrollView.contentOffset = CGPoint(x: xValue, y: 0)
            }) { (true) in
                let content = self.contents[nextTag]
                if nextTag == 1 {
                    self.cardContainer.scrollToOffset(CGPoint(x: 0, y: content.contentOffset))
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        self.blackViewTopConstraint.constant = UIScreen.main.bounds.height - 232
                        self.layoutIfNeeded()
                    }, completion: { (true) in
                        self.cardContainer.animateTickImageForMatchingObjectives {
                            self.isAnimating = false
                        }
                    })
                } else if nextTag == 2 {
                    self.cardContainer.scrollToOffset(CGPoint(x: 0, y: content.contentOffset))
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.cardContainer.tapOnCell()
                    })
                    
                    self.isAnimating = false
                } else if nextTag == 3 {
                    UIView.animate(withDuration: 0.4, animations: {
                        self.cardContainer.scrollToOffset(CGPoint(x: 0, y: 1500))
                        self.cardContainer.frame.origin.y -= 220
                    }) { (true) in
                        self.cardContainer.animateReachOutButton {
                            self.isAnimating = false
                        }
                    }
                } else if nextTag == 4 {
                    self.cardContainer.animatePassButton {
                        self.isAnimating = false
                    }
                }
            }
            
            sender.tag = nextTag
            sender.setTitle("Next", for: .normal)
        } else if nextTag == contents.count - 1 {
            isAnimating = true
            self.cardContainer.animateUndoButton {
                self.isAnimating = false
            }
            
            sender.tag = nextTag
            sender.setTitle("Done", for: .normal)
        }
        
    }
    
}

extension TutorialView: ProfileCardViewDataSource {
    
    func numberOfCards() -> Int {
        return 1
    }
    
    func card(forItemAtIndex index: Int) -> ProfileView {
        let cardView = ProfileView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.cardContainer.bounds.height))
        cardView.userObject = users[index]
        
        return cardView
    }
    
    func viewForEmptyCards() -> UIView {
        return UIView()
    }
    
}
