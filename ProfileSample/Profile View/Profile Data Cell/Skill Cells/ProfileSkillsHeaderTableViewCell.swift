//
//  ProfileSkillsHeaderTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 15/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileSkillsHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    private var isConfigured = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    internal func configure() {
        guard isConfigured == false else {
            return
        }
        
        titleLbl.addCharacterSpacing()
    }
}
