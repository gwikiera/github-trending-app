import XCTest
@testable import GitHubAPIClient

final class UnofficialGitHubAPIClientTests: XCTestCase {
    var url = URL(string: "localhost")!
    var apiClient: MockAPIClient!
    var sut: UnofficialGitHubAPIClient!

    override func setUpWithError() throws {
        apiClient = MockAPIClient()
        sut = UnofficialGitHubAPIClient(url: url, apiClient: apiClient)
    }

    func testTrendingReposSuccess() async throws {
        try apiClient.responseFromFile(named: "unofficialReposResponse")

        let repos = try await sut.trendingRepos()

        XCTAssertEqual(repos.map(\.name), ["diffusion-models-class", "Rocket.Chat", "jsonhero-web", "Best-websites-a-programmer-should-visit", "whisper.cpp"])
        XCTAssertEqual(repos.map(\.rank), Array(1...5))
        XCTAssertEqual(repos.compactMap(\.language?.name), ["Jupyter Notebook", "TypeScript", "TypeScript", "C"])
        XCTAssertEqual(repos.compactMap(\.language?.colorHex), ["#DA5B0B", "#3178c6", "#3178c6", "#555555"])
    }

    func testTrendingReposFailure() async throws {
        apiClient.fetchData = .failure(errorStub)

        do {
            _ = try await sut.trendingRepos()
            XCTFail("Fetch should fail")
        } catch {
            XCTAssertEqual(error as? ErrorStub, errorStub)
        }
    }
}
