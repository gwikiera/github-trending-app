import SnapshotTesting
import SwiftUI
import XCTest
@testable import Trending

final class TrendingSnapshotTests: XCTestCase {
    override func setUp() async throws {
        try await super.setUp()

        Trending.animationsEnabled = false
    }

    func testReposListView_Content() {
        let sut = ReposListView(viewState: .content(Array(repeating: .preview, count: 25)))

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
