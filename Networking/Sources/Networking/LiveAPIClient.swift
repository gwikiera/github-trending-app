import Foundation

public class LiveAPIClient: APIClient {
    let urlSession: URLSessionProtocol
    let jsonDecoder: JSONDecoder

    public convenience init() {
        self.init(
            urlSession: URLSession.shared,
            jsonDecoder: .init()
        )
    }

    init(
        urlSession: URLSessionProtocol,
        jsonDecoder: JSONDecoder
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    public func fetch<Model>(_ type: Model.Type, request: URLRequest) async throws -> Model where Model: Decodable {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: request)
        } catch {
            throw APIClientError.networkingError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIClientError.invalidResponseCode
        }

        do {
            return try jsonDecoder.decode(Model.self, from: data)
        } catch {
            throw APIClientError.decodingError(error)
        }
    }
}
