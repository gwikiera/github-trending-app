import Foundation

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(string: value)! // swiftlint:disable:this force_unwrapping
    }
}
