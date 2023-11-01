//
//  ViewController.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/10/31.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Subviews
   let offsetView0 = OffsetView()
    let offsetView10 = OffsetView()
    let offsetView20 = OffsetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
    }
    private func setUpLayouts() {
        view.addSubview(offsetView0)
        view.addSubview(offsetView10)
        view.addSubview(offsetView20)
        
        view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            offsetView0.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            offsetView0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            offsetView0.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            offsetView0.heightAnchor.constraint(equalToConstant: 150),
            
            offsetView10.topAnchor.constraint(equalTo: offsetView0.bottomAnchor, constant: 30),
            offsetView10.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            offsetView10.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            offsetView10.heightAnchor.constraint(equalToConstant: 150),
            
            offsetView20.topAnchor.constraint(equalTo: offsetView10.bottomAnchor, constant: 30),
            offsetView20.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            offsetView20.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            offsetView20.heightAnchor.constraint(equalToConstant: 150),
            
            
        ])
    }

}

