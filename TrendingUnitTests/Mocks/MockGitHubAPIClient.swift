import Foundation
import GitHubAPIClient
import Model

// swiftlint:disable implicitly_unwrapped_optional
class MockGitHubAPIClient: GitHubAPIClient {
    var fetchResult: Result<[Repo], Error>!

    func trendingRepos() async throws -> [Repo] {
        try fetchResult.get()
    }
}
