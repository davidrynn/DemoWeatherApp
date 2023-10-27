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
        NavigationStack {
            Group {
                switch viewModel.loadingState {
                case .error:
                    errorMessage
                case .loaded:
                    main
                case .loading:
                    loading
                }
            }
            .navigationTitle("Weather")
        }
    }
}

private extension MainWeatherView {
    var main: some View {
        VStack {
            picker
            icon
            Spacer()
            Text("Unit selection: \(viewModel.units.rawValue)")
            Text("Temperature: \(viewModel.temperature)")
            humidity
            textField
            Spacer()
        }
    }
    
    var icon: some View {
        CacheAsyncImage(url: viewModel.iconURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 120, height: 120)
        .accessibilityHidden(true)
    }
    
    var picker: some View {
        Picker("Choose units", selection: $viewModel.units) {
            ForEach(Units.allCases) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.units) { _ in
            Task {
                await viewModel.getWeatherByCity()
            }
        }
    }
    
    var textField: some View {
        HStack {
            Spacer()
            TextField("Enter City", text: $viewModel.city)
                .border(Color.secondary, width: 1)
            Button("Go", action: {
                Task {
                    await viewModel.getWeatherByCity()
                }
            })
            .tint(.green)
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
    }
    
    var loading: some View {
        ProgressView()
            .progressViewStyle(.circular)
    }
    
    var errorMessage: some View {
        VStack {
            let message = viewModel.errorMessage ?? ""
            Text("Error! \(message)")
            Button("Reset") {
                viewModel.reset()
            }
        }
    }
    
    @ViewBuilder
    var humidity: some View {
        if let humidity = viewModel.humidity {
            Text("Humidity: \(humidity)")
                .padding()
        }
    }
}

struct MainWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView(viewModel: MainWeatherViewModel(dataService: MockDataService(), locationService: LocationService()))
    }
}
