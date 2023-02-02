import XCTest
import Model
import IdentifiedCollections
@testable import Trending

final class ReposRepositoryTests: XCTestCase {
    var apiClient: MockGitHubAPIClient!
    var sut: ReposRepository!

    override func setUp() async throws {
        try await super.setUp()

        apiClient = MockGitHubAPIClient()
        Current.gitHubApiClient = apiClient
        sut = ReposRepository()
    }

    func testFetchingData_whenSucceeded() async throws {
        // Given
        let repos = IdentifiedArray(uniqueElements: (1...10).map { Repo.stub(name: "repo\($0)") })
        apiClient.fetchResult = .success(repos.elements)

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
        }
    }
}
