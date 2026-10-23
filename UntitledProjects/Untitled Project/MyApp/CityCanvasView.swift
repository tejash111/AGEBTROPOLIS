import SwiftUI

// MARK: - Liquid Glass Cyberpunk Metropolis Canvas
public struct CityCanvasView: View {
    @ObservedObject var engine: GameEngine
    var onEnterCouncil: () -> Void

    @State private var zoomScale: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var dragStartOffset: CGSize = .zero
    @State private var pulseAnimation = false

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Interactive Metropolis World
                ZStack {
                    // 1. Grid Background & Roads
                    MetropolisRoadsView(nodes: engine.roadNodes)

                    // 2. Liquid Glass Tech Buildings
                    MetropolisGlassBuildingsView(pulseAnimation: pulseAnimation)

                    // 3. Trade Towers (Uniswap v4 Limit Order Buildings)
                    ForEach(engine.limitOrders) { order in
                        LiquidGlassTradeTowerView(order: order)
                            .position(order.towerCoord)
                            .onTapGesture {
                                engine.selectedLimitOrder = order
                            }
                    }

                    // 4. Street Coins ($YTEST)
                    ForEach(engine.streetCoins) { coin in
                        if !coin.isCollected {
                            LiquidGlassStreetCoinView(coin: coin)
                                .position(coin.position)
                                .onTapGesture {
                                    engine.collectCoin(coinId: coin.id)
                                }
                        }
                    }

                    // 5. Roaming Autonomous Agents
                    ForEach(engine.roamingAgents) { agent in
                        LiquidGlassRoamingAgentView(agent: agent)
                            .position(agent.position)
                            .onTapGesture {
                                engine.showMarketplaceModal = true
                            }
                    }

                    // 6. Floating Reward Text Particles
                    ForEach(engine.floatingRewards) { reward in
                        Text(reward.text)
                            .font(.system(size: 12, weight: .black, design: .monospaced))
                            .foregroundColor(reward.color)
                            .shadow(color: reward.color.opacity(0.8), radius: 6)
                            .position(reward.position)
                            .opacity(reward.opacity)
                    }

                    // 7. Council Chamber Portal at City Center
                    LiquidGlassCouncilPortalButton(onEnter: onEnterCouncil)
                        .position(x: 200, y: 30)
                }
                .frame(width: 400, height: 440)
                .scaleEffect(zoomScale)
                .offset(panOffset)
                .gesture(
                    SimultaneousGesture(
                        DragGesture()
                            .onChanged { value in
                                panOffset = CGSize(
                                    width: dragStartOffset.width + value.translation.width,
                                    height: dragStartOffset.height + value.translation.height
                                )
                            }
                            .onEnded { _ in
                                dragStartOffset = panOffset
                            },
                        MagnificationGesture()
                            .onChanged { scale in
                                zoomScale = max(0.8, min(scale, 1.8))
                            }
                    )
                )

