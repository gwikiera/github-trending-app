import SwiftUI
import SwiftUINavigation

struct RootView: View {
    enum Destination {
        case reposListMVVM
        case reposListTCA
        case bookmarks
    }

    @State private var destination: Destination?

    var body: some View {
        NavigationStack {
            List {
                Section(L10n.RootView.TrendingRepos.title) {
                    Button {
                        destination = .reposListMVVM
                    } label: {
                        Text(L10n.RootView.mvvm.markdownFormatted)
                    }
                    .accessibilityIdentifier(A11yIDs.RootView.trendingReposMVVM)

                    Button {
                        destination = .reposListTCA
                    } label: {
                        Text(L10n.RootView.tca.markdownFormatted)
                    }
                    .accessibilityIdentifier(A11yIDs.RootView.trendingReposTCA)
                }

                Section {
                    Button {
                        destination = .bookmarks
                    } label: {
                        Text(L10n.RootView.bookmarks.markdownFormatted)
                    }
                    .accessibilityIdentifier(A11yIDs.RootView.bookmarks)
                }
            }
            .navigationDestination(
                unwrapping: $destination,
                case: /Destination.reposListMVVM,
                destination: { _ in
                    ReposListView()
                })
            .navigationDestination(
                unwrapping: $destination,
                case: /Destination.reposListTCA,
                destination: { _ in
                    ReposListViewTCA()
                })
            .navigationDestination(
                unwrapping: $destination,
                case: /Destination.bookmarks,
                destination: { _ in
                    BookmarksView()
                })
            .listStyle(.inset)
            .navigationTitle(L10n.RootView.title)
        }
    }
}

#if DEBUG
import PreviewSnapshots

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }

    static var snapshots: PreviewSnapshots<Void> {
        PreviewSnapshots(
            configurations: [.init(name: "", state: ())],
            configure: { _ in
                RootView()
            }
        )
    }
}
#endif
