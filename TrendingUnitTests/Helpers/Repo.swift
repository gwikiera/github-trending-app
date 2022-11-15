import Foundation
@testable import Trending

extension Repo {
    static func stub(
        name: String = "bestRepoEver",
        rank: Int = .max,
        url: URL = "https://github.com/gwikiera/github-trending-app",
        description: String? = nil,
        languageName: String? = nil,
        languageColor: String? = nil,
        totalStars: Int = .max,
        forks: Int = 0,
        authors: [Author] = []
    ) -> Repo {
        .init(
            name: name,
            rank: rank,
            url: url,
            description: description,
            languageName: languageName,
            languageColor: languageColor,
            totalStars: totalStars,
            forks: forks,
            authors: authors
        )
    }
}
