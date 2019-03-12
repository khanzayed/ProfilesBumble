//
//  EmptyView.swift
//  ProfileSample
//
//  Created by admin on 12/03/19.
//  Copyright © 2019 BlueTie. All rights reserved.
//

import UIKit

class EmptyView: UIView {
    
    @IBOutlet var emptyView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    deinit {
        print("Deinit")
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        addSubview(emptyView)
        
        emptyView.frame = self.bounds
        emptyView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
}
