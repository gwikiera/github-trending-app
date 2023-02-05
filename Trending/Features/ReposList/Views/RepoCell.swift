import SwiftUI
import Model
import DesignSystem

struct RepoCell: View {
    struct ViewState: Equatable {
        struct Language: Equatable {
            let name: String
            let color: Color
        }

        let id: Repo.ID
        let name: String
        let description: String?
        let language: Language?
        let stars: Int
        let forks: Int
        var bookmarked: Bool
    }

    let viewState: ViewState

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                Image(systemName: "book.closed")

                Text(viewState.name)
                    .font(.headline)
            }

            if let description = viewState.description {
                Text(description)
                    .font(.subheadline)
            }

            HStack(spacing: 15) {
                if let language = viewState.language {
                    HStack(spacing: 5) {
                        language.color
                            .clipShape(Circle())
                            .frame(width: 10, height: 10)

                        Text(language.name)
                            .font(.subheadline)
                    }
                }

                HStack(spacing: 5) {
                    Image(systemName: "star")

                    Text("\(viewState.stars)")
                        .font(.subheadline)
                }

                HStack(spacing: 5) {
                    Image(systemName: "arrow.triangle.branch")

                    Text("\(viewState.forks)")
                        .font(.subheadline)
                }

                Spacer(minLength: 0)

                if viewState.bookmarked {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(Asset.primary.swiftUIColor)
                        .padding(.horizontal, 15)
                        .transition(.asymmetric(
                            insertion: .scale.animation(.interactiveSpring(response: 0.25, dampingFraction: 0.5)),
                            removal: .scale
                        ))
                }
            }
        }
    }
}

#if DEBUG
struct RepoCell_Previews: PreviewProvider {
    static var previews: some View {
        RepoCell(viewState: .preview)
            .frame(width: 390)
    }
}

extension RepoCell.ViewState {
    static var preview: RepoCell.ViewState {
        RepoCell.ViewState(
            id: "twitter-archive-parser",
            name: "timhutton / twitter-archive-parser",
            description: "Python code to parse a Twitter archive and output in various ways",
            language: .init(name: "Python", color: .red),
            stars: 908,
            forks: 36,
            bookmarked: true
        )
    }
}
#endif
