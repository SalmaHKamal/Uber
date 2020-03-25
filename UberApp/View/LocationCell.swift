//
//  LocationCell.swift
//  UberApp
//
//  Created by Salma Hassan on 3/25/20.
//  Copyright © 2020 salma. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "Ismailia"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let descLabel : UILabel = {
        let label = UILabel()
        label.text = "is a perfect place"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupViews()
        
    }
    
    func setupViews(){
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel , descLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.centerY(inView: self)
        stackView.anchor(left: leftAnchor, right: rightAnchor, paddingRight: 16, paddingLeft: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
