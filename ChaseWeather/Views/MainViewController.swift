//
//  MainViewController.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import CoreLocation
import SwiftUI
import UIKit

final class MainViewController: UIViewController {
    
    lazy var main: UIView = {
        let locationService = LocationService()
        let viewModel = MainWeatherViewModel(dataService: DataService(), locationService: locationService)
        let view = MainWeatherView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        return vc.view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setupViews() {
        view.addSubview(main)        
        main.frame = view.frame
    }

}
