//
//  NetworkService.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 09.07.2025.
//

import Foundation

final class NetworkService {
    @MainActor static let shared = NetworkService()

    init() {}

    let url = URL(string: "https://fakestoreapi.com/products")

    func fetchRequest() async throws -> [NetworkModel] {

        guard let url else {
            print("fetchRequest - Invalid URL")
            throw URLError(.badURL)
        }

        let (data,response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid server response: \(response)")
            throw URLError(.badServerResponse)
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            print("Server error: \(httpResponse.statusCode)")
            print("Response body: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode([NetworkModel].self, from: data)
            return decodedData
        } catch {
            print("JSON decoding error: \(error.localizedDescription)")
            debugPrint("Raw response: \(String(data: data, encoding: .utf8) ?? "N/A")")
            throw error
        }
    }
}
