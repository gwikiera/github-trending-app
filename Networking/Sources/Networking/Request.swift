import Foundation

public struct Request {
    public struct Endpoint {
        let url: () -> URL?

        public init(url: @escaping () -> URL?) {
            self.url = url
        }
    }

    public struct Body {
        let data: () -> Data?

        public init(data: @escaping () -> Data?) {
            self.data = data
        }
    }

    let endpoint: Endpoint
    let body: Body?
    let method: HTTPMethod
    let headers: [String: String]

    public init(
        endpoint: Request.Endpoint,
        method: HTTPMethod = .get,
        body: Request.Body? = nil,
        headers: [String: String] = [:]
    ) {
        self.endpoint = endpoint
        self.method = method
        self.body = body
        self.headers = headers
    }
}

extension Request {
    var urlRequest: URLRequest {
        get throws {
            guard let url = endpoint.url() else { throw APIClientError.invalidURL }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = method.rawValue
            urlRequest.allHTTPHeaderFields = headers
            urlRequest.httpBody = body?.data()
            return urlRequest
        }
    }
}

public extension Request.Endpoint {
    init(
        baseURL: URL,
        path: String,
        queryParameters: [String: String] = [:]
    ) {
        self.url = {
            guard
                let url = URL(string: path, relativeTo: baseURL),
                var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            else { return nil }

            if !queryParameters.isEmpty {
                components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            return components.url
        }
    }
}
