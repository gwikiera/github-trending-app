import SwiftUI
import DesignSystem
import ComposableArchitecture
import Model

struct ReposListViewTCA: View {
    let store: StoreOf<ReposList>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            Group {
                switch viewStore.state.cle {
                case .content:
                    IfLetStore(store.scope(state: { viewState -> ContentView.ViewState? in
                        guard case let .content(cells) = viewState.cle else { return nil }
                        return .init(
                            cells: cells,
                            selectedRepoViewState: viewState.selectedRepoViewState
                        )
                    })) { store in
                        ContentView(store: store)
                    }
                case .loading:
                    ProgressView()
                case .error:
                    IfLetStore(store.scope(state: { viewState -> Void? in
                        guard case .error = viewState.cle else { return nil }
                        return ()
                    })) { store in
                        ErrorView(store: store)
                    }
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
                viewStore.send(.fetchRepos)
            }
            .navigationTitle(L10n.ReposList.title)
        }
    }
}

private struct ContentView: View {
    struct ViewState: Equatable {
        let cells: [RepoCell.ViewState]
        let selectedRepoViewState: RepoDetailsView.ViewState?
    }

    let store: Store<ViewState, ReposList.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.state.cells, id: \.name) { repoCellViewState in
                    Button(
                        action: { viewStore.send(.setSelectedRepoId(repoCellViewState.id)) },
                        label: {
                            RepoCell(viewState: repoCellViewState)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        if repoCellViewState.bookmarked {
                                            viewStore.send(.removeBookmarkRepoId(repoCellViewState.id))
                                        } else {
                                            viewStore.send(.bookmarkRepoId(repoCellViewState.id))
                                        }
                                    } label: {
                                        Image(systemName: repoCellViewState.bookmarked ? "bookmark.slash" : "bookmark")
                                    }
                                    .tint(Asset.primary.swiftUIColor)
                                }
                        }
                    )
                }
            }
            .refreshable {
                await viewStore.send(.fetchRepos).finish()
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
        }
    }
}

private struct ErrorView: View {
    let store: Store<Void, ReposList.Action>

    var body: some View {
        VStack {
            Spacer()

            Text("😥")
                .font(.largeTitle)
            Text(L10n.ReposList.Error.label)
                .font(.title2)

            Spacer()

            WithViewStore(self.store) { viewStore in
                Button {
                    viewStore.send(.fetchRepos)
                } label: {
                    Text(L10n.ReposList.Error.button)
                }.buttonStyle(.primary)
            }
        }
        .padding(24)
    }
}

extension ReposListViewTCA {
    init() {
        self.init(store: .init(initialState: .init(cle: .loading), reducer: ReposList()))
    }
}

#if DEBUG
import PreviewSnapshots

struct ReposListViewTCA_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }

    static var snapshots: PreviewSnapshots<ReposList.ViewState.CLE> {
        PreviewSnapshots(
            configurations: [
                .init(name: "Content", state: .content(.preview)),
                .init(name: "Loading", state: .loading),
                .init(name: "Error", state: .error)
            ],
            configure: { cle in
                NavigationView {
                    ReposListViewTCA(store: .preview(.init(cle: cle)))
                }
            }
        )
    }
}
#endif
