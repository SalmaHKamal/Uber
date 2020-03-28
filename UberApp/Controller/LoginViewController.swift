//
//  LoginViewController.swift
//  UberApp
//
//  Created by Salma Hassan on 3/24/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit
import Firebase

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
        return UITextField().textField(with: "Password" , isSecureEntry: true)
    }()
    
    private let loginButton : UIButton = {
        let btn = AuthButton()
        btn.setTitle("Log in", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(loginBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    private let donotHaveAccountButton : UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't Have an Account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16) ,
                                                                                                         NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                                                                                  NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        btn.addTarget(self, action: #selector(DontHaveAccountBtnPressed), for: .touchUpInside)
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
    @objc func DontHaveAccountBtnPressed(){
        navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func loginBtnPressed(){
        guard let email = emailTextField.text ,
            let password = passwordTextField.text
            else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error while login => " , error.localizedDescription)
                return
            }
            
            guard let controller = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?
                .windows
                .filter({$0.isKeyWindow}).first?
                .rootViewController as? HomeViewController
                else
            {
                print("can't fetch HomeViewController")
                return
            }
            
            controller.configure()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}


