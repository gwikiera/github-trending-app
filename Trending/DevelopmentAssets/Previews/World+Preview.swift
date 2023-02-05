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

    func bookmarkedRepos() -> AnyPublisher<Set<Repo.ID>, Never> {
        Empty().eraseToAnyPublisher()
    }

    func fetchRepos() async throws {}
    func bookmarkRepo(_ id: Model.Repo.ID) {}
    func removeBookmark(_ id: Model.Repo.ID) {}
}
#endif
