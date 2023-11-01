//
//  OffsetView.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/11/1.
//

import UIKit

class OffsetView: UIView {
    // MARK: - Subviews
    let districtLabel: UILabel = {
        let districtLabel = UILabel()
        districtLabel.textColor = .black
        districtLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        districtLabel.text = "District"
        return districtLabel
    }()
    let locationLabel: UILabel = {
        let locationLabel = UILabel()
        locationLabel.textColor = .black
        locationLabel.font =  UIFont.systemFont(ofSize: 20, weight: .regular)
        locationLabel.text = "Location"
        return locationLabel
    }()
    
    // MARK: - View Load
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .white
        setUpLayouts()
    }
    
    private func setUpLayouts() {
        addSubview(districtLabel)
        addSubview(locationLabel)
        
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            districtLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            districtLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            locationLabel.topAnchor.constraint(equalTo: districtLabel.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         
        ])
        
    }
    
}
