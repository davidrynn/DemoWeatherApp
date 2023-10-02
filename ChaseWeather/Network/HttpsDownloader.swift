/*
 Taken from:
 https://developer.apple.com/tutorials/app-dev-training/building-a-network-test-client
 Abstract:
 A protocol describing an HTTP Data Downloader.
 */

import Foundation

let validStatus = 200...299
/// A protocol describing an HTTP Data Downloader.
protocol HTTPDataDownloader {
    
    /// Basic http data download call.
    /// - Parameter from: URL object for making call
    /// - Returns: Data of type `Data`
    func httpData(from: URL) async throws -> Data
}

extension URLSession: HTTPDataDownloader {
    func httpData(from url: URL) async throws -> Data {
        guard let (data, response) = try await self.data(from: url, delegate: nil) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode) else {
            throw WeatherAppError.network
        }
        return data
    }
}
