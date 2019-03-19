//
//  ProfileAchievementsTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 15/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileAchievementsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var isConfigured = false
    private var scrollViewHeight: CGFloat = 275
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    internal func configure(withUser userObject: UserObject) {
        guard isConfigured == false else {
            return
        }
        isConfigured = true
        
        titleLbl.addCharacterSpacing()
        
        var contentWidth: CGFloat = 195
        
        var i = 0
        for achievement in userObject.achievements {
            let achievementView = UIView(frame: CGRect(x: contentWidth, y: 0, width: 300, height: scrollViewHeight))
            achievementView.backgroundColor = .white
            achievementView.layer.cornerRadius = 15.0
            achievementView.backgroundColor = (i % 2) == 0 ? UIColor(named: Colors.App_Light_Grey) : UIColor.white
            
            let lbl = UILabel(frame: CGRect(x: 30, y: 30, width: 300 - 60, height: scrollViewHeight - 60))
            lbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            lbl.textColor = UIColor(named: Colors.App_Black)
            lbl.numberOfLines = 10
            lbl.setText(text: achievement.name ?? "", withLineSpacing: 5.0, style: .left)
            
            achievementView.addSubview(lbl)
            
            scrollView.addSubview(achievementView)
            
            contentWidth += 300
            i += 1
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollViewHeight)
    }
    
}
