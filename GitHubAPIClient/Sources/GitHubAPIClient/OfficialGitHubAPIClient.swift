// https://github.com/NiklasTiede/Github-Trending-API
import Foundation
import Networking
import Model

private typealias ColorsDict = [String: String]

public class OfficialGitHubAPIClient: GitHubAPIClient {
    private let url: URL
    private let apiClient: APIClient
    private var colorsCache: ColorsDict?

    public init(url: URL, apiClient: APIClient) {
        self.url = url
        self.apiClient = apiClient
    }

    public func trendingRepos() async throws -> [Model.Repo] {
        async let reposDTO = apiClient
            .fetch(ReposDTO.self, for: url)
        let (repos, colors) = try await (reposDTO, self.colors)
        return repos.items.enumerated().map { (index, item) in
            item.mapped(with: index, colors: colors)
        }
    }

    private var colors: ColorsDict {
        get async throws {
            if let colorsCache { return colorsCache }
            guard let colorsURL = Bundle.module.url(forResource: "colors", withExtension: "json") else {
                assertionFailure()
                return [:]
            }
            let colors = try await apiClient.fetch([String: String].self, for: colorsURL)
            self.colorsCache = colors
            return colors
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
    func mapped(with rank: Int, colors: ColorsDict) -> Repo {
        .init(
            name: name,
            rank: rank,
            url: url,
            description: description,
            language: languageMapped(with: colors),
            totalStars: stargazersCount,
            forks: forks,
            authors: [owner.mapped]
        )
    }

    func languageMapped(with colors: ColorsDict) -> Repo.Language? {
        guard let language else { return nil }
        let colorHex = colors[language.capitalized] ?? "#000000"
        return .init(name: language, colorHex: colorHex)
    }
}

extension ReposDTO.Item.Owner {
    var mapped: Repo.Author {
        .init(username: login, url: url, avatar: avatarURL)
    }
}
