import Foundation
import Combine
import Model

#if DEBUG
extension World {
    static var preview: World {
        World(
            reposRepository: PreviewReposRepository()
        )
    }
}

class PreviewReposRepository: ReposRepositoryType {
    func repos() -> AnyPublisher<[Repo], Never> {
        Empty().eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        return nil
    }

    func fetchRepos() async throws {}
}
#endif