                // Top Left: Liquid Glass Session Widget
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 8) {
                                Text("SESSION")
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .foregroundColor(.cyberMuted)
                                    .tracking(1.2)
                                Spacer()
                                Text(formatTime(engine.guestSecondsRemaining))
                                    .font(.system(size: 9, weight: .black, design: .monospaced))
                                    .foregroundColor(.neonGreen)
                            }

                            HStack(spacing: 6) {
                                Circle()
                                    .fill(engine.isSessionActive ? Color.neonGreen : Color.cyberMuted)
                                    .frame(width: 6, height: 6)
                                    .shadow(color: engine.isSessionActive ? Color.neonGreen : .clear, radius: 4)

                                Text(engine.isSessionActive ? "CONNECTED" : "DISCONNECTED")
                                    .font(.system(size: 9, weight: .black, design: .monospaced))
                                    .foregroundColor(engine.isSessionActive ? .white : .cyberMuted)

                                Spacer()

                                Button(action: {
                                    engine.showSessionModal = true
                                }) {
                                    Text("DEPOSIT")
                                        .font(.system(size: 8, weight: .black, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color.cyberYellow)
                                        .clipShape(Capsule())
                                        .shadow(color: Color.cyberYellow.opacity(0.4), radius: 4)
                                }
                            }
                        }
                        .padding(10)
                        .frame(width: 175)
                        .liquidGlass(cornerRadius: 14, borderAccent: .cyberBorderYellow, glowRadius: 6)
                        Spacer()
                    }
                    .padding(.top, 64)
                    .padding(.leading, 14)

                    Spacer()
                }

                // Fixed Bottom Right: Liquid Glass PLACE LIMIT ORDER Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            engine.showPlaceOrderModal = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.square.fill")
                                    .font(.system(size: 11, weight: .black))
                                Text("PLACE LIMIT ORDER")
                                    .font(.system(size: 10, weight: .black, design: .monospaced))
                                    .tracking(1.4)
                            }
                            .foregroundColor(.cyberYellow)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.85)
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.5), Color.cyberYellow.opacity(0.8), Color.white.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                            .shadow(color: Color.cyberYellow.opacity(0.4), radius: 8, x: 0, y: 3)
                        }
                        .padding(.trailing, 16)
                        .padding(.bottom, 78)
                    }
                }
            }
        }
        .onAppear {
            pulseAnimation = true
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Roads & Cyber Avenue Grid
struct MetropolisRoadsView: View {
    let nodes: [CityNode]

    var body: some View {
        Canvas { context, size in
            // Road Lines
            let roadStroke = StrokeStyle(lineWidth: 24, lineCap: .round, lineJoin: .round)
            let roadCenterDash = StrokeStyle(lineWidth: 1.5, dash: [6, 6])

            // Vertical Roads
            for x in [70.0, 200.0, 330.0] {
                var roadPath = Path()
                roadPath.move(to: CGPoint(x: x, y: 40))
                roadPath.addLine(to: CGPoint(x: x, y: 400))
                context.stroke(roadPath, with: .color(Color(hex: "0e0e26").opacity(0.8)), style: roadStroke)

                var dashPath = Path()
                dashPath.move(to: CGPoint(x: x, y: 45))
                dashPath.addLine(to: CGPoint(x: x, y: 395))
                context.stroke(dashPath, with: .color(Color.cyberYellow.opacity(0.45)), style: roadCenterDash)
            }

            // Horizontal Roads
            for y in [70.0, 220.0, 370.0] {
                var roadPath = Path()
                roadPath.move(to: CGPoint(x: 40, y: y))
                roadPath.addLine(to: CGPoint(x: 360, y: y))
                context.stroke(roadPath, with: .color(Color(hex: "0e0e26").opacity(0.8)), style: roadStroke)

                var dashPath = Path()
                dashPath.move(to: CGPoint(x: 45, y: y))
                dashPath.addLine(to: CGPoint(x: 355, y: y))
                context.stroke(dashPath, with: .color(Color.cyberYellow.opacity(0.45)), style: roadCenterDash)
            }

            // Street Lamps at Intersections
            for node in nodes {
                let rect = CGRect(x: node.point.x - 4, y: node.point.y - 4, width: 8, height: 8)
                context.fill(Path(ellipseIn: rect), with: .color(Color.neonCyan))
            }
        }
        .frame(width: 400, height: 440)
    }
}

// MARK: - Liquid Glass Tech Buildings
struct MetropolisGlassBuildingsView: View {
    let pulseAnimation: Bool

    var body: some View {
        ZStack {
            LiquidGlassBuildingItem(title: "ALPHA VAULT", subtitle: "Uniswap v4 LP", accentColor: .neonGreen, width: 80, height: 90)
                .position(x: 135, y: 135)

            LiquidGlassBuildingItem(title: "SENTINEL HQ", subtitle: "Risk Guard", accentColor: .neonOrange, width: 84, height: 98)
                .position(x: 265, y: 135)

            LiquidGlassBuildingItem(title: "MATRIX POOL", subtitle: "DCA Engine", accentColor: .neonCyan, width: 80, height: 90)
                .position(x: 135, y: 295)

            LiquidGlassBuildingItem(title: "YELLOW HUB", subtitle: "Gasless Session", accentColor: .cyberYellow, width: 84, height: 94)
                .position(x: 265, y: 295)
        }
    }
}

// Single Liquid Glass Building
struct LiquidGlassBuildingItem: View {
    let title: String
    let subtitle: String
    let accentColor: Color
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack(spacing: 3) {
            // Roof Antenna / Crystal Spire
            HStack(spacing: 3) {
                Circle().fill(accentColor).frame(width: 5, height: 5)
                    .shadow(color: accentColor, radius: 4)
                Spacer()
                Capsule().fill(accentColor.opacity(0.7)).frame(width: 16, height: 2)
            }
            .padding(.horizontal, 4)

            Spacer()

            Text(title)
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundColor(.white)
                .tracking(0.5)

            Text(subtitle)
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundColor(accentColor)

            // Frosted Glass Window Cells
            HStack(spacing: 3) {
                ForEach(0..<4) { _ in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(accentColor.opacity(0.35))
                        .frame(width: 8, height: 4)
                }
            }
            .padding(.top, 4)
        }
        .padding(8)
        .frame(width: width, height: height)
        .liquidGlass(cornerRadius: 14, borderAccent: accentColor, glowRadius: 8, opacity: 0.60)
    }
}

