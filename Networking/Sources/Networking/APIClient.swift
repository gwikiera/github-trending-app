import Foundation

public enum APIClientError: Error {
    case networkingError(Error)
    case decodingError(Error)
    case invalidResponseCode
    case invalidURL
}

public protocol APIClient {
    func fetch<Model: Decodable>(_ type: Model.Type, urlRequest: URLRequest) async throws -> Model
}

public extension APIClient {
    func fetch<Model: Decodable>(_ type: Model.Type, request: Request) async throws -> Model {
        try await fetch(type, urlRequest: request.urlRequest)
    }

    func fetch<Model: Decodable>(_ type: Model.Type, for url: URL) async throws -> Model {
        try await fetch(type, urlRequest: URLRequest(url: url))
    }
}
