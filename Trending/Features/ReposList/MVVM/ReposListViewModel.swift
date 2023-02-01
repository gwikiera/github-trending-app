import Foundation
import SwiftUI
import Model

class ReposListViewModel: ObservableObject {
    enum ViewState: Equatable {
        case content(ReposListView.ViewState)
        case loading
        case error
    }

    enum Destination {
        case repoDetails(RepoDetailsView.ViewState)
    }

    @Published var viewState: ViewState = .loading
    @Published var destination: Destination?

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

    func repoTapped(_ repoId: Repo.ID) {
        guard let repo = Current.reposRepository.repo(for: repoId) else { return }
        destination = .repoDetails(repo.repoDetailsViewState)
    }

    private func bindData() {
        Current.reposRepository.repos()
            .map { $0.map(\.repoCellViewState) }
            .map(ViewState.content)
            .receive(on: Current.scheduler)
            .assign(to: &$viewState)
    }
}
