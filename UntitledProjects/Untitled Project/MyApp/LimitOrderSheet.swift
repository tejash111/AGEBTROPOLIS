import SwiftUI

// MARK: - Liquid Glass Limit Order Modal & Trade Tower Construction
public struct LimitOrderSheet: View {
    @ObservedObject var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    @State private var tokenIn: String = "WETH"
    @State private var tokenOut: String = "USDC"
    @State private var direction: String = "BUY"
    @State private var targetPrice: String = "2650.00"
    @State private var amount: String = "0.25"
    @State private var isPlacing: Bool = false

    public var body: some View {
        ZStack {
            AmbientLiquidBackgroundView()

            VStack(spacing: 0) {
                // Header (Liquid Glass)
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("UNISWAP V4 HOOK")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(.neonCyan)
                            .tracking(1.5)
                        Text("PLACE LIMIT ORDER")
                            .font(.system(size: 13, weight: .black, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                            .tracking(1.8)
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
                        // Direction Selector (BUY / SELL Glass Pills)
                        HStack(spacing: 8) {
                            Button(action: { direction = "BUY" }) {
                                Text("BUY WETH")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .foregroundColor(direction == "BUY" ? .black : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(direction == "BUY" ? Color.neonGreen : Color.white.opacity(0.08))
                                    )
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .stroke(direction == "BUY" ? Color.white.opacity(0.7) : Color.white.opacity(0.15), lineWidth: 1)
                                    )
                                    .shadow(color: direction == "BUY" ? Color.neonGreen.opacity(0.4) : .clear, radius: 6)
                            }

                            Button(action: { direction = "SELL" }) {
                                Text("SELL WETH")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .foregroundColor(direction == "SELL" ? .black : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 9)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(direction == "SELL" ? Color.neonOrange : Color.white.opacity(0.08))
                                    )
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .stroke(direction == "SELL" ? Color.white.opacity(0.7) : Color.white.opacity(0.15), lineWidth: 1)
                                    )
                                    .shadow(color: direction == "SELL" ? Color.neonOrange.opacity(0.4) : .clear, radius: 6)
                            }
                        }

                        // Token Pair Swapper (Liquid Glass)
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("FROM")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cyberMuted)
                                Text(tokenIn)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.black.opacity(0.5))
                            )

                            Button(action: {
                                let tmp = tokenIn
                                tokenIn = tokenOut
                                tokenOut = tmp
                            }) {
                                Image(systemName: "arrow.left.arrow.right")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.cyberYellow)
                                    .padding(8)
                                    .background(Color.cyberYellow.opacity(0.2))
                                    .clipShape(Circle())
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text("TO")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cyberMuted)
                                Text(tokenOut)
                                    .font(.system(size: 12, weight: .black, design: .monospaced))
                                    .foregroundColor(.neonCyan)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.black.opacity(0.5))
                            )
                        }

                        // Target Price Field
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("TARGET PRICE (USDC)")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cyberYellow)
                                Spacer()
                                Text("CURRENT: $2680.50")
                                    .font(.system(size: 8, design: .monospaced))
                                    .foregroundColor(.cyberMuted)
                            }

                            TextField("Target Price", text: $targetPrice)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 14, weight: .black, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.black.opacity(0.6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.cyberYellow.opacity(0.4), lineWidth: 1)
                                )
                        }

                        // Amount Field
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("ORDER AMOUNT")
                                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                                    .foregroundColor(.cyberYellow)
                                Spacer()
                                Text("BALANCE: \(String(format: "%.3f", engine.ethBalance)) WETH")
                                    .font(.system(size: 8, design: .monospaced))
                                    .foregroundColor(.neonGreen)
                            }

                            TextField("Amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .font(.system(size: 14, weight: .black, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.black.opacity(0.6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(Color.cyberYellow.opacity(0.4), lineWidth: 1)
                                )
                        }

                        // Order Preview & Hook Visualizer (Liquid Glass)
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("PHYSICAL METROPOLIS STRUCTURE")
                                    .font(.system(size: 7, weight: .bold, design: .monospaced))
                                    .foregroundColor(.neonCyan)
                                Spacer()
                                Text("TRADE TOWER")
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .foregroundColor(.cyberYellow)
                            }

                            Text("When constructed, a physical Trade Tower will rise in your city map. When Uniswap v4 pool price touches target, tower illuminates gold and yields fill settlement.")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.white.opacity(0.85))
                                .lineSpacing(2)
                        }
                        .padding(12)
                        .liquidGlass(cornerRadius: 14, borderAccent: .neonCyan, glowRadius: 6)

                        // Submit Button (Liquid Glass Capsule)
                        Button(action: {
                            guard let p = Double(targetPrice), let a = Double(amount) else { return }
                            isPlacing = true
                            engine.placeLimitOrder(
                                tokenIn: tokenIn,
                                tokenOut: tokenOut,
                                direction: direction,
                                targetPrice: p,
                                amount: a
                            )
                            dismiss()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "building.2.crop.circle")
                                Text("CONSTRUCT TRADE TOWER")
                                    .font(.system(size: 11, weight: .black, design: .monospaced))
                                    .tracking(1.5)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.cyberYellow)
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
                            )
                            .shadow(color: Color.cyberYellow.opacity(0.5), radius: 8)
                        }
                        .padding(.top, 8)
                    }
                    .padding(16)
                }
            }
        }
    }
}
