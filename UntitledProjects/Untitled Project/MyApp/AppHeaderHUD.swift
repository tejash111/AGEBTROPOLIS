import SwiftUI

// MARK: - Liquid Glass Floating Header HUD
public struct AppHeaderHUD: View {
    @ObservedObject var engine: GameEngine
    var showLevel: Bool = true
    var onWalletTap: () -> Void

    public var body: some View {
        HStack(spacing: 6) {
            // Brand & Level
            HStack(spacing: 4) {
                Text("AGENTROPOLIS")
                    .font(.system(size: 10.5, weight: .black, design: .monospaced))
                    .foregroundColor(.cyberYellow)
                    .tracking(1.0)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                if showLevel {
                    Capsule()
                        .fill(Color.cyberYellow.opacity(0.35))
                        .frame(width: 1.5, height: 12)

                    HStack(spacing: 1.5) {
                        Text("LVL")
                            .font(.system(size: 7.5, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyberMuted)
                        Text("\(engine.level)")
                            .font(.system(size: 9, weight: .black, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                    }
                }
            }

            Spacer(minLength: 4)

            // $YTEST Glass Pill
            HStack(spacing: 3) {
                Text("$YTEST")
                    .font(.system(size: 7.5, weight: .black, design: .monospaced))
                    .foregroundColor(.neonGreen)
                Text(String(format: "%.2f", engine.ytestBalance))
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 7)
            .padding(.vertical, 4.5)
            .background(
                Capsule(style: .continuous)
                    .fill(.ultraThinMaterial)
                    .opacity(0.85)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.4), Color.neonGreen.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )

            // Wallet / ENS Pill
            Button(action: onWalletTap) {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.neonCyan)
                        .frame(width: 4, height: 4)
                        .shadow(color: Color.neonCyan, radius: 4)
                    Text(engine.ensName)
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(.neonCyan)
                        .lineLimit(1)
                }
                .padding(.horizontal, 7)
                .padding(.vertical, 4.5)
                .background(
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.85)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.4), Color.neonCyan.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .opacity(0.75)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.35), Color.cyberYellow.opacity(0.3), Color.white.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 12)
        .padding(.top, 4)
    }
}
