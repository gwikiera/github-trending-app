import XCTest

struct RootViewPageObject: NavigationPageObject {
    let app: XCUIApplication

    var isPageVisible: Bool {
        app.navigationBars["Trending"].exists
    }

    func tapTrendingReposMVVM() {
        app.buttons["RootView.TrendingRepos.MVVM"].tap()
    }

    func tapTrendingReposTCA() {
        app.buttons["RootView.TrendingRepos.TCA"].tap()
    }
}
