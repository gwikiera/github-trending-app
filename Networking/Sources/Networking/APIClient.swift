import Foundation

public enum APIClientError: Error {
    case networkingError(Error)
    case decodingError(Error)
    case invalidResponseCode
}

public protocol APIClient {
    func fetch<Model: Decodable>(_ type: Model.Type, request: URLRequest) async throws -> Model
}

public extension APIClient {
    func fetch<Model: Decodable>(_ type: Model.Type, for url: URL) async throws -> Model {
        try await fetch(type, request: URLRequest(url: url))
    }
}
