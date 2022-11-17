import XCTest

final class TrendingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let rootView = RootViewPageObject(app: app)
        XCTAssertTrue(rootView.isPageVisible)

        // Trending Repos MVVM
        rootView.tapTrendingReposMVVM()
        testTrendingReposFlow(app)
        XCTAssertTrue(rootView.isPageVisible)

        // Trending Repos TCA
        rootView.tapTrendingReposTCA()
        testTrendingReposFlow(app)
        XCTAssertTrue(rootView.isPageVisible)
    }

    private func testTrendingReposFlow(_ app: XCUIApplication) {
        let reposList = ReposListViewPageObject(app: app)
        XCTAssertTrue(reposList.isLoadingIndicatorVisible)
        XCTAssertTrue(reposList.isContentVisible)
        reposList.tapFirstCell()

        let repoDetails = RepoDetailsPageObject(app: app)
        XCTAssertTrue(repoDetails.isPageVisible)
        repoDetails.tapBack()

        XCTAssertTrue(reposList.isContentVisible)
        reposList.tapBack()
    }
}
