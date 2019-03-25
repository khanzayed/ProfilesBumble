//
//  ProfileWorkExpTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 14/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileWorkExpTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var workExpsListView: UIView!
    
    private var isConfigured = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    internal func configure(withUser userObject: UserObject) {
        guard isConfigured == false else {
            return
        }
        isConfigured = true
        
        titleLbl.addCharacterSpacing()
        
        var yView: CGFloat = 0
        for work in userObject.workDetails {
            let workView = UIView(frame: CGRect(x: 0, y: yView, width: workExpsListView.bounds.width, height: work.height))
            workView.backgroundColor = .clear
            workView.translatesAutoresizingMaskIntoConstraints = false
            workExpsListView.addSubview(workView)
            
            NSLayoutConstraint.activate([
                workView.heightAnchor.constraint(equalToConstant: work.height),
                workView.leadingAnchor.constraint(equalTo: workExpsListView.leadingAnchor, constant: 0),
                workView.trailingAnchor.constraint(equalTo: workExpsListView.trailingAnchor, constant: 0),
                workView.topAnchor.constraint(equalTo: workExpsListView.topAnchor, constant: yView)
                ])
            
            var yLabel:CGFloat = 15
            let designationLbl = UILabel(frame: CGRect(x: 0, y: yLabel, width: workExpsListView.bounds.width, height: work.titleHeight))
            designationLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            designationLbl.textColor = UIColor(named: Colors.App_Black)
            designationLbl.text = work.designation
            designationLbl.numberOfLines = 3
            
            workView.addSubview(designationLbl)
            
            NSLayoutConstraint.activate([
                designationLbl.heightAnchor.constraint(equalToConstant: work.titleHeight),
                designationLbl.widthAnchor.constraint(equalToConstant: workExpsListView.bounds.width),
                designationLbl.leadingAnchor.constraint(equalTo: workView.leadingAnchor, constant: 0),
                designationLbl.topAnchor.constraint(equalTo: workView.topAnchor, constant: yLabel)
                ])
            
            yLabel += (work.titleHeight + 5)
            let companyLbl = UILabel(frame: CGRect(x: 0, y: yLabel, width: workExpsListView.bounds.width, height: 20))
            companyLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            companyLbl.textColor = UIColor(named: Colors.Secondary_Black)
            companyLbl.text = work.companyName
            companyLbl.numberOfLines = 1
            
            workView.addSubview(companyLbl)
            
            NSLayoutConstraint.activate([
                companyLbl.heightAnchor.constraint(equalToConstant: 20),
                companyLbl.widthAnchor.constraint(equalToConstant: workExpsListView.bounds.width),
                companyLbl.leadingAnchor.constraint(equalTo: workView.leadingAnchor, constant: 0),
                companyLbl.topAnchor.constraint(equalTo: workView.topAnchor, constant: yLabel)
                ])
            
            yLabel += (20 + 10)
            let durationLbl = UILabel(frame: CGRect(x: 0, y: yLabel, width: workExpsListView.bounds.width, height: 20))
            durationLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            durationLbl.textColor = UIColor(named: Colors.Secondary_Black)
            durationLbl.text = "Feb | 2010 - Jan | 2012" //FIXME: change to dynamic
            durationLbl.numberOfLines = 1
            
            workView.addSubview(durationLbl)
            
            NSLayoutConstraint.activate([
                durationLbl.heightAnchor.constraint(equalToConstant: 20),
                durationLbl.widthAnchor.constraint(equalToConstant: workExpsListView.bounds.width),
                durationLbl.leadingAnchor.constraint(equalTo: workView.leadingAnchor, constant: 0),
                durationLbl.topAnchor.constraint(equalTo: workView.topAnchor, constant: yLabel)
                ])
            
            yView += work.height
        }
    }

}
