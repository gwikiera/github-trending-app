import Foundation
import GitHubAPIClient
import Model

class MockGitHubAPIClient: GitHubAPIClient {
    var fetchResult: Result<[Repo], Error>!

    func trendingRepos() async throws -> [Repo] {
        try fetchResult.get()
    }
}
