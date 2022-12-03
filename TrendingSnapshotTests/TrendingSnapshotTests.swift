import SnapshotTesting
import SwiftUI
import XCTest
@testable import Trending

final class TrendingSnapshotTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()

        Trending.animationsEnabled = false
        Current = World()
    }

    // MARK: - RootView
    func testRootView() {
        let sut = RootView()

        assertSnapshots(sut)
    }

    // MARK: - ReposListView
    func testReposListView_Content() {
        let sut = ReposListView(viewState: .content(.preview))

        assertSnapshots(sut)
    }

    func testReposListView_Loading() {
        let sut = ReposListView(viewState: .loading)

        assertSnapshots(sut)
    }

    func testReposListView_Error() {
        let sut = ReposListView(viewState: .error)

        assertSnapshots(sut)
    }

    // MARK: - ReposListView
    func testReposListViewTCA_Content() {
        let sut = ReposListViewTCA(store: .preview(.init(cle: .content(.preview))))

        assertSnapshots(sut)
    }

    func testReposListViewTCA_Loading() {
        let sut = ReposListViewTCA(store: .preview(.init(cle: .loading)))

        assertSnapshots(sut)
    }

    func testReposListViewTCA_Error() {
        let sut = ReposListViewTCA(store: .preview(.init(cle: .error)))

        assertSnapshots(sut)
    }

    // MARK: - RepoDetailsView
    func testRepoDetails() {
        let sut = RepoDetailsView(viewState: .preview)

        assertSnapshots(sut)
    }
}

private extension XCTestCase {
    func assertSnapshots<Value> (
        _ view: @autoclosure () -> Value,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) where Value: View {
        SnapshotTesting.assertSnapshots(
            matching: view().ignoresSafeArea(),
            as: [.image(precision: 0.99, perceptualPrecision: 0.99, layout: .device(config: .iPhone13Pro))],
            record: recording,
            file: file,
            testName: testName,
            line: line
        )
    }
}
