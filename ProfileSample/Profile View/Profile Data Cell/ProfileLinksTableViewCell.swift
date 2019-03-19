//
//  ProfileLinksTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 14/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileLinksTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var linksListView: UIView!
    
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
        for link in userObject.profileLinks {
            let linkView = CatalogueView(frame: CGRect(x: 0, y: yView, width: linksListView.bounds.width, height: 90))
            linkView.translatesAutoresizingMaskIntoConstraints = false
            linkView.backgroundColor = .clear
            
            linkView.setupLayer()
            
            linksListView.addSubview(linkView)
            
            NSLayoutConstraint.activate([
                linkView.heightAnchor.constraint(equalToConstant: 90),
                linkView.leadingAnchor.constraint(equalTo: linksListView.leadingAnchor, constant: 0),
                linkView.trailingAnchor.constraint(equalTo: linksListView.trailingAnchor, constant: 0),
                linkView.topAnchor.constraint(equalTo: linksListView.topAnchor, constant: yView)
                ])
            
            let tickImageView = UIImageView(frame: CGRect(x: linkView.bounds.width - 20 - 15, y: 55, width: 20, height: 20))
            tickImageView.contentMode = .scaleAspectFit
            tickImageView.clipsToBounds = true
            tickImageView.image = UIImage(named: "ic_link_arrow")

            linkView.addSubview(tickImageView)

            NSLayoutConstraint.activate([
                tickImageView.heightAnchor.constraint(equalToConstant: 20),
                tickImageView.widthAnchor.constraint(equalToConstant: 20),
                tickImageView.leadingAnchor.constraint(equalTo: linkView.leadingAnchor, constant: linkView.bounds.width - 20 - 15),
                tickImageView.topAnchor.constraint(equalTo: linkView.topAnchor, constant: 55)
                ])

            let catalogueImageView = UIImageView(frame: CGRect(x: 15, y: 20, width: 50, height: 50))
            catalogueImageView.contentMode = .scaleAspectFit
            catalogueImageView.clipsToBounds = true
            catalogueImageView.image = UIImage(named: "ic_profile_document")

            linkView.addSubview(catalogueImageView)

            NSLayoutConstraint.activate([
                catalogueImageView.heightAnchor.constraint(equalToConstant: 50),
                catalogueImageView.widthAnchor.constraint(equalToConstant: 50),
                catalogueImageView.leadingAnchor.constraint(equalTo: linkView.leadingAnchor, constant: 15),
                catalogueImageView.topAnchor.constraint(equalTo: linkView.topAnchor, constant: 20)
                ])

            let titleLbl = UILabel(frame: CGRect(x: 80, y: 30, width: linkView.bounds.width - 80 - 15, height: 15))
            titleLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            titleLbl.textColor = UIColor(named: Colors.App_Black)
            titleLbl.text = link.title ?? ""
            
            linkView.addSubview(titleLbl)

            NSLayoutConstraint.activate([
                titleLbl.heightAnchor.constraint(equalToConstant: 15),
                titleLbl.widthAnchor.constraint(equalToConstant: linkView.bounds.width - 80 - 15),
                titleLbl.leadingAnchor.constraint(equalTo: linkView.leadingAnchor, constant: 80),
                titleLbl.topAnchor.constraint(equalTo: linkView.topAnchor, constant: 30)
                ])

            let linkLbl = UILabel(frame: CGRect(x: 80, y: 55, width: linkView.bounds.width - 80 - 15, height: 15))
            linkLbl.font = UIFont.ProximaNovaRegular(fontSize: 12)
            linkLbl.textColor = UIColor(named: Colors.App_Grey)
            linkLbl.text = link.link?.absoluteString ?? ""
            linkLbl.translatesAutoresizingMaskIntoConstraints = false

            linkView.addSubview(linkLbl)

            NSLayoutConstraint.activate([
                titleLbl.widthAnchor.constraint(equalToConstant: linkView.bounds.width - 80 - 15),
                linkLbl.leadingAnchor.constraint(equalTo: linkView.leadingAnchor, constant: 80),
                linkLbl.trailingAnchor.constraint(equalTo: linkView.trailingAnchor, constant: 15),
                linkLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 5)
                ])
            
            yView += 105
        }
    }
    
}


class CatalogueView: UIView {
    
    var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
    }
    
    fileprivate func setupLayer() {
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor(named: Colors.App_Grey)!.cgColor
        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 10
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
}
