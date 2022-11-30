// https://github.com/NiklasTiede/Github-Trending-API
import Foundation
import Networking
import Model

public struct OfficialGitHubAPIClient: GitHubAPIClient {
    let url: URL
    let apiClient: APIClient

    public init(url: URL, apiClient: APIClient) {
        self.url = url
        self.apiClient = apiClient
    }

    public func trendingRepos() async throws -> [Model.Repo] {
        let reposDTO = try await apiClient
            .fetch(ReposDTO.self, for: url)
        return reposDTO.items.enumerated().map { (index, item) in
            item.mapped(with: index)
        }
    }
}

// MARK: - DTO
// swiftlint:disable nesting
struct ReposDTO: Decodable {
    struct Item: Decodable {
        struct Owner: Decodable {
            let login: String
            let avatarURL: URL
            let url: URL

            enum CodingKeys: String, CodingKey {
                case login, url
                case avatarURL = "avatar_url"
            }
        }

        let name: String
        let url: URL
        let description: String?
        let language: String?
        let stargazersCount: Int
        let forks: Int
        let owner: Owner

        enum CodingKeys: String, CodingKey {
            case name, url, description, language, forks, owner
            case stargazersCount = "stargazers_count"
        }
    }

    let items: [Item]
}

private extension ReposDTO.Item {
    func mapped(with rank: Int) -> Repo {
        .init(
            name: name,
            rank: rank,
            url: url,
            description: description,
            language: repoLanguage,
            totalStars: stargazersCount,
            forks: forks,
            authors: [owner.mapped]
        )
    }

    var repoLanguage: Repo.Language? {
        guard let language else { return nil }
        return .init(name: language, colorHex: "#000000")
    }
}

extension ReposDTO.Item.Owner {
    var mapped: Repo.Author {
        .init(username: login, url: url, avatar: avatarURL)
    }
}
