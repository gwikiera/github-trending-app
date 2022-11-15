import XCTest

struct ReposListViewPageObject: NavigationPageObject {
    let app: XCUIApplication

    var isLoadingIndicatorVisible: Bool {
        app.activityIndicators.firstMatch.exists
    }

    var isContentVisible: Bool {
        app.collectionViews.firstMatch.waitForExistence(timeout: 10)
    }

    func tapFirstCell() {
        app.collectionViews.firstMatch.cells.firstMatch.tap()
    }
}
