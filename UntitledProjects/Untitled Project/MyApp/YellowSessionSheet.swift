import SwiftUI

// MARK: - Liquid Glass Yellow Network ClearSync Session Sheet
public struct YellowSessionSheet: View {
    @ObservedObject var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    @State private var depositAmount: String = "25.00"
    @State private var withdrawAmount: String = "10.00"

    public var body: some View {
        ZStack {
            AmbientLiquidBackgroundView()

            VStack(spacing: 0) {
                // Header (Liquid Glass)
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("YELLOW NETWORK STATE CHANNEL")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                            .tracking(1.5)
                        Text("CLEARSYNC SESSION")
                            .font(.system(size: 13, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.85)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                )
                .padding(.horizontal, 12)
                .padding(.top, 4)

                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Channel Balance Display (Liquid Glass Card)
                        VStack(alignment: .leading, spacing: 6) {
                            Text("OFF-CHAIN SESSION BALANCE")
                                .font(.system(size: 8, weight: .bold, design: .monospaced))
                                .foregroundColor(.cyberMuted)

                            HStack(alignment: .bottom, spacing: 6) {
                                Text("\(String(format: "%.2f", engine.ytestBalance))")
                                    .font(.system(size: 28, weight: .black, design: .monospaced))
                                    .foregroundColor(.neonGreen)
                                Text("$YTEST")
                                    .font(.system(size: 14, weight: .black, design: .monospaced))
                                    .foregroundColor(.cyberYellow)
                                    .padding(.bottom, 4)
                            }

                            HStack {
                                Circle().fill(Color.neonGreen).frame(width: 6, height: 6)
                                Text("GAS-FREE MICRO-ACTIONS ACTIVE")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.neonGreen)
                                Spacer()
                                Text("SAVED: $\(String(format: "%.2f", engine.gasSavedUSD))")
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .foregroundColor(.neonCyan)
                            }
                        }
                        .padding(14)
                        .liquidGlass(cornerRadius: 18, borderAccent: .cyberYellow, glowRadius: 8)

                        // Deposit Action
                        VStack(alignment: .leading, spacing: 6) {
                            Text("DEPOSIT $YTEST INTO STATE CHANNEL")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.cyberYellow)

                            HStack {
                                TextField("Amount", text: $depositAmount)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(9)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.black.opacity(0.6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(Color.cyberYellow.opacity(0.4), lineWidth: 1)
                                    )

                                Button(action: {
                                    guard let a = Double(depositAmount) else { return }
                                    engine.depositYTest(amount: a)
                                }) {
                                    Text("DEPOSIT")
                                        .font(.system(size: 10, weight: .black, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.cyberYellow)
                                        .clipShape(Capsule())
                                        .shadow(color: Color.cyberYellow.opacity(0.4), radius: 6)
                                }
                            }
                        }
                        .padding(14)
                        .liquidGlass(cornerRadius: 16, borderAccent: .cyberBorderYellow, glowRadius: 6)

                        // Withdraw Action
                        VStack(alignment: .leading, spacing: 6) {
                            Text("WITHDRAW $YTEST TO BASE SEPOLIA")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.neonCyan)

                            HStack {
                                TextField("Amount", text: $withdrawAmount)
                                    .keyboardType(.decimalPad)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                                    .padding(9)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.black.opacity(0.6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(Color.neonCyan.opacity(0.4), lineWidth: 1)
                                    )

                                Button(action: {
                                    guard let a = Double(withdrawAmount) else { return }
                                    engine.withdrawYTest(amount: a)
                                }) {
                                    Text("WITHDRAW")
                                        .font(.system(size: 10, weight: .black, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 10)
                                        .background(Color.neonCyan)
                                        .clipShape(Capsule())
                                        .shadow(color: Color.neonCyan.opacity(0.4), radius: 6)
                                }
                            }
                        }
                        .padding(14)
                        .liquidGlass(cornerRadius: 16, borderAccent: .cyberBorderCyan, glowRadius: 6)

                        // State Channel Explanation
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HOW IT WORKS")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.cyberMuted)

                            Text("Yellow Network state channels allow deploying agents, collecting street coins, and voting in council deliberations completely off-chain with sub-millisecond execution. Settlement only occurs when funding or closing the channel.")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.white.opacity(0.85))
                                .lineSpacing(2)
                        }
                        .padding(12)
                        .liquidGlass(cornerRadius: 14, borderAccent: .white.opacity(0.2), glowRadius: 4)
                    }
                    .padding(16)
                }
            }
        }
    }
}
