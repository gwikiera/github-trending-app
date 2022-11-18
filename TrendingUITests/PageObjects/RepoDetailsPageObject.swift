import XCTest

struct RepoDetailsPageObject: NavigationPageObject {
    let app: XCUIApplication

    var isPageVisible: Bool {
        app.staticTexts[A11yIDs.RepoDetails.id].waitForExistence(timeout: 10)
    }

    func tapBack() {
        app.navigationBars.buttons.firstMatch.tap()
    }
}
