//
//  NetworkServiceProtocol.swift
//  iOS
//
//  Created by Oleh Poremskyy on 29.12.2024.
//

import Foundation
import Combine

// MARK: - jsut protocol for getting data from server
protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint, headers: [String: String]?, parameters: Encodable?) -> AnyPublisher<T, APIError>
}
