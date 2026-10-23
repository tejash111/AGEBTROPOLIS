import SwiftUI

public enum GameScene: String {
    case city = "city"
    case council = "council"
}

public enum MobileTab: String, CaseIterable {
    case city = "CITY"
    case council = "COUNCIL"
    case agents = "AGENTS"
    case orders = "ORDERS"
    case session = "SESSION"

    var icon: String {
        switch self {
        case .city: return "building.2.fill"
        case .council: return "sparkles"
        case .agents: return "cpu.fill"
        case .orders: return "chart.bar.xaxis"
        case .session: return "bolt.horizontal.fill"
        }
    }
}

public struct ContentView: View {
    @StateObject private var engine = GameEngine()
    @State private var currentScene: GameScene = .city
    @State private var currentTab: MobileTab = .city
    @State private var transitionActive: Bool = false
    @State private var showOrdersOverview: Bool = false
    @State private var showWalletInfo: Bool = false

    public var body: some View {
        ZStack {
            // Ambient Liquid Aurora Glows in Background (Refracts through all glass surfaces)
            AmbientLiquidBackgroundView()

            VStack(spacing: 8) {
                // Floating Liquid Glass Header HUD
                AppHeaderHUD(
                    engine: engine,
                    showLevel: currentScene == .city,
                    onWalletTap: {
                        showWalletInfo = true
                    }
                )

                // Main Interactive Scene View
                ZStack {
                    switch currentTab {
                    case .city:
                        CityCanvasView(
                            engine: engine,
                            onEnterCouncil: {
                                switchScene(to: .council)
                            }
                        )
                    case .council:
                        CouncilRoomView(
                            engine: engine,
                            onBack: {
                                switchScene(to: .city)
                            }
                        )
                    case .agents:
                        AgentMarketplaceView(engine: engine)
                    case .orders:
                        OrdersOverviewView(engine: engine)
                    case .session:
                        YellowSessionSheet(engine: engine)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Floating Liquid Glass Bottom Navigation Dock
                HStack(spacing: 6) {
                    ForEach(MobileTab.allCases, id: \.self) { tab in
                        Button(action: {
                            if tab == .council && currentTab != .council {
                                switchScene(to: .council)
                            } else if tab == .city && currentTab != .city {
                                switchScene(to: .city)
                            } else {
                                currentTab = tab
                            }
                        }) {
                            VStack(spacing: 3) {
                                Image(systemName: tab.icon)
                                    .font(.system(size: 13, weight: .bold))
                                Text(tab.rawValue)
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .tracking(0.8)
                            }
                            .foregroundColor(currentTab == tab ? .black : .cyberMuted)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(currentTab == tab ? Color.cyberYellow : Color.clear)
                            )
                            .shadow(color: currentTab == tab ? Color.cyberYellow.opacity(0.5) : .clear, radius: 6)
                        }
                    }
                }
                .padding(6)
                .background(
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.88)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.55),
                                    Color.cyberYellow.opacity(0.4),
                                    Color.white.opacity(0.12)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.45), radius: 12, x: 0, y: 5)
                .padding(.horizontal, 16)
                .padding(.bottom, 6)
            }

