//
//  Extensions.swift
//  UberApp
//
//  Created by Salma Hassan on 3/24/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red : CGFloat , green : CGFloat , blue : CGFloat , alpha : CGFloat = 1) -> UIColor {
        return UIColor.init(red: red / 255, green: green / 255 , blue: blue / 255 , alpha: alpha)
    }
    
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let mainBlue = UIColor.rgb(red: 17, green: 154, blue: 237)
}

extension UIView {
    func inputContainerView(with image : UIImage , textField : UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 0.87
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 12, width: 24, height: 24)
        
        //add text field
        view.addSubview(textField)
        textField.anchor(bottom: view.bottomAnchor, left: imageView.rightAnchor, right: view.rightAnchor, paddingBottom: 8, paddingLeft: 8)
        textField.centerY(inView: view)

        //add seperator view
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        view.addSubview(seperatorView)
        seperatorView.anchor(bottom:view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,  paddingBottom: 8, height: 0.75)
        
        return view
    }
    
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
    
    func centerY(inView : UIView){
        centerYAnchor.constraint(equalTo: inView.centerYAnchor).isActive = true
    }
}

extension UITextField {
    func textField(with placeholder : String = "" , isSecureEntry : Bool = false) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = UIColor(white: 1, alpha: 0.8)
        return tf
    }
}
