import Foundation
import SwiftUI

class ReposListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case content(ReposListView.ViewState)
        case loading
        case error
    }

    @Published var viewState: ViewState = .loading

    init() {
        bindData()
    }

    @MainActor
    func fetchRepos() async {
        if self.viewState == .error {
            self.viewState = .loading
        }
        do {
            try await Current.reposRepository.fetchRepos()
        } catch {
            viewState = .error
        }
    }

    func repoDetailsViewState(for id: Repo.ID) -> RepoDetailsView.ViewState? {
        guard let repo = Current.reposRepository.repo(for: id) else { return nil }
        return repo.repoDetailsViewState
    }

    private func bindData() {
        Current.reposRepository.repos()
            .filter { !$0.isEmpty }
            .map { $0.map(\.repoCellViewState) }
            .map(ViewState.content)
            .receive(on: Current.scheduler)
            .assign(to: &$viewState)
    }
}

private extension Repo {
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
