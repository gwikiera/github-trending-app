import Foundation
import Model

public protocol GitHubAPIClient {
    func trendingRepos() async throws -> [Repo]
}
