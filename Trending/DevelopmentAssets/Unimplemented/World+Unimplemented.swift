#if DEBUG
import CombineSchedulers
import GitHubAPIClient
import XCTestDynamicOverlay
import Combine
import IdentifiedCollections

extension World {
    static var unimplemented: Self {
        .init(
            gitHubApiClient: UnimplementedGitHubAPIClient(),
            reposRepository: UnimplementedReposRepository(),
            scheduler: .unimplemented
        )
    }
}

private class UnimplementedGitHubAPIClient: GitHubAPIClient {
    func trendingRepos() async throws -> [Model.Repo] {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
        return []
    }
}

final class UnimplementedReposRepository: ReposRepositoryType {
    func repos() -> AnyPublisher<IdentifiedArrayOf<Model.Repo>, Never> {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
        return Empty().eraseToAnyPublisher()
    }

    func repo(for id: Model.Repo.ID) -> Model.Repo? {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
        return nil
    }

    func bookmarkedRepos() -> AnyPublisher<Set<Repo.ID>, Never> {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
        return Empty().eraseToAnyPublisher()
    }

    func fetchRepos() async throws {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
    }

    func bookmarkRepo(_ id: Model.Repo.ID) {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
    }

    func removeBookmark(_ id: Model.Repo.ID) {
        XCTFail("Unimplemented: \(Self.self).\(#function)")
    }
}
#endif
