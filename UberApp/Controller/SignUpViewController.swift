//
//  SignUpViewController.swift
//  UberApp
//
//  Created by Salma Hassan on 3/25/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private var location = LocationHandler.shared.locationManager.location
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
    
    private lazy var fullNameContainerView : UIView = {
        let view = UIView().inputContainerView(with: #imageLiteral(resourceName: "ic_person_outline_white_2x"), textField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView : UIView = {
        let view = UIView().inputContainerView(with: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView : UIView = {
        let view = UIView().inputContainerView(with: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let accountTypeSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider" , "Driver"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentTintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .normal)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], for: .selected)
        
        return sc
    }()
    
    private let emailTextField : UITextField = {
        return UITextField().textField(with: "Email")
    }()
    
    private let fullNameTextField : UITextField = {
        return UITextField().textField(with: "FullName")
    }()
    
    private let passwordTextField : UITextField = {
        return UITextField().textField(with: "Password" , isSecureEntry: true)
    }()
    
    private let signUpButton : UIButton = {
        let btn = AuthButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.addTarget(self, action: #selector(signUpBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    private let alreadyHaveAccountButton : UIButton = {
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already Have an Account ? ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16) ,
                                                                                                           NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16),
                                                                                NSAttributedString.Key.foregroundColor: UIColor.mainBlue]))
        btn.addTarget(self, action: #selector(alreadyHaveAccountPressed), for: .touchUpInside)
        btn.setAttributedTitle(attributedTitle, for: .normal)
        return btn
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        view.backgroundColor = .backgroundColor
        setupTitleLabel()
        setupTextFieldsStackView()
        setupAlreadyHaveAccountBtn()
    }
    
    // MARK: - Helper Methods
    
    func setupAlreadyHaveAccountBtn(){
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor , height: 32 )
        alreadyHaveAccountButton.centerX(inView: view)
    }
    
    func setupTextFieldsStackView(){
        let stackView = UIStackView(arrangedSubviews:
            [emailContainerView ,
             fullNameContainerView,
             passwordContainerView ,
             accountTypeContainerView ,
             signUpButton])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        view.addSubview(stackView)
        stackView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingRight: 16, paddingLeft: 16, paddingTop: 40)
    }
    
    func setupTitleLabel(){
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: self.view)
    }
    
    // MARK: - Actions
    @objc func alreadyHaveAccountPressed(){
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func saveUserDataToDB(_ uid: String, _ values: [String : Any]) {
        USERS_REF.child(uid).updateChildValues(values) { [weak self](error, ref) in
            if let error = error {
                print("Error while saving user data ti db => " , error.localizedDescription)
                return
            }
            self?.showHomeViewController()
        }
    }
    
    @objc func signUpBtnPressed(){
        guard let email = emailTextField.text ,
            let password = passwordTextField.text ,
            let fullName = fullNameTextField.text
            else {
                return
        }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        //signup user
        Auth.auth().createUser(withEmail: email, password: password) {(result, error) in
            if let error = error {
                print("Error while registering user => " , error.localizedDescription)
            }else {
                guard let uid = result?.user.uid else {
                    return
                }
                
                let values = ["email": email,
                              "fullName": fullName,
                              "accountType" : accountTypeIndex] as [String : Any]
                
                if accountTypeIndex == 1{
                    guard let location = self.location else { return }
                    let geoFire = GeoFire(firebaseRef: DRIVER_LOC)
                    geoFire.setLocation(location, forKey: uid) { (error) in
                        guard let error = error else {
                            self.saveUserDataToDB(uid, values)
                            return }
                        print("Error while saving driver location to firebase db => " , error.localizedDescription)
                    }
                }
                
                self.saveUserDataToDB(uid, values)
                
            }
        }
    }
    
    func showHomeViewController(){
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
