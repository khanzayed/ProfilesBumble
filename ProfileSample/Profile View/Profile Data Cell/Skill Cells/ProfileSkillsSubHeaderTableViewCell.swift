//
//  ProfileSkillsSubHeaderTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 15/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileSkillsSubHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    internal func configure(category skillsCategory: SkillsCategoryModel) {
        nameLbl.text = skillsCategory.name
        nameLbl.textColor = UIColor(rgba: skillsCategory.colorCode!)
    }

}
