//
//  ProfileIndustryExpTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 14/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileIndustryExpTableViewCell: UITableViewCell {

    @IBOutlet weak var industriesListView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    
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
        
        var yView: CGFloat = 15
        for i in 0..<userObject.industries.count {
            let industry = userObject.industries[i]
            
            let industryView = UIView(frame: CGRect(x: 0, y: yView, width: industriesListView.bounds.width, height: 50))
            industryView.translatesAutoresizingMaskIntoConstraints = false
            industryView.backgroundColor = .clear
            
            industriesListView.addSubview(industryView)
            
            NSLayoutConstraint.activate([
                industryView.heightAnchor.constraint(equalToConstant: 50),
                industryView.leadingAnchor.constraint(equalTo: industriesListView.leadingAnchor, constant: 0),
                industryView.trailingAnchor.constraint(equalTo: industriesListView.trailingAnchor, constant: 0),
                industryView.topAnchor.constraint(equalTo: industriesListView.topAnchor, constant: yView)
                ])
            
            let nameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: industryView.bounds.width, height: industryView.bounds.height))
            nameLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            nameLbl.textColor = UIColor(named: Colors.App_Black)
            nameLbl.text = industry.name
            nameLbl.numberOfLines = 2
            
            industryView.addSubview(nameLbl)
            
            NSLayoutConstraint.activate([
                nameLbl.heightAnchor.constraint(equalToConstant: industryView.bounds.height),
                nameLbl.widthAnchor.constraint(equalToConstant: industryView.bounds.width),
                nameLbl.topAnchor.constraint(equalTo: industryView.topAnchor, constant: 0),
                nameLbl.leadingAnchor.constraint(equalTo: industryView.leadingAnchor, constant: 0)
                ])
            
            if i < userObject.industries.count - 1 {
                let lineView = UIView(frame: CGRect(x: 0, y: 49, width: industriesListView.bounds.width, height: 1))
                lineView.backgroundColor = UIColor(named: Colors.App_Light_Grey)
                
                industryView.addSubview(lineView)
                
                NSLayoutConstraint.activate([
                    lineView.heightAnchor.constraint(equalToConstant: 1),
                    lineView.widthAnchor.constraint(equalToConstant: industriesListView.bounds.width),
                    lineView.leadingAnchor.constraint(equalTo: industryView.leadingAnchor, constant: 0),
                    lineView.topAnchor.constraint(equalTo: industryView.topAnchor, constant: 49)
                    ])
            }
            
            yView += 50
        }
    }
    
}
