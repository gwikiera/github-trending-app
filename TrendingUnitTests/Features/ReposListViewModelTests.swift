import XCTest
import Model
import IdentifiedCollections
@testable import Trending

final class ReposListViewModelTests: XCTestCase {
    var sut: ReposListViewModel!
    var mockReposRepository: MockReposRepository!

    override func setUp() async throws {
        try await super.setUp()

        mockReposRepository = MockReposRepository()
        Current.reposRepository = mockReposRepository
        Current.scheduler = .immediate
        sut = ReposListViewModel()
    }

    func testInitialViewState_isLoading() async throws {
        XCTAssertEqual(sut.viewState, .loading)
    }

    func testFetch_whenSucceeded() async throws {
        // Given
        let repos = IdentifiedArray(uniqueElements: (1...10).map { Repo.stub(name: "repo\($0)") })
        mockReposRepository.fetchResult = .success(repos)

        // When
        await sut.fetchRepos()

        // Then
        guard case let .content(result) = sut.viewState else {
            XCTFail("Invalid state: \(sut.viewState)")
            return
        }
        XCTAssertEqual(result, (1...10).map { RepoCell.ViewState.stub(name: "repo\($0)") })
    }

    func testFetch_whenFailed() async throws {
        // Given
        mockReposRepository.fetchResult = .failure(errorStub)

        // When
        await sut.fetchRepos()

        // Then
        XCTAssertEqual(sut.viewState, .error)
    }
}
