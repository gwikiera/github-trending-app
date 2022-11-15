// Based on https://www.pointfree.co/blog/posts/21-how-to-control-the-world

import Foundation
import Networking
import CombineSchedulers

struct World {
    var apiClient: APIClient = LiveAPIClient()
    var trendingReposURL: URL = "https://gh-trending-api.herokuapp.com/repositories"
    var reposRepository: ReposRepositoryType = ReposRepository()
    var scheduler: AnySchedulerOf<DispatchQueue> = .main.eraseToAnyScheduler()
}

var Current = World() // swiftlint:disable:this identifier_name
