import Foundation
import Networking

// swiftlint:disable force_cast implicitly_unwrapped_optional
class MockAPIClient: APIClient {
    var fetchResult: Result<Any, Error>!

    func fetch<Model>(_ type: Model.Type, request: URLRequest) async throws -> Model where Model: Decodable {
        try fetchResult.get() as! Model
    }
}
