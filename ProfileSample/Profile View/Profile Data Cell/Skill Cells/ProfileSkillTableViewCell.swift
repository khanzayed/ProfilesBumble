//
//  ProfileSkillTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 15/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileSkillTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var blueDotView: UIView!
    @IBOutlet weak var applaudsLbl: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    internal var skillIndex: SkillIndex!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        blueDotView.layer.cornerRadius = blueDotView.bounds.height / 2
    }
    
    internal func configure(withUser skill: Skill, index: SkillIndex, isLineHiddden: Bool) {
        nameLbl.text = skill.skillName
        lineView.isHidden = isLineHiddden
        skillIndex = index
        
        applaudsLbl.isHidden = !skill.isSelected
        blueDotView.isHidden = !skill.isSelected
    }

}
