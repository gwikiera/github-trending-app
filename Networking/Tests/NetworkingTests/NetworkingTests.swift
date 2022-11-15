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
}

private extension URL {
    static var stub: URL { URL(string: "www.example.com")! }
}

extension String: Error {}
