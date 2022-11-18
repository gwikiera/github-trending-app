import SwiftUI

struct RootView: View {
    var body: some View {
        List {
            Section(L10n.RootView.TrendingRepos.title) {
                NavigationLink {
                    ReposListView()
                } label: {
                    Text(L10n.RootView.mvvm.markdownFormatted)
                }
                .accessibilityIdentifier(A11yIDs.RootView.trendingReposMVVM)

                NavigationLink {
                    ReposListViewTCA()
                } label: {
                    Text(L10n.RootView.tca.markdownFormatted)
                }
                .accessibilityIdentifier(A11yIDs.RootView.trendingReposTCA)
            }
        }
        .listStyle(.inset)
        .navigationTitle(L10n.RootView.title)
    }
}

#if DEBUG
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RootView()
        }
    }
}
#endif
