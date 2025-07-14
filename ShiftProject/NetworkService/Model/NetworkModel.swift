//
//  NetworkModel.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 09.07.2025.
//

import Foundation

struct NetworkModel: Codable, Hashable, Identifiable {
    let id: Int
    var title: String?
    let price: Double?
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case price
        case imageUrl = "image"
    }
}
