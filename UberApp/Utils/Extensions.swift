//
//  Extensions.swift
//  UberApp
//
//  Created by Salma Hassan on 3/24/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingRight: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingTop: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil)
    {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right{
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    
    func centerX(inView : UIView){
        centerXAnchor.constraint(equalTo: inView.centerXAnchor).isActive = true
    }
}
