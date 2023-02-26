import Foundation
import Model
import SwiftUI

extension Repo {
    func repoCellViewState(bookmarked: Bool) -> RepoCell.ViewState {
        RepoCell.ViewState(
            id: id,
            name: name,
            description: description,
            language: language.flatMap { .init(name: $0.name, color: Color(hex: $0.colorHex)) },
            stars: totalStars,
            forks: forks,
            bookmarked: bookmarked
        )
    }

    var repoCellViewState: RepoCell.ViewState {
        repoCellViewState(bookmarked: false)
    }

    var bookmarkedRepoCellViewState: RepoCell.ViewState {
        repoCellViewState(bookmarked: true)
    }

    var repoDetailsViewState: RepoDetailsView.ViewState {
        RepoDetailsView.ViewState(
            name: name,
            rank: rank,
            url: url,
            description: description,
            language: language.flatMap { .init(name: $0.name, color: Color(hex: $0.colorHex)) },
            stars: totalStars,
            forks: forks,
            authors: authors
        )
    }
}
