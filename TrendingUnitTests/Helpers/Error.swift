import Foundation

public class ErrorStub: Error, Equatable, LocalizedError {
    fileprivate init() {}

    public var errorDescription: String? {
        "errorDescription"
    }

    public static func == (lhs: ErrorStub, rhs: ErrorStub) -> Bool {
        return lhs === rhs
    }
}

public let errorStub = ErrorStub()
