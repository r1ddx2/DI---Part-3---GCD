//
//  ViewController.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/10/31.
//

import UIKit

class ViewController: UIViewController {
    
    let offsetProvider = OffsetProvider(httpClient: HTTPClient())
    var data = [String: DistrictLocation]()
    
    // MARK: - Subviews
    let offsetView0 = OffsetView()
    let offsetView10 = OffsetView()
    let offsetView20 = OffsetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        
        fetchByOffsets(.offset0)
        fetchByOffsets(.offset10)
        fetchByOffsets(.offset20)
      
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
    private func fetchByOffsets(_ offsetValue: OffsetRequest) {
        offsetProvider.fetchOffset(
            request: offsetValue) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    let fetchedData = DistrictLocation(
                        district: response.result.results[0].district,
                        location:  response.result.results[0].location)
                    
                    data[offsetValue.rawValue] = fetchedData
                    updateUI(for: offsetValue)
                 
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        
    }
    
    private func updateUI(for offsetValue: OffsetRequest) {
        let districtDescription = "District: "
        let locationDescription = "Location: "
        
        switch offsetValue {
        case .offset0:
            offsetView0.districtLabel.text = districtDescription + data[offsetValue.rawValue]!.district
            offsetView0.locationLabel.text = locationDescription + data[offsetValue.rawValue]!.location
        
        case .offset10:
            offsetView10.districtLabel.text = districtDescription + data[offsetValue.rawValue]!.district
            offsetView10.locationLabel.text = locationDescription + data[offsetValue.rawValue]!.location
       
        case .offset20:
            offsetView20.districtLabel.text = districtDescription + data[offsetValue.rawValue]!.district
            offsetView20.locationLabel.text = locationDescription + data[offsetValue.rawValue]!.location
        }
        
    }
}

