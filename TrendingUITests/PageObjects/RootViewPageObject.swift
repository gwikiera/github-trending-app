import XCTest

struct RootViewPageObject: NavigationPageObject {
    let app: XCUIApplication

    var isPageVisible: Bool {
        app.navigationBars[A11yIDs.RootView.navigationBarTitle].exists
    }

    func tapTrendingReposMVVM() {
        app.buttons[A11yIDs.RootView.trendingReposMVVM].tap()
    }

    func tapTrendingReposTCA() {
        app.buttons[A11yIDs.RootView.trendingReposTCA].tap()
    }
}
