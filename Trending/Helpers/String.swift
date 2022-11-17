import Foundation

extension String {

    /**
     *  The string is interpreted as Markdown and the format is
     *  applied to the returned attributed string.
     *
     *  This property assumes that the underlying string contains
     *  valid Markdown. As a fallback, the receiving string is
     *  returned as-is.
     */
    var markdownFormatted: AttributedString {
        do {
            return try .init(markdown: self)
        } catch {
            assertionFailure("Unable to create markdown from raw text: \(self)")
            return .init(self)
        }
    }
}
