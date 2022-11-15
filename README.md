Project written in Swift, using SwiftUI, Combine and Swfit Concurency. 

# How to Run the Project

### Project and code generation:

#### Prerequisites
- Xcode 14.1.x
- Simulator for snapshot tests: `iPhone 14 Pro (iOS 16.1)`
- [XcodeGen](https://github.com/yonaskolb/XcodeGen)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)

#### Script
Just run `sh bootstrap.sh`.

# Tools

- [XcodeGen](https://github.com/yonaskolb/XcodeGen)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)
- [Fastlane](https://fastlane.tools/)
- [GitHub Actions](https://github.com/features/actions)
- [SwiftLint](https://github.com/realm/SwiftLint)

# Test

### Unit tests 

- [TrendingUnitTests](https://github.com/gwikiera/github-trending-app/tree/main/TrendingUnitTests)
- [NetworkingTests](https://github.com/gwikiera/github-trending-app/tree/main/Networking/Tests/NetworkingTests)

### Snapshot tests
- [TrendingSnapshotTests](https://github.com/gwikiera/github-trending-app/blob/main/TrendingSnapshotTests/TrendingSnapshotTests.swift) using [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing)

### UI Tests
- [TrendingUITests](https://github.com/gwikiera/github-trending-app/blob/main/TrendingUITests/TrendingUITests.swift) using page object pattern.