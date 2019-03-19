//
//  ProfileHeaderTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 13/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var addToPinBoxButton: UIButton!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var bluetiePinLbl: UILabel!
    @IBOutlet weak var bluetiePinView: UIView!
    
    private var isConfigured = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
        shareButton.layer.cornerRadius = shareButton.bounds.height / 2
        addToPinBoxButton.layer.cornerRadius = addToPinBoxButton.bounds.height / 2
        bluetiePinView.layer.cornerRadius = bluetiePinView.bounds.height / 2
    }
    
    internal func configure(withUser userObject: UserObject) {
        guard isConfigured == false else {
            return
        }
        isConfigured = true
        
        userNameLbl.text = userObject.fullName ?? ""
        userNameLbl.addCharacterSpacing(kernValue: 0.7)
        
        designationLbl.text = userObject.currentDesignation ?? ""
        companyLbl.text = userObject.currentCompany ?? ""
        cityLbl.text = "Bengaluru"
        
        bluetiePinLbl.text = userObject.btPin ?? ""
        bluetiePinLbl.addCharacterSpacing(kernValue: 1.5)
    }
    
}
