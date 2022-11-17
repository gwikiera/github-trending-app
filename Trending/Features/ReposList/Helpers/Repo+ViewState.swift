import Foundation

extension Repo {
    var repoCellViewState: RepoCell.ViewState {
        RepoCell.ViewState(
            id: id,
            name: name,
            description: description,
            language: language,
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
            language: language,
            stars: totalStars,
            forks: forks,
            authors: authors
        )
    }
}
