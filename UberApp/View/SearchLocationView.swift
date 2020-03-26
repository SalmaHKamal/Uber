//
//  SearchLocationView.swift
//  UberApp
//
//  Created by Salma Hassan on 3/25/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

class SearchLocationView: UIView {
    
    // MARK: - Properties
    var user: User?{
        didSet{
            titleLabel.text = user?.fullName
        }
    }
    var didPressBackButton : (() -> Void)?
    private let backButton : UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Ismailia"
        label.textColor = .darkGray
        return label
    }()
    
    private let sourceLocationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Current Location"
        tf.backgroundColor = .groupTableViewBackground
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: 8, height: 30)
        
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let destinationLocationTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a distination ..."
        tf.backgroundColor = .lightGray
        
        let paddingView = UIView()
        paddingView.frame = CGRect(x: 0, y: 0, width: 8, height: 30)
        
        tf.leftView = paddingView
        tf.leftViewMode = .always
        return tf
    }()
    
    private let sourceLocationIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let destinationLocationIndicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let linkView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setShadow()
    }
    
    func setupViews(){
        backgroundColor = .white
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingLeft: 16, width: 24, height: 25)
        
        //label
        addSubview(titleLabel)
        titleLabel.centerY(inView: backButton)
        titleLabel.centerX(inView: self)
        
        //current location
        addSubview(sourceLocationTextField)
        sourceLocationTextField.anchor(top: backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingRight: 16, paddingLeft: 40, paddingTop: 16, height: 30)
        
        
        //destination location
        addSubview(destinationLocationTextField)
        destinationLocationTextField.anchor(top: sourceLocationTextField.bottomAnchor, left: sourceLocationTextField.leftAnchor, right: sourceLocationTextField.rightAnchor , paddingTop: 8, height: 30)
        
        //current location indicator
        addSubview(sourceLocationIndicatorView)
        sourceLocationIndicatorView.anchor( right: sourceLocationTextField.leftAnchor, paddingRight: 16, width: 6, height: 6)
        sourceLocationIndicatorView.layer.cornerRadius = 6 / 2
        sourceLocationIndicatorView.centerY(inView: sourceLocationTextField)
        
        //detination location indictor
        addSubview(destinationLocationIndicatorView)
        destinationLocationIndicatorView.anchor(right: destinationLocationTextField.leftAnchor, paddingRight: 16 , width: 6, height: 6)
        destinationLocationIndicatorView.layer.cornerRadius = 6 / 2
        destinationLocationIndicatorView.centerY(inView: destinationLocationTextField)
        
        //link view
        addSubview(linkView)
        linkView.centerX(inView: sourceLocationIndicatorView)
        linkView.anchor(top: sourceLocationIndicatorView.bottomAnchor, bottom: destinationLocationIndicatorView.topAnchor, paddingBottom: 4,paddingTop: 4, width: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    @objc func backBtnPressed(){
        didPressBackButton?()
    }
    
}
