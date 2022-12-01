import Foundation
import Networking
import XCTest
@testable import GitHubAPIClient

// swiftlint:disable force_cast implicitly_unwrapped_optional
class MockAPIClient: APIClient {
    var fetchData: Result<Data, Error>!

    func fetch<Model>(_ type: Model.Type, request: URLRequest) async throws -> Model where Model: Decodable {
        let data = try fetchData.get()
        return try JSONDecoder().decode(Model.self, from: data)
    }
}

extension MockAPIClient {
    func responseFromFile(named: String) throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: named, withExtension: "json"))
        let data = try Data(contentsOf: url)
        fetchData = .success(data)
    }
}
