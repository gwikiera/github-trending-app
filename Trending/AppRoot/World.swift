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

// swiftlint:disable identifier_name
#if !DEBUG
var Current = World()
#else
var Current: World = {
    if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
        return .preview
    } else {
        return World()
    }
}()
#endif

private var defaultGitHubAPIClient: GitHubAPIClient {
#if OFFICIAL_API
    return OfficialGitHubAPIClient(url: Bundle.main.baseURL, apiClient: LiveAPIClient())
#elseif UNOFFICIAL_API
    return UnofficialGitHubAPIClient(url: Bundle.main.baseURL, apiClient: LiveAPIClient())
#elseif MOCK_API
    return MockGitHubAPIClient()
#endif
}
