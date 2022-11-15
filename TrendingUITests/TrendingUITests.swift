import XCTest

final class TrendingUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let reposList = ReposListViewPageObject(app: app)
        XCTAssertTrue(reposList.isLoadingIndicatorVisible)
        XCTAssertTrue(reposList.isContentVisible)
        reposList.tapFirstCell()

        let repoDetails = RepoDetailsPageObject(app: app)
        XCTAssertTrue(repoDetails.isPageVisible)
        repoDetails.tapBack()

        XCTAssertTrue(reposList.isContentVisible)
    }
}