// MARK: - Liquid Glass Trade Tower (Limit Order Structure in Metropolis)
struct LiquidGlassTradeTowerView: View {
    let order: LimitOrder

    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: order.status == .completed ? "checkmark.seal.fill" : "building.2.crop.circle")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(order.status.color)
                .shadow(color: order.status.color, radius: 4)

            Text(order.direction)
                .font(.system(size: 7, weight: .black, design: .monospaced))
                .foregroundColor(order.status.color)

            Text("$\(Int(order.targetPrice))")
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.white)

            Text(order.status.rawValue)
                .font(.system(size: 6, weight: .black, design: .monospaced))
                .foregroundColor(.black)
                .padding(.horizontal, 5)
                .padding(.vertical, 1.5)
                .background(order.status.color)
                .clipShape(Capsule())
        }
        .padding(6)
        .frame(width: 66, height: 72)
        .liquidGlass(cornerRadius: 12, borderAccent: order.status.color, glowRadius: 8, opacity: 0.75)
    }
}

// MARK: - Liquid Glass Street Coin ($YTEST)
struct LiquidGlassStreetCoinView: View {
    let coin: StreetCoin

    var body: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 20, height: 20)

            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.7), coin.type.color],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 18, height: 18)

            Text("$")
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundColor(coin.type.color)
        }
        .shadow(color: coin.type.color.opacity(0.6), radius: 6)
    }
}

// MARK: - Liquid Glass Roaming Agent
struct LiquidGlassRoamingAgentView: View {
    let agent: RoamingAgent

    var body: some View {
        VStack(spacing: 2) {
            // Label above agent
            Text(agent.nft.name.uppercased())
                .font(.system(size: 7, weight: .black, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 5)
                .padding(.vertical, 1.5)
                .background(
                    Capsule(style: .continuous)
                        .fill(.ultraThinMaterial)
                        .opacity(0.9)
                )
                .overlay(
                    Capsule(style: .continuous)
                        .stroke(agent.nft.strategyColor.opacity(0.7), lineWidth: 0.8)
                )

            // Neon Liquid Glass Avatar
            ZStack {
                Circle()
                    .fill(agent.nft.strategyColor.opacity(0.35))
                    .frame(width: 24, height: 24)

                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.8), agent.nft.strategyColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 20, height: 20)

                Image(systemName: "cpu.fill")
                    .font(.system(size: 10))
                    .foregroundColor(agent.nft.strategyColor)
            }
            .shadow(color: agent.nft.strategyColor.opacity(0.7), radius: 8)
        }
    }
}

// MARK: - Liquid Glass Council Portal Button
struct LiquidGlassCouncilPortalButton: View {
    let onEnter: () -> Void

    var body: some View {
        Button(action: onEnter) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.system(size: 9, weight: .bold))
                Text("ENTER COUNCIL CHAMBER")
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .tracking(1.2)
                Image(systemName: "arrow.right")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundColor(.black)
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.neonCyan)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.8), Color.neonCyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: Color.neonCyan.opacity(0.6), radius: 10)
        }
    }
}
