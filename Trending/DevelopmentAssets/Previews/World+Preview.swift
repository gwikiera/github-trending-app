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

    func bookmarkedRepos() -> AnyPublisher<[Model.Repo.ID], Never> {
        Empty().eraseToAnyPublisher()
    }

    func fetchRepos() async throws {}
    func bookmarkRepo(_ id: Model.Repo.ID) {}
    func removeBookmark(_ id: Model.Repo.ID) {}
}
#endif
