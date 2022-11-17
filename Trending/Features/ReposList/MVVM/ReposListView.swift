import SwiftUI
import DesignSystem

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
                NavigationLink {
                    if let viewState = viewModel.repoDetailsViewState(for: repoCellViewState.id) {
                        RepoDetailsView(viewState: viewState)
                    }
                } label: {
                    RepoCell(viewState: repoCellViewState)
                }
            }
        }
        .refreshable {
            await viewModel.fetchRepos()
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
struct ReposListView_Previews: PreviewProvider {
    static var previews: some View {
        ReposListView(viewState: .content(.preview))
            .previewDisplayName("Content")

        ReposListView(viewState: .loading)
            .previewDisplayName("Loading")

        ReposListView(viewState: .error)
            .previewDisplayName("Error")
    }
}

extension ReposListView {
    init(viewState: ReposListViewModel.ViewState) {
        Current = .preview
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
