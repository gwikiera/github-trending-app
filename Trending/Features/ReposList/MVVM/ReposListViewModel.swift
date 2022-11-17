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
            .map { $0.map(\.repoCellViewState) }
            .map(ViewState.content)
            .receive(on: Current.scheduler)
            .assign(to: &$viewState)
    }
}
