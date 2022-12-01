import Foundation
@testable import Trending

extension RepoCell.ViewState {
    static func stub(
        name: String = "bestRepoEver",
        description: String? = nil,
        language: Language? = nil,
        stars: Int = .max,
        forks: Int = 0
    ) -> RepoCell.ViewState {
        .init(
            id: name,
            name: name,
            description: description,
            language: language,
            stars: stars,
            forks: forks
        )
    }
}
