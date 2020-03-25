//
//  AuthButton.swift
//  UberApp
//
//  Created by Salma Hassan on 3/25/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

class AuthButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .mainBlue
        titleLabel?.textColor = UIColor(white: 1, alpha: 0.5)
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
