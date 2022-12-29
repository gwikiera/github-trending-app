import Foundation
import Combine
import Model
@testable import Trending

class MockReposRepository: ReposRepositoryType {
    var fetchResult: Result<[Repo], Error> = .failure(errorStub)
    private var reposSubject = CurrentValueSubject<[Repo]?, Never>(nil)
    private var bookmarksSubject = CurrentValueSubject<[Repo.ID], Never>([])

    func repos() -> AnyPublisher<[Repo], Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        return nil
    }

    func bookmarkedRepos() -> AnyPublisher<[Model.Repo.ID], Never> {
        return bookmarksSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func fetchRepos() async throws {
        reposSubject.value = try fetchResult.get()
    }

    func bookmarkRepo(_ id: Model.Repo.ID) {
        var bookmarks = bookmarksSubject.value
        bookmarks.append(id)
        bookmarksSubject.value = bookmarks
    }

    func removeBookmark(_ id: Model.Repo.ID) {
        var bookmarks = bookmarksSubject.value
        bookmarks.removeAll(where: { $0 == id })
        bookmarksSubject.value = bookmarks

    }

    func closeSubjects() {
        reposSubject.send(completion: .finished)
        bookmarksSubject.send(completion: .finished)
    }
}
