import SwiftUI

// MARK: - Cyberpunk & Liquid Glass Color Palette
extension Color {
    public static let cyberBackground = Color(hex: "060614")
    public static let liquidGlassBg = Color(hex: "0d0d26").opacity(0.60)
    public static let liquidGlassCard = Color(hex: "121235").opacity(0.55)
    public static let liquidGlassDark = Color(hex: "070716").opacity(0.75)
    
    // Core Neon Accents
    public static let cyberYellow = Color(hex: "FCEE0A")
    public static let neonGreen = Color(hex: "00FF88")
    public static let neonCyan = Color(hex: "00F0FF")
    public static let neonMagenta = Color(hex: "FF00FF")
    public static let neonOrange = Color(hex: "FF8800")
    public static let neonRed = Color(hex: "FF3366")
    public static let neonPurple = Color(hex: "B026FF")
    
    // Specular / Glass Glassmorphism
    public static let glassSpecular = Color.white.opacity(0.40)
    public static let glassBorder = Color.white.opacity(0.18)
    public static let cyberMuted = Color(hex: "8A8AA8")
    public static let cyberBorder = Color(hex: "232342")
    public static let cyberBorderYellow = Color(hex: "FCEE0A").opacity(0.35)
    public static let cyberBorderCyan = Color(hex: "00F0FF").opacity(0.35)

    init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var int: UInt64 = 0
        scanner.scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Ambient Liquid Aurora Glowing Background
// Provides colored fluid light sources that refract beautifully through frosted glass
public struct AmbientLiquidBackgroundView: View {
    @State private var animateBlobs = false

    public init() {}

    public var body: some View {
        ZStack {
            Color.cyberBackground.ignoresSafeArea()

            // Liquid Fluid Light Orbs
            GeometryReader { geo in
                ZStack {
                    // Cyan Fluid Orb (Top-Left)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.neonCyan.opacity(0.35), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 180
                            )
                        )
                        .frame(width: 320, height: 320)
                        .offset(x: animateBlobs ? -40 : 20, y: animateBlobs ? 60 : -20)
                        .blur(radius: 50)

                    // Magenta Fluid Orb (Center-Right)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.neonMagenta.opacity(0.28), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        )
                        .frame(width: 360, height: 360)
                        .offset(x: animateBlobs ? geo.size.width - 120 : geo.size.width - 60, y: animateBlobs ? 240 : 180)
                        .blur(radius: 60)

                    // Cyber Yellow / Green Orb (Bottom-Center)
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.cyberYellow.opacity(0.22), Color.neonGreen.opacity(0.18), Color.clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: 190
                            )
                        )
                        .frame(width: 340, height: 340)
                        .offset(x: animateBlobs ? 100 : 40, y: animateBlobs ? geo.size.height - 180 : geo.size.height - 240)
                        .blur(radius: 55)
                }
            }
            .ignoresSafeArea()

            // Subtle Cyber Grid Overlay
            CyberGridOverlay()
                .opacity(0.35)
                .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 7.0).repeatForever(autoreverses: true)) {
                animateBlobs = true
            }
        }
    }
}

// Subtle grid lines
struct CyberGridOverlay: View {
    var body: some View {
        Canvas { context, size in
            for x in stride(from: 0, to: size.width, by: 30) {
                var p = Path()
                p.move(to: CGPoint(x: x, y: 0))
                p.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(p, with: .color(Color.white.opacity(0.04)), lineWidth: 0.5)
            }
            for y in stride(from: 0, to: size.height, by: 30) {
                var p = Path()
                p.move(to: CGPoint(x: 0, y: y))
                p.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(p, with: .color(Color.white.opacity(0.04)), lineWidth: 0.5)
            }
        }
    }
}

// MARK: - Liquid Glass Card Modifier
public struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    var borderAccent: Color = .neonCyan
    var glowRadius: CGFloat = 8
    var opacity: Double = 0.65

    public func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // Blur & Translucent Base
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.92)

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.10),
                                    Color(hex: "0d0d2b").opacity(opacity)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    // Specular Top Sheen (Simulating curved glossy liquid glass)
                    VStack {
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.25), Color.clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: 18)
                        Spacer()
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                // Refractive Liquid Border
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.55),
                                borderAccent.opacity(0.5),
                                Color.white.opacity(0.08),
                                borderAccent.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: borderAccent.opacity(0.22), radius: glowRadius, x: 0, y: 3)
            .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 6)
    }
}

extension View {
    public func liquidGlass(
        cornerRadius: CGFloat = 16,
        borderAccent: Color = .neonCyan,
        glowRadius: CGFloat = 8,
        opacity: Double = 0.65
    ) -> some View {
        self.modifier(LiquidGlassModifier(
            cornerRadius: cornerRadius,
            borderAccent: borderAccent,
            glowRadius: glowRadius,
            opacity: opacity
        ))
    }
}

// MARK: - Liquid Glass Capsule Button
public struct LiquidGlassButton: View {
    let title: String
    var icon: String? = nil
    var accentColor: Color = .cyberYellow
    var isGlowing: Bool = false
    let action: () -> Void

    @State private var isPressed = false

    public init(
        title: String,
        icon: String? = nil,
        accentColor: Color = .cyberYellow,
        isGlowing: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.accentColor = accentColor
        self.isGlowing = isGlowing
        self.action = action
    }

    public var body: some View {
        Button(action: {
            let gen = UIImpactFeedbackGenerator(style: .medium)
            gen.impactOccurred()
            action()
        }) {
            HStack(spacing: 6) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .black))
                }
                Text(title)
                    .font(.system(size: 11, weight: .black, design: .monospaced))
                    .tracking(1.4)
            }
            .foregroundColor(accentColor == .cyberYellow ? .black : .white)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(
                ZStack {
                    Capsule(style: .continuous)
                        .fill(accentColor.opacity(isPressed ? 1.0 : 0.90))

                    Capsule(style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [Color.white.opacity(0.35), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.6), accentColor.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: accentColor.opacity(0.4), radius: isGlowing ? 10 : 5, x: 0, y: 2)
            .scaleEffect(isPressed ? 0.96 : 1.0)
        }
    }
}

// MARK: - Liquid Glass Badge Pill
public struct LiquidGlassBadge: View {
    let label: String
    let value: String
    var accentColor: Color = .cyberYellow

    public init(label: String, value: String, accentColor: Color = .cyberYellow) {
        self.label = label
        self.value = value
        self.accentColor = accentColor
    }

    public var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.cyberMuted)
            Text(value)
                .font(.system(size: 10, weight: .black, design: .monospaced))
                .foregroundColor(accentColor)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.85)
        )
        .overlay(
            Capsule(style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), accentColor.opacity(0.4)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}
