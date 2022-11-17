import ComposableArchitecture

struct ReposList: ReducerProtocol {
    struct ViewState: Equatable {
        enum CLE: Equatable { // swiftlint:disable:this nesting
            case content([RepoCell.ViewState])
            case loading
            case error
        }

        var cle: CLE
        var selectedRepoId: Repo.ID?
        var selectedRepoViewState: RepoDetailsView.ViewState? {
            return selectedRepoId.flatMap(Current.reposRepository.repo)?.repoDetailsViewState
        }
    }

    enum Action {
        case onAppear
        case fetchRepos
        case fetchReposResponse(TaskResult<Void>)
        case fetchedRepos([Repo])
        case setSelectedRepoId(Repo.ID?)
    }

    func reduce(into state: inout ReposList.ViewState, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            return Current.reposRepository.repos()
                .dropFirst()
                .map(Action.fetchedRepos)
                .receive(on: Current.scheduler)
                .eraseToEffect()
        case .fetchRepos:
            if state.cle == .error {
                state.cle = .loading
            }

            return .task {
                await .fetchReposResponse(
                    TaskResult {
                        try await Current.reposRepository.fetchRepos()
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
