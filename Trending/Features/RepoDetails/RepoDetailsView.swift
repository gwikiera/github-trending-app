import SwiftUI

struct RepoDetailsView: View {
    struct ViewState: Equatable {
        let name: String
        let rank: Int
        let url: URL
        let description: String?
        let language: Repo.Language?
        let stars: Int
        let forks: Int
        let authors: [Repo.Author]
    }

    let viewState: ViewState
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                HStack(spacing: 15) {
                    Image(systemName: "book.closed")
                        .resizable()
                        .frame(width: 40, height: 40)

                    Button(action: { openURL(viewState.url) }) {
                        Text(viewState.name)
                            .underline()
                            .multilineTextAlignment(.leading)
                            .font(.title)
                    }
                }

                if let description = viewState.description {
                    Text(description)
                        .font(.title2)
                }

                Text("\(L10n.RepoDetails.rank): **\(viewState.rank)**")
                    .font(.title3)

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

                Text("\(L10n.RepoDetails.authors):")
                    .font(.subheadline)

                ForEach(viewState.authors, id: \.username) { author in
                    HStack(spacing: 5) {
                        AsyncImage(
                            url: author.avatar,
                            content: { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )

                        Button(action: { openURL(author.url) }) {
                            Text(author.username)
                                .underline()
                                .font(.subheadline)
                        }

                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(24)
            .navigationTitle(viewState.name)
            .accessibilityIdentifier(A11yIDs.RepoDetails.id)
        }
    }
}

#if DEBUG
struct RepoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        RepoDetailsView(viewState: .preview)
    }
}

extension RepoDetailsView.ViewState {
    static var preview: RepoDetailsView.ViewState {
        RepoDetailsView.ViewState(
            name: "timhutton / twitter-archive-parser",
            rank: 1,
            url: "https://github.com/timhutton/twitter-archive-parser",
            description: "Python code to parse a Twitter archive and output in various ways",
            language: .init(name: "Python", color: .red),
            stars: 908,
            forks: 36,
            authors: [
                Repo.Author(
                    username: "timhutton",
                    url: "https://github.com/timhutton",
                    avatar: "https://avatars.githubusercontent.com/u/647092?s=40&v=4"
                ),
                Repo.Author(
                    username: "clayote",
                    url: "https://github.com/clayote",
                    avatar: "https://avatars.githubusercontent.com/u/1334358?s=40&v=4"
                )
            ]
        )
    }
}
#endif
