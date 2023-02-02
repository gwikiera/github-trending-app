// Inspired by https://en.wikipedia.org/wiki/Command%E2%80%93query_separation

import Foundation
import Combine
import Model
import IdentifiedCollections

protocol ReposRepositoryType {
    // Queries
    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never>
    func repo(for id: Repo.ID) -> Repo?

    // Commands
    func fetchRepos() async throws
}

final class ReposRepository: ReposRepositoryType {
    private var reposSubject = CurrentValueSubject<IdentifiedArrayOf<Repo>?, Never>(nil)

    // Queries
    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        reposSubject.value?[id: id]
    }

    // Commands
    func fetchRepos() async throws {
        reposSubject.value = .init(uniqueElements: try await Current.gitHubApiClient.trendingRepos())
    }
}
