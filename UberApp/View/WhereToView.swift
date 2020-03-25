//
//  WhereToView.swift
//  UberApp
//
//  Created by Salma Hassan on 3/25/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit


class WhereToView: UIView {
    
    var didTabWhereToGoView : (() -> Void)?
    private let placeholderLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "Where To ?"
        lbl.textColor = .darkGray
        return lbl
    }()
    
    private let indicatorView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    fileprivate func setupViews() {
        backgroundColor = .white
        addSubview(indicatorView)
        
        indicatorView.anchor(left: leftAnchor, paddingLeft: 16, width: 6, height: 6)
        indicatorView.centerY(inView: self)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, bottom: bottomAnchor, left: indicatorView.rightAnchor, right: rightAnchor, paddingRight: 8, paddingBottom: 16, paddingLeft: 8, paddingTop: 16)
        placeholderLabel.centerY(inView: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setShadow()
        setupViews()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapRecognizer)
    }
    
    
    
    @objc func viewTapped(){
        didTabWhereToGoView!()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
