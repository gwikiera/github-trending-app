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

    public func fetch<Model>(_ type: Model.Type, urlRequest: URLRequest) async throws -> Model where Model: Decodable {
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch {
            throw APIClientError.networkingError(error)
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw APIClientError.invalidResponseCode
        }

        do {
            return try jsonDecoder.decode(Model.self, from: data)
        } catch {
            throw APIClientError.decodingError(error)
        }
    }
}
