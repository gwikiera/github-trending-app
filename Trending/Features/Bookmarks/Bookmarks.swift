import ComposableArchitecture
import Model

struct Bookmarks: ReducerProtocol {
    struct ViewState: Equatable {
        var reposViewStates: [RepoCell.ViewState]
        var selectedRepoViewState: RepoDetailsView.ViewState?
    }

    enum Action: Equatable {
        case onAppear
        case fetchedRepos(repos: [Repo])
        case setSelectedRepoId(Repo.ID?)
        case removeBookmarkRepoId(Repo.ID)
    }

    @Dependency(\.reposRepository) private var reposRepository
    @Dependency(\.mainQueue) private var mainQueue

    func reduce(into state: inout ViewState, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return reposRepository.bookmarkedRepos()
                .combineLatest(reposRepository.repos())
                .map { bookmarkedRepos, repos in
                    bookmarkedRepos.sorted().compactMap { repos[id: $0] }
                }
                .map(Action.fetchedRepos)
                .receive(on: mainQueue)
                .eraseToEffect()
        case let .fetchedRepos(repos):
            let viewStates = repos
                .lazy
                .map(\.repoCellViewState)
                .map {
                    var viewState = $0
                    viewState.bookmarked = true
                    return viewState
                }
            state.reposViewStates = Array(viewStates)
            return .none
        case let .setSelectedRepoId(repoId):
            state.selectedRepoViewState = repoId.flatMap(reposRepository.repo)?.repoDetailsViewState
            return .none
        case .removeBookmarkRepoId(let id):
            reposRepository.removeBookmark(id)
            return .none
        }
    }
}
