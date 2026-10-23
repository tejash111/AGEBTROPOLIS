import SwiftUI

// MARK: - Liquid Glass Council Room & Deliberation Chamber
public struct CouncilRoomView: View {
    @ObservedObject var engine: GameEngine
    var onBack: () -> Void

    @State private var inputPrompt: String = ""
    @State private var selectedAgentChat: AgentRole? = nil
    @State private var chatHistory: [String: [String]] = [:]
    @State private var directChatMessage: String = ""

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Top Chamber Header Bar (Liquid Glass)
                HStack {
                    Button(action: onBack) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 11, weight: .bold))
                            Text("RETURN TO CITY")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .tracking(1.2)
                        }
                        .foregroundColor(.cyberYellow)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.cyberYellow.opacity(0.15))
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.cyberYellow.opacity(0.5), lineWidth: 1)
                        )
                    }

                    Spacer()

                    HStack(spacing: 6) {
                        Text("COUNCIL CHAMBER")
                            .font(.system(size: 11, weight: .black, design: .monospaced))
                            .foregroundColor(.white)
                            .tracking(2.0)
                        Circle()
                            .fill(Color.neonGreen)
                            .frame(width: 6, height: 6)
                            .shadow(color: Color.neonGreen, radius: 4)
                    }

                    Spacer()

                    Text("5 AGENTS")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(.neonCyan)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule(style: .continuous)
                                .fill(Color.neonCyan.opacity(0.15))
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(Color.neonCyan.opacity(0.4), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
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

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // 1. Council Table Hologram View (Liquid Glass Dais)
                        LiquidGlassCouncilTableView(
                            speakingAgent: engine.speakingAgent,
                            onSelectAgent: { role in
                                selectedAgentChat = role
                            }
                        )

                        // 2. Preset Prompt Quick Glass Chips
                        LiquidGlassPresetPromptsView(
                            isDisabled: engine.isDeliberating,
                            onSelect: { prompt in
                                inputPrompt = prompt
                                Task {
                                    await engine.runCouncilDeliberation(prompt: prompt)
                                }
                            }
                        )

                        // 3. Custom Proposal Input Bar (Liquid Glass)
                        HStack(spacing: 8) {
                            TextField("Enter proposal for council deliberation...", text: $inputPrompt)
                                .font(.system(size: 11, design: .monospaced))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 9)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.ultraThinMaterial)
                                        .opacity(0.8)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(
                                            LinearGradient(
                                                colors: [Color.white.opacity(0.4), Color.cyberYellow.opacity(0.4)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )

                            Button(action: {
                                guard !inputPrompt.isEmpty else { return }
                                let p = inputPrompt
                                inputPrompt = ""
                                Task {
                                    await engine.runCouncilDeliberation(prompt: p)
                                }
                            }) {
                                HStack(spacing: 4) {
                                    if engine.isDeliberating {
                                        ProgressView()
                                            .tint(.black)
                                            .scaleEffect(0.7)
                                    } else {
                                        Image(systemName: "waveform")
                                    }
                                    Text(engine.isDeliberating ? "VOTING" : "CONVENE")
                                        .font(.system(size: 10, weight: .black, design: .monospaced))
                                }
                                .foregroundColor(.black)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color.cyberYellow)
                                )
                                .overlay(
                                    Capsule(style: .continuous)
                                        .stroke(Color.white.opacity(0.6), lineWidth: 1)
                                )
                                .shadow(color: Color.cyberYellow.opacity(0.5), radius: 6)
                            }
                            .disabled(engine.isDeliberating)
                        }
                        .padding(.horizontal, 16)

                        // 4. Live Deliberation Transcript Stream (Liquid Glass Cards)
                        if !engine.councilDeliberation.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("DELIBERATION TRANSCRIPT")
                                        .font(.system(size: 10, weight: .black, design: .monospaced))
                                        .foregroundColor(.cyberYellow)
                                        .tracking(1.5)
                                    Spacer()
                                    if engine.isDeliberating {
                                        Text("MULTI-AGENT REASONING...")
                                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                                            .foregroundColor(.neonCyan)
                                    }
                                }
                                .padding(.horizontal, 16)

                                ForEach(engine.councilDeliberation) { msg in
                                    LiquidGlassDeliberationCard(message: msg)
                                        .padding(.horizontal, 16)
                                }
                            }
                        }

                        // 5. Final Consensus & Uniswap v4 Execution Card (Liquid Glass)
                        if let proposal = engine.activeProposal {
                            LiquidGlassProposalCard(
                                proposal: proposal,
                                onExecute: {
                                    Task {
                                        await engine.executeProposal(proposal)
                                    }
                                }
                            )
                            .padding(.horizontal, 16)
                            .padding(.bottom, 24)
                        }
                    }
                    .padding(.vertical, 12)
                }
            }
            .task {
                if engine.activeProposal == nil {
                    await engine.runCouncilDeliberation(prompt: "Swap 10 USDC to WETH")
                }
            }

            // 1-on-1 Agent Chat / Dossier Modal Sheet
            if let agent = selectedAgentChat {
                Color.black.opacity(0.75)
                    .ignoresSafeArea()
                    .onTapGesture {
                        selectedAgentChat = nil
                    }

                LiquidGlassAgentChatModal(
                    agentRole: agent,
                    messages: chatHistory[agent.rawValue] ?? [],
                    onSend: { text in
                        var history = chatHistory[agent.rawValue] ?? []
                        history.append("YOU: \(text)")
                        let reply: String
                        switch agent {
                        case .alphaHunter:
                            reply = "ALPHA: Target yield looks solid. At current pool depth, expected slippage is less than 0.1%."
                        case .riskSentinel:
                            reply = "SENTINEL: Ensure swap size stays capped at 500 USDC to adhere to our SwapGuardHook safety bounds."
                        case .macroOracle:
                            reply = "ORACLE: Market sentiment index is holding positive. Momentum indicators favor execution."
                        case .devilsAdvocate:
                            reply = "DEVIL: Be prepared for sudden gas spikes during peak Base blocks."
                        case .councilClerk:
                            reply = "CLERK: I will record your parameters for the next consensus round."
                        }
                        history.append(reply)
                        chatHistory[agent.rawValue] = history
                    },
                    onClose: {
                        selectedAgentChat = nil
                    }
                )
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Liquid Glass Council Table Dais with 5 Holograms
struct LiquidGlassCouncilTableView: View {
    let speakingAgent: AgentRole?
    let onSelectAgent: (AgentRole) -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text("TAP ANY AGENT FOR 1-ON-1 DIRECT UPLINK")
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .foregroundColor(.cyberMuted)
                .tracking(1.0)

            HStack(spacing: 10) {
                ForEach(AgentRole.allCases) { role in
                    LiquidGlassAgentSeat(
                        role: role,
                        isSpeaking: speakingAgent == role,
                        onTap: { onSelectAgent(role) }
                    )
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.vertical, 12)
        .liquidGlass(cornerRadius: 18, borderAccent: .neonCyan, glowRadius: 10)
        .padding(.horizontal, 16)
    }
}

// Agent Liquid Glass Seat
struct LiquidGlassAgentSeat: View {
    let role: AgentRole
    let isSpeaking: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 46, height: 46)

                    Circle()
                        .fill(role.color.opacity(isSpeaking ? 0.35 : 0.15))
                        .frame(width: 44, height: 44)

                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.7), role.color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isSpeaking ? 2.5 : 1
                        )
                        .frame(width: 44, height: 44)

                    Text(role.emoji)
                        .font(.system(size: 20))
                }
                .shadow(color: role.color.opacity(isSpeaking ? 0.9 : 0.2), radius: isSpeaking ? 10 : 4)

                Text(role.title.components(separatedBy: " ").first ?? "")
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor(isSpeaking ? role.color : .white)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Liquid Glass Preset Prompt Chips
struct LiquidGlassPresetPromptsView: View {
    let isDisabled: Bool
    let onSelect: (String) -> Void

