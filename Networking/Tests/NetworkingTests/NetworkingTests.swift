import XCTest
@testable import Networking

// swiftlint:disable implicitly_unwrapped_optional force_unwrapping
final class LiveAPIClientTests: XCTestCase {
    var urlSession: URLSessionProtocolMock!
    var sut: LiveAPIClient!

    override func setUp() async throws {
        try await super.setUp()

        urlSession = URLSessionProtocolMock()
        sut = LiveAPIClient(urlSession: urlSession, jsonDecoder: .init())
    }

    func testFetch_withNetworkingError() async throws {
        // Given
        urlSession.dataStub = { _ in throw "networking error" }

        do {
            // When
            _ = try await sut.fetch(String.self, for: .stub)
            XCTFail("Fetch should fail")
        } catch {
            // Then
            guard case let APIClientError.networkingError(networkError) = error else {
                XCTFail("Invalid error: \(error)")
                return
            }
            XCTAssertEqual(networkError as? String, "networking error")
        }
    }

    func testFetch_withInvalidResponseCode() async throws {
        // Given
        urlSession.dataStub = { _ in
            return (Data(), HTTPURLResponse(url: .stub, statusCode: 404, httpVersion: nil, headerFields: nil)!)
        }

        do {
            // When
            _ = try await sut.fetch(String.self, for: .stub)
            XCTFail("Fetch should fail")
        } catch {
            // Then
            guard case APIClientError.invalidResponseCode = error else {
                XCTFail("Invalid error: \(error)")
                return
            }
        }
    }

    func testFetch_withInvalidData() async throws {
        // Given
        urlSession.dataStub = { _ in
            return (Data(), HTTPURLResponse(url: .stub, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }

        do {
            // When
            _ = try await sut.fetch(String.self, for: .stub)
            XCTFail("Fetch should fail")
        } catch {
            // Then
            guard case APIClientError.decodingError = error else {
                XCTFail("Invalid error: \(error)")
                return
            }
        }
    }

    func testFetch_withValidData() async throws {
        // Given
        let data = try JSONEncoder().encode("Test")
        urlSession.dataStub = { _ in
            return (data, HTTPURLResponse(url: .stub, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }

        // When
        let string = try await sut.fetch(String.self, for: .stub)

        // Then
        XCTAssertEqual(string, "Test")
    }

    func testFetch_withRequest() async throws {
        // Given
        let data = try JSONEncoder().encode("Test")
        let request = Request(
            endpoint: .init(baseURL: .stub, path: "path", queryParameters: ["param1": "value1", "param2": "value2"]),
            method: .post,
            body: .init(data: { data }),
            headers: ["key": "value"]
        )
        var urlRequest: URLRequest?
        urlSession.dataStub = { request in
            urlRequest = request
            return (data, HTTPURLResponse(url: .stub, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }

        // When
        let string = try await sut.fetch(String.self, request: request)

        // Then
        XCTAssertEqual(string, "Test")
        XCTAssertEqual(urlRequest?.url, URL(string: "http://www.example.com/path?param2=value2&param1=value1"))
    }
}

private extension URL {
    static var stub: URL { URL(string: "http://www.example.com")! }
}

extension String: Error {}
