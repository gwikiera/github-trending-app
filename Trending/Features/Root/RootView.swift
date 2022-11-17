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
                .accessibilityIdentifier("RootView.TrendingRepos.MVVM")

                NavigationLink {
                    ReposListViewTCA()
                } label: {
                    Text(L10n.RootView.tca.markdownFormatted)
                }
                .accessibilityIdentifier("RootView.TrendingRepos.TCA")
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
