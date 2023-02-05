import ComposableArchitecture
import Model

struct ReposList: ReducerProtocol {
    struct ViewState: Equatable {
        enum CLE: Equatable {
            case content([RepoCell.ViewState])
            case loading
            case error
        }

        var cle: CLE
        var selectedRepoViewState: RepoDetailsView.ViewState?
    }

    enum Action {
        case onAppear
        case fetchRepos
        case fetchReposResponse(TaskResult<Void>)
        case fetchedRepos(IdentifiedArrayOf<Repo>, bookmarks: Set<Repo.ID>)
        case setSelectedRepoId(Repo.ID?)
        case bookmarkRepoId(Repo.ID)
        case removeBookmarkRepoId(Repo.ID)
    }

    @Dependency(\.reposRepository) private var reposRepository
    @Dependency(\.mainQueue) private var mainQueue

    func reduce(into state: inout ReposList.ViewState, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return reposRepository.repos()
                .combineLatest(reposRepository.bookmarkedRepos())
                .map(Action.fetchedRepos)
                .receive(on: mainQueue)
                .eraseToEffect()
        case .fetchRepos:
            if state.cle == .error {
                state.cle = .loading
            }

            return .task {
                await .fetchReposResponse(
                    TaskResult {
                        try await reposRepository.fetchRepos()
                    }
                )
            }
        case .fetchReposResponse(.success):
            return .none
        case .fetchReposResponse(.failure):
            state.cle = .error
            return .none
        case let .fetchedRepos(repos, bookmarkedRepos):
            let viewStates = repos
                .lazy
                .map(\.repoCellViewState)
                .map {
                    var viewState = $0
                    viewState.bookmarked = bookmarkedRepos.contains(viewState.id)
                    return viewState
                }
            state.cle = .content(Array(viewStates))
            return .none
        case let .setSelectedRepoId(repoId):
            state.selectedRepoViewState = repoId.flatMap(reposRepository.repo)?.repoDetailsViewState
            return .none
        case .bookmarkRepoId(let id):
            reposRepository.bookmarkRepo(id)
            return .none
        case .removeBookmarkRepoId(let id):
            reposRepository.removeBookmark(id)
            return .none
        }
    }
}
