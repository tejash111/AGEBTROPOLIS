import SwiftUI

// MARK: - Liquid Glass ERC-8004 Agent Registry & Minting Drawer
public struct AgentMarketplaceView: View {
    @ObservedObject var engine: GameEngine
    @Environment(\.dismiss) private var dismiss

    @State private var selectedFilter: String = "ALL"
    @State private var showMintSheet: Bool = false

    // Minting Form
    @State private var agentName: String = ""
    @State private var strategy: String = "dca"
    @State private var riskTolerance: String = "moderate"
    @State private var description: String = ""

    let filters = ["ALL", "DCA", "MOMENTUM", "ARBITRAGE", "YIELD"]

    public var body: some View {
        ZStack {
            AmbientLiquidBackgroundView()

            VStack(spacing: 0) {
                // Liquid Glass Header Bar
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("ERC-8004 REGISTRY")
                            .font(.system(size: 8, weight: .bold, design: .monospaced))
                            .foregroundColor(.neonCyan)
                            .tracking(1.5)
                        Text("AGENT MARKETPLACE")
                            .font(.system(size: 13, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Button(action: {
                        showMintSheet = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                            Text("MINT AGENT")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.cyberYellow)
                        .clipShape(Capsule())
                        .shadow(color: Color.cyberYellow.opacity(0.4), radius: 6)
                    }

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
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

                // Strategy Filter Bar (Liquid Glass Chips)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(filters, id: \.self) { filter in
                            Button(action: { selectedFilter = filter }) {
                                Text(filter)
                                    .font(.system(size: 8, weight: .black, design: .monospaced))
                                    .foregroundColor(selectedFilter == filter ? .black : .white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule(style: .continuous)
                                            .fill(selectedFilter == filter ? Color.cyberYellow : Color.white.opacity(0.08))
                                    )
                                    .overlay(
                                        Capsule(style: .continuous)
                                            .stroke(
                                                selectedFilter == filter ? Color.white.opacity(0.6) : Color.white.opacity(0.15),
                                                lineWidth: 1
                                            )
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }

                // Agent Cards List (Liquid Glass)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredAgents) { agent in
                            LiquidGlassAgentCard(
                                agent: agent,
                                canAfford: engine.ytestBalance >= 0.01,
                                onDeploy: {
                                    engine.deployAgent(agentId: agent.id)
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
            }

            // Mint Agent Sheet (Liquid Glass)
            if showMintSheet {
                Color.black.opacity(0.75).ignoresSafeArea()
                    .onTapGesture { showMintSheet = false }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("MINT ERC-721 IDENTITY")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                        Spacer()
                        Button(action: { showMintSheet = false }) {
                            Image(systemName: "xmark").foregroundColor(.white)
                        }
                    }

                    Text("Contract: 0x8004A818BFB912233c491871b3d84c89A494BD9e")
                        .font(.system(size: 7, design: .monospaced))
                        .foregroundColor(.cyberMuted)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("AGENT NAME")
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                        TextField("e.g. Quantum Arbitrage", text: $agentName)
                            .font(.system(size: 11, design: .monospaced))
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
                    }

                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("STRATEGY")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.cyberYellow)
                            Picker("Strategy", selection: $strategy) {
                                Text("DCA").tag("dca")
                                Text("Momentum").tag("momentum")
                                Text("Arbitrage").tag("arbitrage")
                                Text("Yield").tag("yield")
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("RISK LEVEL")
                                .font(.system(size: 8, weight: .black, design: .monospaced))
                                .foregroundColor(.cyberYellow)
                            Picker("Risk", selection: $riskTolerance) {
                                Text("Conservative").tag("conservative")
                                Text("Moderate").tag("moderate")
                                Text("Aggressive").tag("aggressive")
                            }
                            .pickerStyle(.menu)
                            .tint(.white)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("BEHAVIOR SPECIFICATION")
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                        TextField("Autonomous order execution parameters...", text: $description)
                            .font(.system(size: 10, design: .monospaced))
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
                    }

                    Button(action: {
                        guard !agentName.isEmpty else { return }
                        engine.mintAgent(
                            name: agentName,
                            strategy: strategy,
                            risk: riskTolerance,
                            description: description
                        )
                        showMintSheet = false
                        agentName = ""
                        description = ""
                    }) {
                        Text("REGISTER ON-CHAIN (BASE SEPOLIA)")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
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
                    .disabled(agentName.isEmpty)
                }
                .padding(16)
                .liquidGlass(cornerRadius: 20, borderAccent: .cyberYellow, glowRadius: 14)
                .padding(.horizontal, 20)
            }
        }
    }

    private var filteredAgents: [AgentNFT] {
        if selectedFilter == "ALL" {
            return engine.registeredAgents
        }
        return engine.registeredAgents.filter { $0.strategy.uppercased() == selectedFilter }
    }
}

// Single Liquid Glass Registry Card
struct LiquidGlassAgentCard: View {
    let agent: AgentNFT
    let canAfford: Bool
    let onDeploy: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(agent.name.uppercased())
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(.white)

                        Text("TX")
                            .font(.system(size: 7, weight: .black, design: .monospaced))
                            .foregroundColor(.neonCyan)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1.5)
                            .background(Color.neonCyan.opacity(0.2))
                            .clipShape(Capsule())
                    }

                    Text("STRATEGY: \(agent.strategy.uppercased()) · RISK: \(agent.riskTolerance.uppercased())")
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyberMuted)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("REP")
                        .font(.system(size: 6, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyberMuted)
                    Text("\(agent.reputation)/100")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.neonGreen)
                }
            }

            Text(agent.description)
                .font(.system(size: 8, design: .monospaced))
                .foregroundColor(.white.opacity(0.85))

            // Action Button
            HStack {
                Text("COST: 0.01 $YTEST")
                    .font(.system(size: 7, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyberYellow)

                Spacer()

                if agent.isDeployed {
                    Text(">> DEPLOYED & ROAMING <<")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(.neonGreen)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.neonGreen.opacity(0.15))
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.neonGreen.opacity(0.5), lineWidth: 1)
                        )
                } else {
                    Button(action: onDeploy) {
                        Text("DEPLOY INTO CITY")
                            .font(.system(size: 8, weight: .black, design: .monospaced))
                            .foregroundColor(.black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(canAfford ? Color.cyberYellow : Color.gray)
                            )
                            .shadow(color: canAfford ? Color.cyberYellow.opacity(0.4) : .clear, radius: 4)
                    }
                    .disabled(!canAfford)
                }
            }
        }
        .padding(12)
        .liquidGlass(cornerRadius: 16, borderAccent: agent.isDeployed ? .neonGreen : .neonCyan, glowRadius: 6)
    }
}
