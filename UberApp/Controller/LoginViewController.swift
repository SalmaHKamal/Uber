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
     
    private let loginButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Log in", for: .normal)
        btn.backgroundColor = .mainBlue
        btn.titleLabel?.textColor = UIColor(white: 1, alpha: 0.5)
        btn.layer.cornerRadius = 5
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
//        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return btn
    }()
    
    private let donotHaveAccountButton : UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't Have an Account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16) ,
                                                                                                 NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                                                                                  NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        btn.addTarget(self, action: #selector(signUpBtnPressed), for: .touchUpInside)
        btn.setAttributedTitle(attributedTitle, for: .normal)
        return btn
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        setupTitleLabel()
        setupTextFieldsStackView()
        setupDontHaveAccButton()
        setupNavigationBar()
    }
    
    
    // MARK: - Helper Methods
    func setupNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setupDontHaveAccButton(){
        view.addSubview(donotHaveAccountButton)
        donotHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor , height: 32 )
        donotHaveAccountButton.centerX(inView: view)
    }
    
    func setupTextFieldsStackView(){
        let stackView = UIStackView(arrangedSubviews: [emailContainerView , passwordContainerView , loginButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingRight: 16, paddingLeft: 16, paddingTop: 40)
    }
    
    func setupTitleLabel(){
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: self.view) 
    }
    
    // MARK: - Actions
    @objc func signUpBtnPressed(){
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
}


