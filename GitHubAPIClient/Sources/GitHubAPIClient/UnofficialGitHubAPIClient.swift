// https://github.com/NiklasTiede/Github-Trending-API
import Foundation
import Networking
import Model

public struct UnofficialGitHubAPIClient: GitHubAPIClient {
    let url: URL
    let apiClient: APIClient

    public init(url: URL, apiClient: APIClient) {
        self.url = url
        self.apiClient = apiClient
    }

    public func trendingRepos() async throws -> [Model.Repo] {
        try await apiClient
            .fetch([RepoDTO].self, for: url)
            .map(\.repo)
    }
}

// MARK: - DTO
private struct RepoDTO: Decodable {
    struct Author: Decodable {
        let username: String
        let url: URL
        let avatar: URL
    }

    let repositoryName: String
    let rank: Int
    let url: URL
    let description: String?
    let language: String?
    let languageColor: String?
    let totalStars: Int
    let forks: Int
    let builtBy: [Author]
}

private extension RepoDTO {
    var repo: Repo {
        .init(
            name: repositoryName,
            rank: rank,
            url: url,
            description: description,
            language: repoLanguage,
            totalStars: totalStars,
            forks: forks,
            authors: builtBy.map(\.author)
        )
    }

    var repoLanguage: Repo.Language? {
        guard let language, let languageColor else { return nil }
        return .init(name: language, colorHex: languageColor)
    }
}

private extension RepoDTO.Author {
    var author: Repo.Author {
        .init(username: username, url: url, avatar: avatar)
    }
}
