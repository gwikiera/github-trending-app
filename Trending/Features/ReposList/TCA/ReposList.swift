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
        var selectedRepoId: Repo.ID?
        var selectedRepoViewState: RepoDetailsView.ViewState? {
            guard let selectedRepoId else { return nil }
            @Dependency(\.reposRepository) var reposRepository
            return reposRepository.repo(for: selectedRepoId)?.repoDetailsViewState
        }
    }

    enum Action {
        case onAppear
        case fetchRepos
        case fetchReposResponse(TaskResult<Void>)
        case fetchedRepos([Repo])
        case setSelectedRepoId(Repo.ID?)
    }

    @Dependency(\.reposRepository) private var reposRepository
    @Dependency(\.mainQueue) private var mainQueue

    func reduce(into state: inout ReposList.ViewState, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return reposRepository.repos()
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
        case let .fetchedRepos(repos):
            state.cle = .content(repos.map(\.repoCellViewState))
            return .none
        case let .setSelectedRepoId(repoId):
            state.selectedRepoId = repoId
            return .none
        }
    }
}
