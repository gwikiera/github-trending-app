import Foundation
import Combine
import Model
import IdentifiedCollections
@testable import Trending

class MockReposRepository: ReposRepositoryType {
    var fetchResult: Result<IdentifiedArrayOf<Repo>, Error> = .failure(errorStub)
    private var reposSubject = CurrentValueSubject<IdentifiedArrayOf<Repo>?, Never>(nil)
    private var bookmarksSubject = CurrentValueSubject<Set<Repo.ID>, Never>([])

    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        reposSubject.value?[id: id]
    }

    func bookmarkedRepos() -> AnyPublisher<Set<Repo.ID>, Never> {
        return bookmarksSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func fetchRepos() async throws {
        reposSubject.value = .init(uniqueElements: try fetchResult.get())
    }

    func bookmarkRepo(_ id: Model.Repo.ID) {
        var bookmarks = bookmarksSubject.value
        bookmarks.insert(id)
        bookmarksSubject.value = bookmarks
    }

    func removeBookmark(_ id: Model.Repo.ID) {
        var bookmarks = bookmarksSubject.value
        bookmarks.remove(id)
        bookmarksSubject.value = bookmarks
    }

    func closeSubjects() {
        reposSubject.send(completion: .finished)
        bookmarksSubject.send(completion: .finished)
    }
}
