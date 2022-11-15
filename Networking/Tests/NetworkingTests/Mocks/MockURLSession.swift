import Foundation
@testable import Networking

class URLSessionProtocolMock: URLSessionProtocol {
    var dataStub: (URLRequest) throws -> (Data, URLResponse) = { _ in fatalError("unimplemented") }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try dataStub(request)
    }
}
