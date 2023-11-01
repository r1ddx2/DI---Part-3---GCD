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
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        
        for i in 0..<Sections.allCases.count {
            let currentOffsetRequest = Sections.allCases[i].request
            
            print("Enter api number \(i)")
            group.enter()
            
            if i == 0 {
                // semaphore.wait()
            }
            
            self.offsetProvider.fetchOffset(
                request: currentOffsetRequest) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let response):
                        
                        let fetchedData = DistrictLocation(
                            district: response.result.results[0].district,
                            location:  response.result.results[0].location)
                        
                        data[currentOffsetRequest.rawValue] = fetchedData
                        
                        //updateUI(for: i)
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    
                    print("Leave api number \(i)")
                    group.leave()
                    
                    //semaphore.signal()
            }
       
        }
        
        group.notify(queue: .main) {
            print("Finish all tasks using groups")
            self.updateUI(for: nil)
            
        }
        
        
    }
    
    
    private func updateUI(for view: Int?) {
        let allViews = [offsetView0, offsetView10, offsetView20]
        
        // Update in order
        guard let view = view else {
            for (index, view) in allViews.enumerated() {
                let data = data[Sections.allCases[index].request.rawValue]
                view.districtLabel.text = "District: \(data!.district)"
                view.locationLabel.text = "Location: \(data!.location)"
            }
            return
        }
        
        // Update all at once
        print("Finish task number \(view) using semaphore")
        let data = data[Sections.allCases[view].request.rawValue]
        allViews[view].districtLabel.text = "District: \(data!.district)"
        allViews[view].locationLabel.text = "Location: \(data!.location)"
        
        
    }
    
    
    
}