    let presets = [
        ("🔄 WETH→USDC", "Swap 0.005 WETH to USDC"),
        ("💰 USDC→WETH", "Swap 10 USDC to WETH"),
        ("📊 DCA 0.01 ETH", "DCA 0.01 ETH into USDC weekly"),
        ("🛡️ Risk Review", "Is it safe to swap 0.1 ETH to USDC right now?")
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(presets, id: \.0) { label, prompt in
                    Button(action: {
                        onSelect(prompt)
                    }) {
                        Text(label)
                            .font(.system(size: 9, weight: .bold, design: .monospaced))
                            .foregroundColor(.cyberYellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.85)
                            )
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.4), Color.cyberYellow.opacity(0.4)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    }
                    .disabled(isDisabled)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Liquid Glass Deliberation Message Card
struct LiquidGlassDeliberationCard: View {
    let message: CouncilMessage

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(message.agentRole.emoji)
                Text(message.agentRole.title.uppercased())
                    .font(.system(size: 10, weight: .black, design: .monospaced))
                    .foregroundColor(message.agentRole.color)

                Spacer()

                Text(message.opinion.rawValue)
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor(.black)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 2.5)
                    .background(message.opinion.color)
                    .clipShape(Capsule())

                Text("\(message.confidence)% CONF")
                    .font(.system(size: 8, weight: .bold, design: .monospaced))
                    .foregroundColor(.cyberMuted)
            }

            Text(message.reasoning)
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.white.opacity(0.92))
                .lineSpacing(2)
        }
        .padding(12)
        .liquidGlass(cornerRadius: 14, borderAccent: message.agentRole.color, glowRadius: 6)
    }
}

