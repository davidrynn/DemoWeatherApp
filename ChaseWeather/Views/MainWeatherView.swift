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
            Spacer()
            Text("Unit selection: \(viewModel.units.rawValue)")
            textField
            Text("\(viewModel.temperature)")
            AsyncImage(url: viewModel.iconURL)
                .frame(width: 80, height: 80)
                .accessibilityHidden(true)
            Spacer()
        }
    }
    
    var picker: some View {
        Picker("Choose units", selection: $viewModel.units) {
            ForEach(Units.allCases) { unit in
                Text(unit.rawValue).tag(unit)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var textField: some View {
        HStack {
            Spacer()
            TextField("Enter City", text: $viewModel.city)
                .border(Color.secondary, width: 1)
            Button("Go", action: {
                Task {
                    await viewModel.getWeather()
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
            Text("Error!")
            Button("Reset") {
                viewModel.reset()
            }
        }
    }
}

struct MainWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        MainWeatherView(viewModel: MainWeatherViewModel(dataService: MockDataService()))
    }
}
