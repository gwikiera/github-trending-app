import ComposableArchitecture
import XCTest
import Model
@testable import Trending

@MainActor
final class BookmarksTests: XCTestCase {
    var mockReposRepository: MockReposRepository!

    override func setUp() async throws {
        try await super.setUp()

        mockReposRepository = .init()
    }

    func testIntegration() async throws {
        // MARK: Set up
        let repos = ((1...10).map { Repo.stub(name: "repo\($0)") })
        mockReposRepository.fetchResult = .success(.init(uncheckedUniqueElements: repos))
        var bookmarkedRepos = Array(repos.prefix(5))
        try await mockReposRepository.fetchRepos()
        bookmarkedRepos.map(\.id).forEach(mockReposRepository.bookmarkRepo)

        let store = TestStore(
            initialState: Bookmarks.ViewState(reposViewStates: []),
            reducer: Bookmarks()
        )

        store.dependencies.reposRepository = mockReposRepository
        store.dependencies.mainQueue = .immediate

        // MARK: View loaded
        await store.send(.onAppear)

        // MARK: Fetch succeeded
        await store.receive(.fetchedRepos(repos: bookmarkedRepos)) {
            $0.reposViewStates = bookmarkedRepos
                .map(\.repoCellViewState)
                .map {
                    var viewState = $0
                    viewState.bookmarked = true
                    return viewState
                }
        }

        // MARK: Select repo
        await store.send(.setSelectedRepoId(repos.first?.id)) {
            $0.selectedRepoViewState = repos.first?.repoDetailsViewState
        }

        // MARK: Bookmarks
        await store.send(.removeBookmarkRepoId(bookmarkedRepos[0].id))
        bookmarkedRepos = Array(bookmarkedRepos.dropFirst())
        await store.receive(.fetchedRepos(repos: bookmarkedRepos)) {
            $0.reposViewStates = bookmarkedRepos
                .map(\.repoCellViewState)
                .map {
                    var viewState = $0
                    viewState.bookmarked = true
                    return viewState
                }
        }

        // MARK: Finish
        mockReposRepository.closeSubjects()
        await store.finish()
    }
}
