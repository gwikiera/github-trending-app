import ComposableArchitecture
import Networking

private enum ReposRepositoryKey: DependencyKey {
    static let liveValue: ReposRepositoryType = ReposRepository()
}

extension DependencyValues {
    var reposRepository: ReposRepositoryType {
        get { self[ReposRepositoryKey.self] }
        set { self[ReposRepositoryKey.self] = newValue }
    }
}
