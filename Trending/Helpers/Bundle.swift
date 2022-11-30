import Foundation

// swiftlint:disable force_unwrapping
extension Bundle {
    var baseURL: URL { URL(string: "\(infoDictionary!["BASE_URL"]!)")! }
}
