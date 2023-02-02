import Foundation
import Combine
import Model
import IdentifiedCollections
@testable import Trending

class MockReposRepository: ReposRepositoryType {
    var fetchResult: Result<IdentifiedArrayOf<Repo>, Error> = .failure(errorStub)
    private var reposSubject = CurrentValueSubject<IdentifiedArrayOf<Repo>?, Never>(nil)

    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never> {
        return reposSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        reposSubject.value?.first(where: { $0.id == id })
    }

    func fetchRepos() async throws {
        reposSubject.value = .init(uniqueElements: try fetchResult.get()) 
    }

    func closeSubject() {
        reposSubject.send(completion: .finished)
    }
}