// MARK: - Liquid Glass Proposal Consensus Card & Uniswap v4 Hook Parameters
struct LiquidGlassProposalCard: View {
    let proposal: TradeProposal
    let onExecute: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("FINAL CONSENSUS")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(.cyberYellow)
                        .tracking(1.5)
                    Text(proposal.action)
                        .font(.system(size: 13, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                }

                Spacer()

                Text(proposal.consensus)
                    .font(.system(size: 9, weight: .black, design: .monospaced))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.cyberYellow)
                    .clipShape(Capsule())
            }

            // Glass Metric Pillars
            HStack(spacing: 8) {
                GlassMetricBox(label: "INPUT", value: "\(proposal.inputAmount) \(proposal.inputToken)", color: .neonCyan)
                GlassMetricBox(label: "EST. OUTPUT", value: "\(proposal.expectedOutput) \(proposal.outputToken)", color: .neonGreen)
                GlassMetricBox(label: "RISK", value: proposal.riskLevel, color: .neonGreen)
            }

            // Synthesis Quote
            Text("\"\(proposal.reasoning)\"")
                .font(.system(size: 9, design: .monospaced))
                .italic()
                .foregroundColor(.white.opacity(0.85))
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black.opacity(0.4))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
                )

            // Uniswap v4 Hook Parameters
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 9))
                    Text("UNISWAP V4 HOOK PARAMETERS (BASE SEPOLIA)")
                        .font(.system(size: 8, weight: .black, design: .monospaced))
                        .tracking(1.0)
                }
                .foregroundColor(.neonCyan)

                HStack(spacing: 8) {
                    GlassHookPill(name: "CouncilFeeHook", value: "\(proposal.dynamicFeeBps) bps", color: .neonGreen)
                    GlassHookPill(name: "SwapGuardHook", value: proposal.maxSwapSize, color: .neonOrange)
                    GlassHookPill(name: "SentimentHook", value: String(format: "+%.2f", proposal.sentimentScore), color: .neonCyan)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.black.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.neonCyan.opacity(0.35), lineWidth: 1)
            )

            // Execute CTA Button
            if proposal.isExecuted {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.neonGreen)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("EXECUTED ON BASE SEPOLIA")
                            .font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.neonGreen)
                        if let tx = proposal.txHash {
                            Text("TX: \(tx.prefix(18))...")
                                .font(.system(size: 8, design: .monospaced))
                                .foregroundColor(.cyberMuted)
                        }
                    }
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.neonGreen.opacity(0.15))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.neonGreen.opacity(0.6), lineWidth: 1)
                )
            } else {
                Button(action: onExecute) {
                    HStack(spacing: 6) {
                        Image(systemName: "bolt.fill")
                        Text("EXECUTE ON UNISWAP V4")
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
                    .shadow(color: Color.cyberYellow.opacity(0.6), radius: 10)
                }
            }
        }
        .padding(14)
        .liquidGlass(cornerRadius: 18, borderAccent: .cyberYellow, glowRadius: 10)
    }
}

struct GlassMetricBox: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(label)
                .font(.system(size: 7, weight: .bold, design: .monospaced))
                .foregroundColor(.cyberMuted)
            Text(value)
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(color.opacity(0.35), lineWidth: 0.8)
        )
    }
}

struct GlassHookPill: View {
    let name: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(name)
                .font(.system(size: 6, weight: .bold, design: .monospaced))
                .foregroundColor(.cyberMuted)
            Text(value)
                .font(.system(size: 8, weight: .black, design: .monospaced))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - 1-on-1 Direct Chat & Dossier Modal (Liquid Glass)
struct LiquidGlassAgentChatModal: View {
    let agentRole: AgentRole
    let messages: [String]
    let onSend: (String) -> Void
    let onClose: () -> Void

    @State private var textInput: String = ""

    var body: some View {
        VStack(spacing: 12) {
            // Header
            HStack {
                Text(agentRole.emoji)
                VStack(alignment: .leading, spacing: 2) {
                    Text(agentRole.title.uppercased())
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .foregroundColor(agentRole.color)
                    Text("SECURE NEURAL UPLINK // A2A")
                        .font(.system(size: 7, weight: .bold, design: .monospaced))
                        .foregroundColor(.cyberMuted)
                }

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                }
            }

            Text(agentRole.catchphrase)
                .font(.system(size: 9, design: .monospaced))
                .italic()
                .foregroundColor(.white.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)

            // Chat Feed
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    if messages.isEmpty {
                        Text("Uplink established. Query \(agentRole.title) regarding strategy, liquidity conditions, or risk parameters.")
                            .font(.system(size: 9, design: .monospaced))
                            .foregroundColor(.cyberMuted)
                            .padding(.top, 10)
                    } else {
                        ForEach(messages, id: \.self) { msg in
                            Text(msg)
                                .font(.system(size: 9, design: .monospaced))
                                .foregroundColor(msg.hasPrefix("YOU:") ? .cyberYellow : .white)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.black.opacity(0.5))
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(height: 140)

            // Input
            HStack {
                TextField("Message \(agentRole.title)...", text: $textInput)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.black.opacity(0.6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(agentRole.color.opacity(0.5), lineWidth: 1)
                    )

                Button(action: {
                    guard !textInput.isEmpty else { return }
                    let t = textInput
                    textInput = ""
                    onSend(t)
                }) {
                    Text("TRANSMIT")
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            Capsule(style: .continuous)
                                .fill(agentRole.color)
                        )
                }
            }
        }
        .padding(14)
        .liquidGlass(cornerRadius: 18, borderAccent: agentRole.color, glowRadius: 12)
    }
}
