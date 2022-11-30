// Based on https://www.pointfree.co/blog/posts/21-how-to-control-the-world

import Foundation
import Networking
import CombineSchedulers
import GitHubAPIClient

struct World {
    var gitHubApiClient: GitHubAPIClient = UnofficialGitHubAPIClient()
    var reposRepository: ReposRepositoryType = ReposRepository()
    var scheduler: AnySchedulerOf<DispatchQueue> = .main.eraseToAnyScheduler()
}

var Current = World() // swiftlint:disable:this identifier_name

extension UnofficialGitHubAPIClient {
    init() {
        self.init(url: "https://gh-trending-api.herokuapp.com/repositories", apiClient: LiveAPIClient())
    }
}
