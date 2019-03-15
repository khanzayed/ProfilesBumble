//
//  ProfileObjectivesTableViewCell.swift
//  ProfileSample
//
//  Created by admin on 14/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class ProfileObjectivesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var objectivesListView: UIView!
    
    private var isConfigured = false
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    internal func configure(withUser userObject: UserObject) {
        guard isConfigured == false else {
            return
        }
        isConfigured = true
        
        var yView: CGFloat = 15
        for objective in userObject.completeObjectives {
            let objectiveView = ObjectiveView(frame: CGRect(x: 0, y: yView, width: objectivesListView.bounds.width, height: 60))
            objectiveView.translatesAutoresizingMaskIntoConstraints = false
            objectiveView.setupLayer()
            objectivesListView.addSubview(objectiveView)
            
            NSLayoutConstraint.activate([
                objectiveView.heightAnchor.constraint(equalToConstant: 60),
                objectiveView.leadingAnchor.constraint(equalTo: objectivesListView.leadingAnchor, constant: 0),
                objectiveView.trailingAnchor.constraint(equalTo: objectivesListView.trailingAnchor, constant: 0),
                objectiveView.topAnchor.constraint(equalTo: objectivesListView.topAnchor, constant: yView)
                ])
            
            let tickImageView = UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20))
            tickImageView.contentMode = .scaleAspectFit
            tickImageView.clipsToBounds = true
            tickImageView.image = UIImage(named: objective.isMatching ? "ic_match_objective_tick" : "ic_unmatch_objective_tick")
            
            objectiveView.addSubview(tickImageView)
            
            let nameLbl = UILabel(frame: CGRect(x: 55, y: 0, width: objectiveView.bounds.width - 55, height: objectiveView.bounds.height))
            nameLbl.font = UIFont.ProximaNovaSemiBold(fontSize: 14)
            nameLbl.textColor = UIColor(named: Colors.App_Black)
            nameLbl.text = objective.name
            nameLbl.numberOfLines = 2
            
            objectiveView.addSubview(nameLbl)
            
            yView += 75
        }
    }
    
}


class ObjectiveView: UIView {
    
    var shadowLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 30).cgPath
    }
    
    fileprivate func setupLayer() {
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 30).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor(named: Colors.App_Grey)!.cgColor
        shadowLayer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        shadowLayer.shadowOpacity = 0.3
        shadowLayer.shadowRadius = 10
        
        self.layer.insertSublayer(shadowLayer, at: 0)
    }
    
}
