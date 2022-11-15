import Foundation
import SwiftUI

struct Repo: Equatable, Decodable {
    struct Author: Equatable, Decodable {
        let username: String
        let url: URL
        let avatar: URL
    }

    let name: String
    let rank: Int
    let url: URL
    let description: String?
    let languageName: String?
    let languageColor: String?
    let totalStars: Int
    let forks: Int
    let authors: [Author]

    enum CodingKeys: String, CodingKey {
        case name = "repositoryName"
        case authors = "builtBy"
        case languageName = "language"
        case rank, url, description, languageColor, totalStars, forks
    }
}

extension Repo: Identifiable {
    var id: String { name }
}

extension Repo {
    struct Language: Equatable {
        let name: String
        let color: Color
    }

    var language: Language? {
        guard let languageName, let languageColor else { return nil }
        return Language(name: languageName, color: Color(hex: languageColor))
    }
}
