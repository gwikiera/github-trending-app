import Foundation
import Combine
import Model
import IdentifiedCollections

#if DEBUG
extension World {
    static var preview: World {
        World(
            reposRepository: PreviewReposRepository()
        )
    }
}

class PreviewReposRepository: ReposRepositoryType {
    func repos() -> AnyPublisher<IdentifiedArrayOf<Repo>, Never> {
        Empty().eraseToAnyPublisher()
    }

    func repo(for id: Repo.ID) -> Repo? {
        return nil
    }

    func fetchRepos() async throws {}
}
#endif
