// Inspired by https://en.wikipedia.org/wiki/Command%E2%80%93query_separation

import Foundation
import Combine
import Model

protocol ReposRepositoryType {
    // Queries
    func repos() -> AnyPublisher<[Repo], Never>
    func repo(for id: Repo.ID) -> Repo?

    // Commands
    func fetchRepos() async throws
}

final class ReposRepository: ReposRepositoryType {
    private var reposSubject = CurrentValueSubject<[Repo]?, Never>(nil)

    // Queries
    func repos() -> AnyPublisher<[Repo], Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        reposSubject.value?.first { $0.id == id }
    }

    // Commands
    func fetchRepos() async throws {
        reposSubject.value = try await Current.gitHubApiClient.trendingRepos()
    }
}
