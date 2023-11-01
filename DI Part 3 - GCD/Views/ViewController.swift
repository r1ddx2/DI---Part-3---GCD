//
//  ViewController.swift
//  DI Part 3 - GCD
//
//  Created by Red Wang on 2023/10/31.
//

import UIKit

enum Sections: String, CaseIterable {
    case offsetView0
    case offsetView10
    case offsetView20
    
    var request: OffsetRequest {
        switch self {
        case .offsetView0:
            return .offset0
        case .offsetView10:
            return .offset10
        case .offsetView20:
            return .offset20
        }
    }
}

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
        fetchData()
        
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
    // MARK: - Methods
    
    private func fetchData() {
        let offsetAPIGroup = DispatchGroup()
        
        for i in 0..<Sections.allCases.count {
            let currentOffsetRequest = Sections.allCases[i].request
            
            offsetAPIGroup.enter()
       
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.offsetProvider.fetchOffset(
                    request: currentOffsetRequest) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let response):
                            let fetchedData = DistrictLocation(
                                district: response.result.results[0].district,
                                location:  response.result.results[0].location)
                            
                            data[currentOffsetRequest.rawValue] = fetchedData
                       
                        case .failure(let error):
                            print("Error: \(error)")
                        }
                        offsetAPIGroup.leave()
                        
                }
    
            }
            
        }
        
        offsetAPIGroup.notify(queue: .main) {
          self.updateUI()
           
        }
        
        
    }
    
    
    private func updateUI() {
        let districtDescription = "District: "
        let locationDescription = "Location: "

        offsetView0.districtLabel.text = districtDescription + data[Sections.offsetView0.request.rawValue]!.district
            offsetView0.locationLabel.text = locationDescription + data[Sections.offsetView0.request.rawValue]!.location
 
            offsetView10.districtLabel.text = districtDescription + data[Sections.offsetView10.request.rawValue]!.district
            offsetView10.locationLabel.text = locationDescription + data[Sections.offsetView10.request.rawValue]!.location
     
            offsetView20.districtLabel.text = districtDescription + data[Sections.offsetView20.request.rawValue]!.district
            offsetView20.locationLabel.text = locationDescription + data[Sections.offsetView20.request.rawValue]!.location
        
        
    }
    
    
}
