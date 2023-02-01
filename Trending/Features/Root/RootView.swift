import SwiftUI
import SwiftUINavigation

struct RootView: View {
    enum Destination {
        case reposListMVVM
        case reposListTCA
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
            .listStyle(.inset)
            .navigationTitle(L10n.RootView.title)
        }
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
#endif
