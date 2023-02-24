import SnapshotTesting
import SwiftUI
import XCTest
import PreviewSnapshots
import PreviewSnapshotsTesting
@testable import Trending

final class TrendingSnapshotTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()

        Trending.animationsEnabled = false
        Current = World()
    }

    // MARK: - RootView
    func testRootView() {
        assertSnapshots(RootView_Previews.snapshots)
    }

    // MARK: - ReposListView
    func testReposListView() {
        assertSnapshots(ReposListView_Previews.snapshots)
    }

    // MARK: - ReposListViewTCA
    func testReposListViewTCA() {
        assertSnapshots(ReposListViewTCA_Previews.snapshots)
    }

    // MARK: - RepoDetailsView
    func testRepoDetails() {
        assertSnapshots(RepoDetailsView_Previews.snapshots)
    }

    // MARK: - BookmarksView
    func testBookmarksView() {
        assertSnapshots(BookmarksView_Previews.snapshots)
    }
}

private extension XCTestCase {
    func assertSnapshots<Value> (
        _ snapshots: @autoclosure () -> PreviewSnapshots<Value>,
        record recording: Bool = false,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        snapshots().assertSnapshots(
            as: [.image(precision: 0.99, perceptualPrecision: 0.99, layout: .device(config: .iPhone13Pro))],
            record: recording,
            file: file,
            testName: testName,
            line: line
        )
    }
}
