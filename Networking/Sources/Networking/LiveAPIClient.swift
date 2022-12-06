import Foundation
import Logging

public class LiveAPIClient: APIClient {
    let urlSession: URLSessionProtocol
    let jsonDecoder: JSONDecoder
    let logger: Logger?

    public convenience init(logger: Logger? = nil) {
        self.init(
            urlSession: URLSession.shared,
            jsonDecoder: .init(),
            logger: logger
        )
    }

    init(
        urlSession: URLSessionProtocol,
        jsonDecoder: JSONDecoder,
        logger: Logger?
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
        self.logger = logger
    }

    public func fetch<Model>(_ type: Model.Type, urlRequest: URLRequest) async throws -> Model where Model: Decodable {
        var logger = logger
        logger?[metadataKey: "request-hash"] = "\(urlRequest.hashValue)"
        logger?.debug("Request: \(urlRequest.debugDescription)")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await urlSession.data(for: urlRequest)
            logger?.debug("Response: \(response)")
            logger?.trace("Data: \(String(describing: String(data: data, encoding: .utf8)))")
        } catch {
            logger?.error("Error: \(error.localizedDescription)")
            throw APIClientError.networkingError(error)
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            logger?.error("Invalid response code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            throw APIClientError.invalidResponseCode
        }

        do {
            let object = try jsonDecoder.decode(Model.self, from: data)
            logger?.trace("Decoded object: \(object)")
            return object
        } catch {
            logger?.error("Decoding error: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
            throw APIClientError.decodingError(error)
        }
    }
}
