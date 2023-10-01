//
//  MainWeatherView.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import SwiftUI

struct MainWeatherView: View {
    @State var text: String = ""
    @ObservedObject private var viewModel: MainWeatherViewModel
    
    
    init(viewModel: MainWeatherViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        switch viewModel.loadingState {
        case .error:
            Text("Error!")
        case .loaded:
            main
        case .loading:
            loading
        }

    }
}
extension MainWeatherView {
    var main: some View {
        VStack {
            TextField("Enter City", text: $viewModel.city)
                .onSubmit {
                    Task {
                        await viewModel.getWeather()
                    }
                }
            Text("\(viewModel.temperature)")
        }
    }
    
    var loading: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
}

struct MainWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView(viewModel: MainWeatherViewModel(dataService: MockDataService()))
    }
}
