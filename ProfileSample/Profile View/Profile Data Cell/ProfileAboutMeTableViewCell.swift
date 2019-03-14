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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
 
    internal func configure(withUser userObject: UserObject) {
        self.aboutMeLbl.setText(text: "I am deeply passionate about an interactive designs and layouts, and am always looking to gain a better understanding of the ever evolving technology through which I can make aesthetically pleasing as well as functionally sound designs.", withLineSpacing: 10.0, style: .left)
    }
    
}