            // Transition Overlay ("NEURAL_LINK_ESTABLISHED") matching web app
            if transitionActive {
                Color.black.opacity(0.85).ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 12) {
                            Text("NEURAL_LINK_ESTABLISHED")
                                .font(.system(size: 14, weight: .black, design: .monospaced))
                                .foregroundColor(.neonCyan)
                                .tracking(4.0)

                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.cyberYellow.opacity(0.3))
                                    .frame(width: 180, height: 3)
                                Capsule()
                                    .fill(Color.cyberYellow)
                                    .frame(width: 80, height: 3)
                            }
                        }
                    )
                    .transition(.opacity)
            }

            // Toast Alert Banner (Liquid Glass)
            if let toast = engine.toastMessage {
                VStack {
                    HStack(spacing: 8) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.cyberYellow)
                        Text(toast)
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(12)
                    .liquidGlass(cornerRadius: 14, borderAccent: .cyberYellow, glowRadius: 8)
                    .padding(.horizontal, 16)
                    .padding(.top, 54)

                    Spacer()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: engine.toastMessage)
            }
        }
        .sheet(isPresented: $engine.showPlaceOrderModal) {
            LimitOrderSheet(engine: engine)
        }
        .sheet(isPresented: $engine.showMarketplaceModal) {
            AgentMarketplaceView(engine: engine)
        }
        .sheet(isPresented: $engine.showSessionModal) {
            YellowSessionSheet(engine: engine)
        }
        .sheet(item: $engine.selectedLimitOrder) { order in
            TradeTowerDetailSheet(order: order, engine: engine)
        }
        .alert("CONNECTED WALLET", isPresented: $showWalletInfo) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("ENS: \(engine.ensName)\nAddress: \(engine.walletAddress)\nNetwork: Base Sepolia (Chain ID 84532)\nYellow Session: Active")
        }
    }

    private func switchScene(to scene: GameScene) {
        withAnimation(.easeInOut(duration: 0.2)) {
            transitionActive = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            currentScene = scene
            currentTab = (scene == .city) ? .city : .council
            withAnimation(.easeInOut(duration: 0.25)) {
                transitionActive = false
            }
        }
    }
}

// MARK: - Orders Overview List (Liquid Glass)
struct OrdersOverviewView: View {
    @ObservedObject var engine: GameEngine

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("ACTIVE TRADE TOWERS")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundColor(.cyberYellow)
                Spacer()
                Button(action: {
                    engine.showPlaceOrderModal = true
                }) {
                    Text("+ NEW ORDER")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.cyberYellow)
                        .clipShape(Capsule())
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
                VStack(spacing: 10) {
                    ForEach(engine.limitOrders) { order in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 6) {
                                    Text("\(order.direction) \(order.tokenIn) → \(order.tokenOut)")
                                        .font(.system(size: 11, weight: .black, design: .monospaced))
                                        .foregroundColor(.white)
                                    Text(order.status.rawValue)
                                        .font(.system(size: 7, weight: .black, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 1.5)
                                        .background(order.status.color)
                                        .clipShape(Capsule())
                                }
                                Text("TARGET: $\(String(format: "%.2f", order.targetPrice)) · AMOUNT: \(String(format: "%.2f", order.amount))")
                                    .font(.system(size: 8, design: .monospaced))
                                    .foregroundColor(.cyberMuted)
                            }
                            Spacer()

                            if order.status == .completed {
                                Button(action: {
                                    engine.claimLimitOrder(orderId: order.id)
                                }) {
                                    Text("CLAIM")
                                        .font(.system(size: 9, weight: .black, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.cyberYellow)
                                        .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(12)
                        .liquidGlass(cornerRadius: 14, borderAccent: order.status.color, glowRadius: 6)
                    }
                }
                .padding(16)
            }
        }
    }
}

// MARK: - Trade Tower Detail Sheet (Liquid Glass)
struct TradeTowerDetailSheet: View {
    let order: LimitOrder
    @ObservedObject var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AmbientLiquidBackgroundView()

            VStack(spacing: 14) {
                HStack {
                    Text("TRADE TOWER METADATA")
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .foregroundColor(.cyberYellow)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark").foregroundColor(.white)
                    }
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("STATUS: \(order.status.rawValue)")
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(order.status.color)

                    Text("PAIR: \(order.direction) \(order.tokenIn) for \(order.tokenOut)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.white)

                    Text("TARGET PRICE: $\(String(format: "%.2f", order.targetPrice))")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.neonCyan)

                    Text("AMOUNT: \(String(format: "%.3f", order.amount)) \(order.tokenIn)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.neonGreen)

                    if let tx = order.txHash {
                        Text("TX HASH: \(tx)")
                            .font(.system(size: 8, design: .monospaced))
                            .foregroundColor(.cyberMuted)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .liquidGlass(cornerRadius: 16, borderAccent: order.status.color, glowRadius: 8)

                if order.status == .completed {
                    Button(action: {
                        engine.claimLimitOrder(orderId: order.id)
                        dismiss()
                    }) {
                        Text("CLAIM TOKENS & YIELD")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(Color.cyberYellow)
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                            .shadow(color: Color.cyberYellow.opacity(0.5), radius: 8)
                    }
                }

                Spacer()
            }
            .padding(16)
        }
    }
}
