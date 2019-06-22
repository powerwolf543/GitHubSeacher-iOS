//
//  RoundingButton.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import UIKit

class RoundingButton: UIButton {
    
    // MARK: initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    // MARK: private
    
    private func setup() {
        clipsToBounds = true
    }
}
