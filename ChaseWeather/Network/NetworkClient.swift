//
//  NetworkClient.swift
//  ChaseWeather
//
//  Created by David Rynn on 9/30/23.
//

import Foundation

protocol Network {
    
    /// Network call for loading main data for the app
    /// - Returns: Data returned by network call.
    /// - Parameter urlRequest: URL enum representing a URL string
    /// @Discussion By using a generic return type this request has greater flexibility to be used for different calls.
    func loadData<T: Decodable>(url: URL) async throws -> T
    
}

/// The network client handles all direct networking activity. As an `actor` we ensure that it is thread safe and only one call will be made at one time, queuing the rest of the calls.
/// @Description
/// For more on actors, see https://developer.apple.com/tutorials/app-dev-training/managing-structured-concurrency
final class NetworkClient: Network {
    
    // MARK: - Properties
    private var decoder: JSONDecoder = JSONDecoder()
    private let downloader: any HTTPDataDownloader
    
    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
    
    // MARK: - Functions
    func loadData<T: Decodable>(url: URL) async throws -> T {
        let data = try await downloader.httpData(from: url)
        do {
            let responseData = try decoder.decode(T.self, from: data)
            return responseData
        } catch {
            throw WeatherAppError.parsing
        }
    }
    
}
