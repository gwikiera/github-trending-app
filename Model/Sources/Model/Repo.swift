import Foundation
import SwiftUI

public struct Repo: Equatable, Decodable {
    public struct Author: Equatable, Decodable {
        public init(username: String, url: URL, avatar: URL) {
            self.username = username
            self.url = url
            self.avatar = avatar
        }

        public let username: String
        public let url: URL
        public let avatar: URL
    }

    public let name: String
    public let rank: Int
    public let url: URL
    public let description: String?
    public let languageName: String?
    public let languageColor: String?
    public let totalStars: Int
    public let forks: Int
    public let authors: [Author]

    public init(
        name: String,
        rank: Int,
        url: URL,
        description: String? = nil,
        languageName: String? = nil,
        languageColor: String? = nil,
        totalStars: Int,
        forks: Int,
        authors: [Repo.Author]
    ) {
        self.name = name
        self.rank = rank
        self.url = url
        self.description = description
        self.languageName = languageName
        self.languageColor = languageColor
        self.totalStars = totalStars
        self.forks = forks
        self.authors = authors
    }

    enum CodingKeys: String, CodingKey {
        case name = "repositoryName"
        case authors = "builtBy"
        case languageName = "language"
        case rank, url, description, languageColor, totalStars, forks
    }
}

extension Repo: Identifiable {
    public var id: String { name }
}

public extension Repo {
    struct Language: Equatable {
        public let name: String
        public let color: Color

        public init(name: String, color: Color) {
            self.name = name
            self.color = color
        }
    }

    var language: Language? {
        guard let languageName, let languageColor else { return nil }
        return Language(name: languageName, color: Color(hex: languageColor))
    }
}
