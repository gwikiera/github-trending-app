import ComposableArchitecture
import XCTest
import Model
@testable import Trending

@MainActor
final class ReposListTests: XCTestCase {
    var mockReposRepository: MockReposRepository!

    override func setUp() async throws {
        try await super.setUp()

        mockReposRepository = .init()
    }

    func testIntegration() async {
        // MARK: Set up
        let store = TestStore(
            initialState: ReposList.ViewState(cle: .loading),
            reducer: ReposList()
        )

        store.dependencies.reposRepository = mockReposRepository
        store.dependencies.mainQueue = .main

        // MARK: View loaded
        await store.send(.onAppear)
        await store.send(.fetchRepos)

        // MARK: Fetch failed
        await store.receive(
            .fetchReposResponse(.failure(errorStub))
        ) {
            $0.cle = .error
        }

        // MARK: Fetch succeeded
        let repos = IdentifiedArray(uniqueElements: (1...10).map { Repo.stub(name: "repo\($0)") })
        mockReposRepository.fetchResult = .success(repos)

        await store.send(.fetchRepos) {
            $0.cle = .loading
        }

        await store.receive(.fetchedRepos(repos, bookmarks: [])) {
            $0.cle = .content(repos.map(\.repoCellViewState))
        }
        await store.receive(.fetchReposResponse(.success(())))

        // MARK: Select repo
        await store.send(.setSelectedRepoId(repos.first?.id)) {
            $0.selectedRepoViewState = repos.first?.repoDetailsViewState
        }

        // MARK: Bookmarks
        await store.send(.bookmarkRepoId(repos[5].id))
        await store.receive(.fetchedRepos(repos, bookmarks: ["repo6"])) {
            guard var viewStates = $0.cle.viewStates else {
                return
            }
            viewStates[5].bookmarked = true
            $0.cle = .content(viewStates)
        }

        await store.send(.removeBookmarkRepoId(repos[5].id))
        await store.receive(.fetchedRepos(repos, bookmarks: [])) {
            guard var viewStates = $0.cle.viewStates else {
                return
            }
            viewStates[5].bookmarked = false
            $0.cle = .content(viewStates)
        }

        // MARK: Finish
        mockReposRepository.closeSubjects()
        await store.finish()
    }
}

extension ReposList.Action: Equatable {
    public static func == (lhs: Trending.ReposList.Action, rhs: Trending.ReposList.Action) -> Bool {
        switch (lhs, rhs) {
        case (.onAppear, .onAppear):
            return true
        case (.fetchRepos, .fetchRepos):
            return true
        case (.fetchReposResponse(.success), .fetchReposResponse(.success)):
            return true
        case (.fetchReposResponse(.failure(let lhsError)), .fetchReposResponse(.failure(let rhsError))):
            return lhsError is ErrorStub && rhsError is ErrorStub
        case let (.fetchedRepos(lhsRepos, lhsBookmarks), .fetchedRepos(rhsRepos, rhsBookmarks)):
            return lhsRepos == rhsRepos && lhsBookmarks == rhsBookmarks
        case (.setSelectedRepoId(let lhsId), .setSelectedRepoId(let rhsId)):
            return lhsId == rhsId
        default:
            return false
        }
    }
}

private extension ReposList.ViewState.CLE {
    var viewStates: [RepoCell.ViewState]? {
        switch self {
        case .content(let viewStates):
            return viewStates
        default:
            return nil
        }
    }
}
