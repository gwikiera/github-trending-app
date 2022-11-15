import XCTest

protocol NavigationPageObject {
    var app: XCUIApplication { get }
}

extension NavigationPageObject {
    func tapBack() {
        app.navigationBars.buttons.firstMatch.tap()
    }
}
