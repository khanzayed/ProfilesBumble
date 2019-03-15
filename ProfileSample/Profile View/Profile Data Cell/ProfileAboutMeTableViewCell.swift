//
//  ProfileAboutMeTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 14/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileAboutMeTableViewCell: UITableViewCell {

    @IBOutlet weak var aboutMeLbl: UILabel!
    
    private var isConfigured = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    internal func configure(withUser userObject: UserObject) {
        guard isConfigured == false else {
            return
        }
        isConfigured = true
        
        self.aboutMeLbl.attributedText = userObject.aboutMeAttributedString
    }
    
}
