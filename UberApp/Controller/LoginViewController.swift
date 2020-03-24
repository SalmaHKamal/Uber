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
     
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.init(red: 25/255, green: 25/255 , blue: 25/255, alpha: 1)
        setupTitleLabel()
    }
    
    
    // MARK: - Helper Methods

    func setupTitleLabel(){
        view.addSubview(titleLabel)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: self.view) 
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


