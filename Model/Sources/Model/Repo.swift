import Foundation

public struct Repo: Equatable {
    public struct Author: Equatable {
        public init(username: String, url: URL, avatar: URL) {
            self.username = username
            self.url = url
            self.avatar = avatar
        }

        public let username: String
        public let url: URL
        public let avatar: URL
    }

    public struct Language: Equatable {
        public let name: String
        public let colorHex: String

        public init(name: String, colorHex: String) {
            self.name = name
            self.colorHex = colorHex
        }
    }

    public let name: String
    public let rank: Int
    public let url: URL
    public let description: String?
    public let language: Language?
    public let totalStars: Int
    public let forks: Int
    public let authors: [Author]

    public init(
        name: String,
        rank: Int,
        url: URL,
        description: String? = nil,
        language: Language? = nil,
        totalStars: Int,
        forks: Int,
        authors: [Repo.Author]
    ) {
        self.name = name
        self.rank = rank
        self.url = url
        self.description = description
        self.language = language
        self.totalStars = totalStars
        self.forks = forks
        self.authors = authors
    }
}

extension Repo: Identifiable {
    public var id: String { name }
}
