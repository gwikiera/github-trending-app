import XCTest
@testable import Trending

// swiftlint:disable implicitly_unwrapped_optional
final class ReposRepositoryTests: XCTestCase {
    var apiClient: MockAPIClient!
    var sut: ReposRepository!

    override func setUp() async throws {
        try await super.setUp()

        apiClient = MockAPIClient()
        Current.apiClient = apiClient
        sut = ReposRepository()
    }

    func testFetchingData_whenSucceeded() async throws {
        // Given
        let repos = Array(repeating: Repo.stub(), count: 10)
        apiClient.fetchResult = .success(repos)

        // When
        try await sut.fetchRepos()
        let result = try await sut.repos().firstResult().get()

        // Then
        XCTAssertEqual(result, repos)
    }

    func testFetchingData_whenFailed() async throws {
        // Given
        apiClient.fetchResult = .failure(errorStub)

        // When
        do {
            try await sut.fetchRepos()
            XCTFail("Fetch should fail")
        } catch {
            // Then
            XCTAssertEqual(error as? ErrorStub, errorStub)
            let result = try await sut.repos().firstResult().get()
            XCTAssertEqual(result, [])
        }
    }
}
