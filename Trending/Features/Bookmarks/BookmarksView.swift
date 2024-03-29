import SwiftUI
import DesignSystem
import ComposableArchitecture
import Model

struct BookmarksView: View {
    let store: StoreOf<Bookmarks>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                ForEach(viewStore.state.reposViewStates, id: \.name) { repoCellViewState in
                    Button(
                        action: { viewStore.send(.setSelectedRepoId(repoCellViewState.id)) },
                        label: {
                            RepoCell(viewState: repoCellViewState)
                        }
                    )
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let id = viewStore.state.reposViewStates[index].id
                        viewStore.send(.removeBookmarkRepoId(id))
                    }
                }
            }
            .navigationDestination(
                unwrapping: viewStore.binding(
                    get: \.selectedRepoViewState,
                    send: { _ in
                            .setSelectedRepoId(nil)
                    }
                )
            ) { $selectedRepoViewState in
                RepoDetailsView(viewState: selectedRepoViewState)
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
            .navigationTitle(L10n.Bookmarks.title)
        }
    }
}

extension BookmarksView {
    init() {
        self.init(store: .init(initialState: .init(reposViewStates: []), reducer: Bookmarks()))
    }
}

#if DEBUG
import PreviewSnapshots

struct BookmarksView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }

    static var snapshots: PreviewSnapshots<Bookmarks.ViewState> {
        PreviewSnapshots(
            configurations: [.init(name: "", state: .init(reposViewStates: .preview))],
            configure: { viewState in
                NavigationView {
                    BookmarksView(store: .preview(viewState))
                }
            }
        )
    }
}
#endif
