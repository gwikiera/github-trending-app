import XCTest
@testable import GitHubAPIClient

// swiftlint:disable force_unwrapping implicitly_unwrapped_optional
final class OfficialGitHubAPIClientTests: XCTestCase {
    var url = URL(string: "localhost")!
    var apiClient: MockAPIClient!
    var sut: OfficialGitHubAPIClient!

    override func setUpWithError() throws {
        apiClient = MockAPIClient()
        sut = OfficialGitHubAPIClient(url: url, apiClient: apiClient)
    }

    func testTrendingReposSuccess() async throws {
        try apiClient.responseFromFile(named: "officialReposResponse")

        let repos = try await sut.trendingRepos()

        XCTAssertEqual(repos.map(\.name), ["smiley-sans", "stablediffusion", "openblocks", "Linux-Bash-Commands", "twitter-archive-parser"])
        XCTAssertEqual(repos.map(\.rank), Array(1...5))
        XCTAssertEqual(repos.compactMap(\.language?.name), ["HTML", "Python", "TypeScript", "Python"])
        XCTAssertEqual(repos.compactMap(\.language?.colorHex), ["#000000", "#3572A5", "#000000", "#3572A5"])
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
