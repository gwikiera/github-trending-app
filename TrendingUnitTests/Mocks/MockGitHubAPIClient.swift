import Foundation
import GitHubAPIClient

class MockGitHubAPIClient: GitHubAPIClient {
    var fetchResult: Result<[Repo], Error>!

    func trendingRepos() async throws -> [Repo] {
        try fetchResult.get()
    }
}
