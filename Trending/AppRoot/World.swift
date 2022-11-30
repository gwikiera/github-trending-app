// Based on https://www.pointfree.co/blog/posts/21-how-to-control-the-world

import Foundation
import Networking
import CombineSchedulers
import GitHubAPIClient

struct World {
    var gitHubApiClient: GitHubAPIClient = defaultGitHubAPIClient
    var reposRepository: ReposRepositoryType = ReposRepository()
    var scheduler: AnySchedulerOf<DispatchQueue> = .main.eraseToAnyScheduler()
}

var Current = World() // swiftlint:disable:this identifier_name

private var defaultGitHubAPIClient: GitHubAPIClient {
#if OFFICIAL_API
    return OfficialGitHubAPIClient(url: Bundle.main.baseURL, apiClient: LiveAPIClient())
#elseif  UNOFFICIAL_API
    return UnofficialGitHubAPIClient(url: Bundle.main.baseURL, apiClient: LiveAPIClient())
#elseif MOCK_API
    fatalError("Not implemented yet :(.")
#endif
}
