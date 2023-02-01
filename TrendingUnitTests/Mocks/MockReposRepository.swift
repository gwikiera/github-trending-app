import Foundation
import Combine
import Model
@testable import Trending

class MockReposRepository: ReposRepositoryType {
    var fetchResult: Result<[Repo], Error> = .failure(errorStub)
    private var reposSubject = CurrentValueSubject<[Repo]?, Never>(nil)

    func repos() -> AnyPublisher<[Repo], Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        reposSubject.value?.first(where: { $0.id == id })
    }

    func fetchRepos() async throws {
        reposSubject.value = try fetchResult.get()
    }

    func closeSubject() {
        reposSubject.send(completion: .finished)
    }
}
