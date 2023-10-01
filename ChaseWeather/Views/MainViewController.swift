//
//  MainViewController.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import SwiftUI
import UIKit

class MainViewController: UIViewController {
    
    lazy var testLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var main: UIView = {
        let viewModel = MainWeatherViewModel(dataService: DataService())
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
