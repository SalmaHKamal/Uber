//
//  LoginViewController.swift
//  UberApp
//
//  Created by Salma Hassan on 3/24/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "uber"
        label.text = label.text?.uppercased()
        label.textColor = UIColor(white: 1, alpha: 0.8)
        label.font = UIFont(name: "Avenir-Light", size: 36)
        return label
    }()
    
    private lazy var emailContainerView : UIView = {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x")
        imageView.alpha = 0.87
        view.addSubview(imageView)
        imageView.centerY(inView: view)
        imageView.anchor(left: view.leftAnchor, paddingLeft: 12, width: 24, height: 24)
        
        
        //add a text field
        view.addSubview(emailTextField)
        emailTextField.anchor(bottom: view.bottomAnchor, left: imageView.rightAnchor, right: view.rightAnchor, paddingBottom: 8, paddingLeft: 8)
        emailTextField.centerY(inView: view)
        
        //add seperator view
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        view.addSubview(seperatorView)
        seperatorView.anchor(bottom:view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,  paddingBottom: 8, height: 0.75)
        
        return view
    }()
    
    private let emailTextField : UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.keyboardAppearance = .dark
        tf.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = UIColor(white: 1, alpha: 0.8)
        return tf
    }()
     
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255 , blue: 25/255, alpha: 1)
        setupTitleLabel()
        setupEmailContainerView()
    }
    
    
    // MARK: - Helper Methods

    func setupEmailContainerView(){
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingRight: 16, paddingLeft: 16, paddingTop: 40, height: 50)
    }
    
    func setupTitleLabel(){
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: self.view) 
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


