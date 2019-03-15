//
//  ProfileEducationDetailsTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 15/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileEducationDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var educationDetailsListView: UIView!
    
    private var isConfigured = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    internal func configure(withUser userObject: UserObject) {
        guard isConfigured == false else {
            return
        }
        isConfigured = true
        
        var yView: CGFloat = 0
        
        for education in userObject.eduDetails {
            let educationView = UIView(frame: CGRect(x: 0, y: yView, width: educationDetailsListView.bounds.width, height: education.height))
            educationView.backgroundColor = .clear
            
            educationDetailsListView.addSubview(educationView)
            
            NSLayoutConstraint.activate([
                educationView.heightAnchor.constraint(equalToConstant: education.height),
                educationView.leadingAnchor.constraint(equalTo: educationDetailsListView.leadingAnchor, constant: 0),
                educationView.trailingAnchor.constraint(equalTo: educationDetailsListView.trailingAnchor, constant: 0),
                educationView.topAnchor.constraint(equalTo: educationDetailsListView.topAnchor, constant: yView)
                ])
            
            var yLabel:CGFloat = 15
            let degreeLbl = UILabel(frame: CGRect(x: 0, y: yLabel, width: educationDetailsListView.bounds.width, height: education.titleHeight))
            degreeLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            degreeLbl.textColor = UIColor(named: Colors.App_Black)
            degreeLbl.text = education.degreeName
            degreeLbl.numberOfLines = 3
            
            educationView.addSubview(degreeLbl)
            
            NSLayoutConstraint.activate([
                degreeLbl.heightAnchor.constraint(equalToConstant: education.titleHeight),
                degreeLbl.leadingAnchor.constraint(equalTo: educationView.leadingAnchor, constant: 0),
                degreeLbl.trailingAnchor.constraint(equalTo: educationView.trailingAnchor, constant: 0),
                degreeLbl.topAnchor.constraint(equalTo: educationView.topAnchor, constant: yLabel)
                ])
            
            yLabel += (education.titleHeight + 5)
            let collegeLbl = UILabel(frame: CGRect(x: 0, y: yLabel, width: educationDetailsListView.bounds.width, height: 20))
            collegeLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            collegeLbl.textColor = UIColor(named: Colors.App_Grey)
            collegeLbl.text = education.collegeName
            collegeLbl.numberOfLines = 1
            
            educationView.addSubview(collegeLbl)
            
            NSLayoutConstraint.activate([
                collegeLbl.heightAnchor.constraint(equalToConstant: 20),
                collegeLbl.leadingAnchor.constraint(equalTo: educationView.leadingAnchor, constant: 0),
                collegeLbl.trailingAnchor.constraint(equalTo: educationView.trailingAnchor, constant: 0),
                collegeLbl.topAnchor.constraint(equalTo: educationView.topAnchor, constant: yLabel)
                ])
            
            yLabel += (20 + 10)
            let durationLbl = UILabel(frame: CGRect(x: 0, y: yLabel, width: educationDetailsListView.bounds.width, height: 20))
            durationLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            durationLbl.textColor = UIColor(named: Colors.App_Grey)
            durationLbl.text = "Feb | 2010 - Jan | 2012" //FIXME: change to dynamic
            durationLbl.numberOfLines = 1
            
            educationView.addSubview(durationLbl)
            
            NSLayoutConstraint.activate([
                durationLbl.heightAnchor.constraint(equalToConstant: 20),
                durationLbl.leadingAnchor.constraint(equalTo: educationView.leadingAnchor, constant: 0),
                durationLbl.trailingAnchor.constraint(equalTo: educationView.trailingAnchor, constant: 0),
                durationLbl.topAnchor.constraint(equalTo: educationView.topAnchor, constant: yLabel)
                ])
            
            yView += education.height
        }
    }

}
