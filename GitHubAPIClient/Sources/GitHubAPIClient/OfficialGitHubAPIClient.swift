// https://github.com/NiklasTiede/Github-Trending-API
import Foundation
import Networking
import Model

private typealias ColorsDict = [String: String]

public final class OfficialGitHubAPIClient: GitHubAPIClient {
    private let url: URL
    private let apiClient: APIClient
    private let dateProvider: () -> Date
    private var colorsCache: ColorsDict?
    private lazy var dateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }()

    public init(
        url: URL,
        apiClient: APIClient,
        dateProvider: @escaping () -> Date = Date.init
    ) {
        self.url = url
        self.apiClient = apiClient
        self.dateProvider = dateProvider
    }

    public func trendingRepos() async throws -> [Model.Repo] {
        let date = dateProvider().addingTimeInterval(.day * -30)
        let endpoint = Request.Endpoint(
            baseURL: url,
            path: Endpoint.repositories,
            queryParameters: [
                QueryItem.sort: "stars",
                QueryItem.order: "desc",
                QueryItem.query: "created:>\(dateFormatter.string(from: date))"
            ]
        )
        let request = Request(endpoint: endpoint)
        async let reposDTO = apiClient
            .fetch(ReposDTO.self, request: request)
        let (repos, colors) = try await (reposDTO, self.colors)
        return repos.items.enumerated().map { (index, item) in
            item.mapped(with: index + 1, colors: colors)
        }
    }

    private var colors: ColorsDict {
        get async throws {
            if let colorsCache { return colorsCache }
            guard let colorsURL = Bundle.module.url(forResource: "colors", withExtension: "json") else {
                assertionFailure()
                return [:]
            }
            let data = try Data(contentsOf: colorsURL)
            let colors = try JSONDecoder().decode(ColorsDict.self, from: data)
            self.colorsCache = colors
            return colors
        }
    }
}

// MARK: - Request
private enum Endpoint {
    static var repositories = "search/repositories"
}

private enum QueryItem {
    static var sort = "sort"
    static var order = "order"
    static var query = "q"
}

// MARK: - DTO
// swiftlint:disable nesting
private struct ReposDTO: Decodable {
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

// MARK: - Helpers
extension TimeInterval {
    static var minute: Self { 60 }
    static var hour: Self { 60 * minute }
    static var day: Self { 24 * hour }
}
