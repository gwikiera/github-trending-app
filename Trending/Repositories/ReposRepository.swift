// Inspired by https://en.wikipedia.org/wiki/Command%E2%80%93query_separation

import Foundation
import Combine
import Model
import IdentifiedCollections

protocol ReposRepositoryType {
    // Queries
    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never>
    func repo(for id: Repo.ID) -> Repo?
    func bookmarkedRepos() -> AnyPublisher<[Repo.ID], Never>

    // Commands
    func fetchRepos() async throws
    func bookmarkRepo(_ id: Repo.ID)
    func removeBookmark(_ id: Repo.ID)
}

final class ReposRepository: ReposRepositoryType {
    private var reposSubject = CurrentValueSubject<IdentifiedArrayOf<Repo>?, Never>(nil)
    private var bookmarkedReposSubject = CurrentValueSubject<Set<Repo.ID>, Never>([])

    // Queries
    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        reposSubject.value?[id: id]
    }

    func bookmarkedRepos() -> AnyPublisher<[Model.Repo.ID], Never> {
        bookmarkedReposSubject
            .map(Array.init)
            .eraseToAnyPublisher()
    }

    // Commands
    func fetchRepos() async throws {
        reposSubject.value = .init(uniqueElements: try await Current.gitHubApiClient.trendingRepos())
    }

    func bookmarkRepo(_ id: Model.Repo.ID) {
        var favoriteRepos = self.bookmarkedReposSubject.value
        favoriteRepos.insert(id)
        self.bookmarkedReposSubject.value = favoriteRepos
    }

    func removeBookmark(_ id: Model.Repo.ID) {
        var favoriteRepos = self.bookmarkedReposSubject.value
        favoriteRepos.remove(id)
        self.bookmarkedReposSubject.value = favoriteRepos
    }
}
