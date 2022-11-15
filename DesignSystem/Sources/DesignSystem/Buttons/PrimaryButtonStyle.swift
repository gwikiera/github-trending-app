import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        PrimaryButton(configuration: configuration)
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

private struct PrimaryButton: View {
    let configuration: PrimaryButtonStyle.Configuration

    private var foregroundColor: Color {
        Asset.text.swiftUIColor
    }

    private var backgroundColor: Color {
        let color = Asset.primary.swiftUIColor
        return configuration.isPressed ? color.opacity(0.5) : color
    }

    var body: some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(width: 256, height: 48)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .lineLimit(1)
            .clipShape(Capsule())
    }
}

#if DEBUG
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("PRIMARY BUTTON", action: {})
            .buttonStyle(.primary)
    }
}
#endif
