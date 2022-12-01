import Foundation
import Model
import SwiftUI

extension Repo {
    var repoCellViewState: RepoCell.ViewState {
        RepoCell.ViewState(
            id: id,
            name: name,
            description: description,
            language: language.flatMap { .init(name: $0.name, color: Color(hex: $0.colorHex)) },
            stars: totalStars,
            forks: forks
        )
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
