import Foundation
import GitHubAPIClient
import Model

#if MOCK_API
 class MockGitHubAPIClient: GitHubAPIClient {
     func trendingRepos() async throws -> [Model.Repo] {
         try await Task.sleep(nanoseconds: 500_000_000)

         return (1...25).compactMap { index -> Repo? in
             guard let avatarURL = Bundle.main.url(forResource: "avatar", withExtension: "png") else { return nil }
             let languages = [
                Repo.Language(name: "Swift", colorHex: "#F05138"),
                Repo.Language(name: "Kotlin", colorHex: "#A97BFF"),
                Repo.Language(name: "Python", colorHex: "#b07219")
             ]
             return .init(
                name: "Trending repo \(index)",
                rank: 1,
                url: "www.github.com",
                description: "Trending repo \(index) description",
                language: languages[index % languages.count],
                totalStars: 2000,
                forks: 100,
                authors: [
                    .init(
                        username: "Author \(index)",
                        url: "www.github.com",
                        avatar: avatarURL
                    )
                ]
             )
         }
     }
}
#endif
