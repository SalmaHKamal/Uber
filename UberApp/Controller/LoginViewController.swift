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
        let view = UIView().inputContainerView(with: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    private lazy var passwordContainerView : UIView = {
        let view = UIView().inputContainerView(with: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    
    private let emailTextField : UITextField = {
        return UITextField().textField(with: "Email")
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(with: "Password")
    }()
     
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255 , blue: 25/255, alpha: 1)
        setupTitleLabel()
        setupTextFieldsStackView()
//        setupEmailContainerView()
//        setupPasswordContainerView()
    }
    
    
    // MARK: - Helper Methods
    
    func setupTextFieldsStackView(){
        let stackView = UIStackView(arrangedSubviews: [emailContainerView , passwordContainerView])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingRight: 16, paddingLeft: 16, paddingTop: 40)
    }

    func setupPasswordContainerView(){
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingRight: 16, paddingLeft: 16, paddingTop: 16, height: 50)
    }
    
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


