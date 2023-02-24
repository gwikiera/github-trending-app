import SwiftUI
import DesignSystem
import SwiftUINavigation

struct ReposListView: View {
    typealias ViewState = [RepoCell.ViewState]

    @ObservedObject var viewModel: ReposListViewModel

    init(viewModel: ReposListViewModel = .init()) {
        self.viewModel = viewModel
    }

    var body: some View {
        Group {
            switch viewModel.viewState {
            case let .content(repos):
                content(viewState: repos)
            case .error:
                error
            case .loading:
                ProgressView()
            }
        }
        .task {
            await viewModel.fetchRepos()
        }
        .navigationTitle(L10n.ReposList.title)
    }

    @ViewBuilder
    private func content(viewState: ViewState) -> some View {
        List {
            ForEach(viewState, id: \.name) { repoCellViewState in
                Button {
                    viewModel.repoTapped(repoCellViewState.id)
                } label: {
                    RepoCell(viewState: repoCellViewState)
                }
            }
        }
        .refreshable {
            await viewModel.fetchRepos()
        }
        .navigationDestination(
            unwrapping: $viewModel.destination,
            case: /ReposListViewModel.Destination.repoDetails) { $reposDetailsViewModel in
                RepoDetailsView(viewState: reposDetailsViewModel)
        }
    }

    @ViewBuilder
    private var error: some View {
        VStack {
            Spacer()

            Text("😥")
                .font(.largeTitle)
            Text(L10n.ReposList.Error.label)
                .font(.title2)

            Spacer()

            Button {
                Task {
                    await viewModel.fetchRepos()
                }
            } label: {
                Text(L10n.ReposList.Error.button)
            }.buttonStyle(.primary)
        }
        .padding(24)
    }
}

#if DEBUG
import PreviewSnapshots

struct ReposListView_Previews: PreviewProvider {
    static var previews: some View {
        snapshots.previews.previewLayout(.sizeThatFits)
    }

    static var snapshots: PreviewSnapshots<ReposListViewModel.ViewState> {
        PreviewSnapshots(
            configurations: [
                .init(name: "Content", state: .content(.preview)),
                .init(name: "Loading", state: .loading),
                .init(name: "Error", state: .error)
            ],
            configure: { state in
                NavigationView {
                    ReposListView(viewState: state)
                }
            }
        )
    }
}

extension ReposListView {
    init(viewState: ReposListViewModel.ViewState) {
        let viewModel = ReposListViewModel()
        viewModel.viewState = viewState
        self.init(viewModel: viewModel)
    }
}

extension Array where Element == RepoCell.ViewState {
    static var preview: Self {
        .init(repeating: .preview, count: 25)
    }
}
#endif
