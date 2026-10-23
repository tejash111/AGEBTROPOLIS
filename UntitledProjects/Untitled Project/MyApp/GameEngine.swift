import SwiftUI
import Combine

// MARK: - City Road Network Nodes
public struct CityNode {
    public let id: Int
    public let point: CGPoint
    public let connections: [Int]
}

@MainActor
public class GameEngine: ObservableObject {
    // MARK: - Player & Economy
    @Published public var level: Int = 1
    @Published public var xp: Int = 340
    @Published public var maxXp: Int = 1000
    @Published public var ytestBalance: Double = 100.00
    @Published public var ethBalance: Double = 0.450
    @Published public var usdcBalance: Double = 1250.00
    @Published public var gasSavedUSD: Double = 14.85
    
    // MARK: - Yellow Network Session
    @Published public var isSessionActive: Bool = true
    @Published public var guestSecondsRemaining: Int = 899
    @Published public var sessionId: String = "clear-sync-0x9f8e"
    @Published public var walletAddress: String = "0x8004...4BD9e"
    @Published public var ensName: String = "agentropolis.eth"

    // MARK: - Metropolis State
    @Published public var registeredAgents: [AgentNFT] = []
    @Published public var roamingAgents: [RoamingAgent] = []
    @Published public var streetCoins: [StreetCoin] = []
    @Published public var limitOrders: [LimitOrder] = []
    @Published public var floatingRewards: [FloatingReward] = []
    
    // MARK: - Deliberation & Council Chamber
    @Published public var isDeliberating: Bool = false
    @Published public var speakingAgent: AgentRole? = nil
    @Published public var councilDeliberation: [CouncilMessage] = []
    @Published public var activeProposal: TradeProposal? = nil
    @Published public var recentReceipts: [TradeProposal] = []
    
    // MARK: - UI Alerts & Modals
    @Published public var toastMessage: String? = nil
    @Published public var showPlaceOrderModal: Bool = false
    @Published public var showMarketplaceModal: Bool = false
    @Published public var showSessionModal: Bool = false
    @Published public var showMintAgentModal: Bool = false
    @Published public var selectedAgentDossier: AgentRole? = nil
    @Published public var selectedLimitOrder: LimitOrder? = nil

    private var simulationTimer: AnyCancellable?
    private var guestTimer: AnyCancellable?

    // 8-Node Road Graph for Metropolis Circulation
    public let roadNodes: [CityNode] = [
        CityNode(id: 0, point: CGPoint(x: 70, y: 70), connections: [1, 3]),
        CityNode(id: 1, point: CGPoint(x: 200, y: 70), connections: [0, 2, 4]),
        CityNode(id: 2, point: CGPoint(x: 330, y: 70), connections: [1, 5]),
        CityNode(id: 3, point: CGPoint(x: 70, y: 220), connections: [0, 4, 6]),
        CityNode(id: 4, point: CGPoint(x: 200, y: 220), connections: [1, 3, 5, 7]), // Central intersection
        CityNode(id: 5, point: CGPoint(x: 330, y: 220), connections: [2, 4, 8]),
        CityNode(id: 6, point: CGPoint(x: 70, y: 370), connections: [3, 7]),
        CityNode(id: 7, point: CGPoint(x: 200, y: 370), connections: [4, 6, 8]),
        CityNode(id: 8, point: CGPoint(x: 330, y: 370), connections: [5, 7])
    ]

    public init() {
        setupInitialData()
        startSimulation()
    }

    // MARK: - Setup Initial Metropolis Environment
    private func setupInitialData() {
        // 1. ERC-8004 Verified Agents (matching on-chain Base Sepolia tokens)
        registeredAgents = [
            AgentNFT(
                id: "luna-dca",
                tokenId: 101,
                name: "Luna DCA",
                strategy: "dca",
                riskTolerance: "conservative",
                reputation: 94,
                txHash: "0xa81f4b238f902409d57a98816c27189bf3e4bca789",
                isDeployed: true,
                description: "Automated recurring accumulation with smart volatility-adjusted tranches."
            ),
            AgentNFT(
                id: "vortex-momentum",
                tokenId: 102,
                name: "Vortex",
                strategy: "momentum",
                riskTolerance: "moderate",
                reputation: 88,
                txHash: "0xb799e0231cfb562a095c5108c909cfa320399ea923",
                isDeployed: true,
                description: "Trend-following breakout detector tuned for Uniswap v4 deep pools."
            ),
            AgentNFT(
                id: "sentinel-yield",
                tokenId: 103,
                name: "Sentinel Yield",
                strategy: "yield",
                riskTolerance: "conservative",
                reputation: 96,
                txHash: "0xc4091ba8123da4628f419b48f934ea2910488ae821",
                isDeployed: false,
                description: "Impermanent loss minimizer and concentrated liquidity rebalancer."
            ),
            AgentNFT(
                id: "phoenix-arb",
                tokenId: 104,
                name: "Phoenix Arb",
                strategy: "arbitrage",
                riskTolerance: "aggressive",
                reputation: 82,
                txHash: "0xd909ef488a032948bb319808a90184e908123cf910",
                isDeployed: false,
                description: "Flash cross-hook spatial arbitrage hunter for Base Sepolia."
            )
        ]

        // 2. Spawn initially deployed agents
        roamingAgents = [
            RoamingAgent(
                id: "agent-1",
                nft: registeredAgents[0],
                position: roadNodes[0].point,
                targetNodeIndex: 1,
                currentAction: "SWAPPING DCA",
                coinsCollected: 0
            ),
            RoamingAgent(
                id: "agent-2",
                nft: registeredAgents[1],
                position: roadNodes[4].point,
                targetNodeIndex: 5,
                currentAction: "SCANNING MOMENTUM",
                coinsCollected: 0
            )
        ]

        // 3. Populate Street Coins along Avenue Lines
        var coins: [StreetCoin] = []
        let positions: [(CGPoint, StreetCoin.CoinType)] = [
            (CGPoint(x: 135, y: 70), .silver),
            (CGPoint(x: 265, y: 70), .bronze),
            (CGPoint(x: 70, y: 145), .gold),
            (CGPoint(x: 200, y: 145), .silver),
            (CGPoint(x: 330, y: 145), .bronze),
            (CGPoint(x: 135, y: 220), .gold),
            (CGPoint(x: 265, y: 220), .silver),
            (CGPoint(x: 70, y: 295), .bronze),
            (CGPoint(x: 200, y: 295), .gold),
            (CGPoint(x: 330, y: 295), .silver),
            (CGPoint(x: 135, y: 370), .bronze),
            (CGPoint(x: 265, y: 370), .silver)
        ]

        for (index, item) in positions.enumerated() {
            coins.append(StreetCoin(
                id: "coin-\(index)",
                position: item.0,
                type: item.1,
                isCollected: false
            ))
        }
        streetCoins = coins

        // 4. Initial Limit Order Trade Towers in the City
        limitOrders = [
            LimitOrder(
                id: "order-101",
                tokenIn: "WETH",
                tokenOut: "USDC",
                direction: "BUY",
                targetPrice: 2650.0,
                amount: 0.25,
                status: .active,
                createdAt: Date().addingTimeInterval(-3600),
                txHash: "0x12a8...99e1",
                towerCoord: CGPoint(x: 120, y: 160)
            ),
            LimitOrder(
                id: "order-102",
                tokenIn: "USDC",
                tokenOut: "WETH",
                direction: "SELL",
                targetPrice: 2800.0,
                amount: 500.0,
                status: .completed,
                createdAt: Date().addingTimeInterval(-7200),
                txHash: "0x44b9...10f2",
                towerCoord: CGPoint(x: 270, y: 310)
            )
        ]
    }

    // MARK: - Simulation Loop (Movement & Coin Collection)
    private func startSimulation() {
        simulationTimer = Timer.publish(every: 0.08, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tickSimulation()
            }

        // Guest countdown timer
        guestTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.guestSecondsRemaining > 0 {
                    self.guestSecondsRemaining -= 1
                }
            }
    }

    private func tickSimulation() {
        // Move roaming agents along road nodes
        for i in roamingAgents.indices {
            let agent = roamingAgents[i]
            let targetPoint = roadNodes[agent.targetNodeIndex].point
            let dx = targetPoint.x - agent.position.x
            let dy = targetPoint.y - agent.position.y
            let dist = sqrt(dx*dx + dy*dy)

            if dist < 4.0 {
                // Reached node -> pick connected neighbor
                let currentNode = roadNodes[agent.targetNodeIndex]
                if let nextId = currentNode.connections.randomElement() {
                    roamingAgents[i].targetNodeIndex = nextId
                }
            } else {
                let speed: CGFloat = 2.2
                roamingAgents[i].position.x += (dx / dist) * speed
                roamingAgents[i].position.y += (dy / dist) * speed
            }

            // Check coin collision
            checkCoinPickup(agentPos: roamingAgents[i].position)
        }

        // Decay floating rewards
        if !floatingRewards.isEmpty {
            for i in floatingRewards.indices {
                floatingRewards[i].position.y -= 1.0
                floatingRewards[i].opacity -= 0.05
            }
            floatingRewards.removeAll { $0.opacity <= 0.05 }
        }
    }

    // MARK: - Coin Collection
    public func collectCoin(coinId: String) {
        guard let index = streetCoins.firstIndex(where: { $0.id == coinId && !$0.isCollected }) else { return }
        streetCoins[index].isCollected = true
        let coin = streetCoins[index]
        
        let rewardValue = coin.type.value
        ytestBalance += rewardValue
        xp += Int(rewardValue * 50)
        gasSavedUSD += 0.25

        // Emit visual floating text
        let reward = FloatingReward(
            text: "+\(String(format: "%.1f", rewardValue)) $YTEST",
            color: coin.type.color,
            position: coin.position
        )
        floatingRewards.append(reward)

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        // Respawn coin after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { [weak self] in
            if let idx = self?.streetCoins.firstIndex(where: { $0.id == coinId }) {
                self?.streetCoins[idx].isCollected = false
            }
        }
    }

    private func checkCoinPickup(agentPos: CGPoint) {
        for coin in streetCoins where !coin.isCollected {
            let dx = coin.position.x - agentPos.x
            let dy = coin.position.y - agentPos.y
            let dist = sqrt(dx*dx + dy*dy)
            if dist < 16.0 {
                collectCoin(coinId: coin.id)
                break
            }
        }
    }

    // MARK: - Deploy Agent into Metropolis
    public func deployAgent(agentId: String) {
        guard let index = registeredAgents.firstIndex(where: { $0.id == agentId }) else { return }
        guard ytestBalance >= 0.01 else {
            showToast("Insufficient $YTEST balance (requires 0.01)")
            return
        }

        ytestBalance -= 0.01
        registeredAgents[index].isDeployed = true

        let spawnPoint = roadNodes[4].point // Central Spire
        let newAgent = RoamingAgent(
            id: "agent-\(UUID().uuidString.prefix(6))",
            nft: registeredAgents[index],
            position: spawnPoint,
            targetNodeIndex: roadNodes[4].connections.randomElement() ?? 1,
            currentAction: "ACTIVE // EXECUTING",
            coinsCollected: 0
        )
        roamingAgents.append(newAgent)

        showToast("Agent \(registeredAgents[index].name) deployed to City Grid!")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    // MARK: - Mint New Agent (ERC-8004 On-Chain Identity)
    public func mintAgent(name: String, strategy: String, risk: String, description: String) {
        let newId = "agent-\(name.lowercased().replacingOccurrences(of: " ", with: "-"))"
        let tokenId = 100 + registeredAgents.count + 1
        let mockTx = "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(40)

        let newAgent = AgentNFT(
            id: newId,
            tokenId: tokenId,
            name: name,
            strategy: strategy,
            riskTolerance: risk,
            reputation: 80,
            txHash: mockTx,
            isDeployed: false,
            description: description.isEmpty ? "Autonomous DeFi strategy worker" : description
        )

        registeredAgents.append(newAgent)
        showToast("Minted ERC-721 NFT #\(tokenId) on Base Sepolia!")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    // MARK: - Place Limit Order & Build Trade Tower
    public func placeLimitOrder(tokenIn: String, tokenOut: String, direction: String, targetPrice: Double, amount: Double) {
        let towerCoords: [CGPoint] = [
            CGPoint(x: 120, y: 160),
            CGPoint(x: 270, y: 160),
            CGPoint(x: 120, y: 310),
            CGPoint(x: 270, y: 310)
        ]
        let coord = towerCoords[limitOrders.count % towerCoords.count]
        let tx = "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(40)

        var newOrder = LimitOrder(
            id: "order-\(Int(Date().timeIntervalSince1970))",
            tokenIn: tokenIn,
            tokenOut: tokenOut,
            direction: direction,
            targetPrice: targetPrice,
            amount: amount,
            status: .construction,
            createdAt: Date(),
            txHash: tx,
            towerCoord: coord
        )

        limitOrders.append(newOrder)
        showToast("Trade Tower Construction Initiated!")

        // Transition from Construction to Active after 3 seconds
        let orderId = newOrder.id
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            if let idx = self?.limitOrders.firstIndex(where: { $0.id == orderId }) {
                self?.limitOrders[idx].status = .active
                self?.showToast("Trade Tower Active: Enforcing Uniswap v4 Hook!")
            }
        }
    }

    public func claimLimitOrder(orderId: String) {
        guard let index = limitOrders.firstIndex(where: { $0.id == orderId }) else { return }
        limitOrders[index].status = .completed
        
        let reward = limitOrders[index].amount * 1.05
        ytestBalance += 5.0
        usdcBalance += reward

        showToast("Claimed Order! +\(String(format: "%.2f", reward)) tokens & +5 $YTEST")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    // MARK: - Full Council Deliberation Engine
    public func runCouncilDeliberation(prompt: String) async {
        guard !isDeliberating else { return }
        isDeliberating = true
        councilDeliberation.removeAll()
        activeProposal = nil

        let userPrompt = prompt.isEmpty ? "Swap 10 USDC to WETH" : prompt

        // Deliberation step-by-step
        let debateSteps: [(AgentRole, DeliberationOpinion, String, Int)] = [
            (
                .alphaHunter,
                .support,
                "High yield detected. Uniswap v4 0.05% tier offers optimal routing with +18.4% APY projected capital efficiency.",
                88
            ),
            (
                .riskSentinel,
                .concern,
                "Volatility index elevated at 3.8% intraday. Impermanent loss risk is mitigated only if swap size is bounded below 500 USDC.",
                74
            ),
            (
                .macroOracle,
                .neutral,
                "Base Sepolia network volume is steady. Market sentiment index reads +0.82 (moderately bullish). Good execution window.",
                80
            ),
            (
                .devilsAdvocate,
                .concern,
                "Watch out for slippage sandwiching on large transactions. If gas spikes, execution plan could degrade by 12 bps.",
                68
            ),
            (
                .councilClerk,
                .support,
                "Synthesized majority consensus. Configuring CouncilFeeHook dynamic fee to 5 bps and SwapGuardHook limit to 500 USDC.",
                92
            )
        ]

        for step in debateSteps {
            speakingAgent = step.0
            try? await Task.sleep(nanoseconds: 700_000_000)

            let msg = CouncilMessage(
                agentRole: step.0,
                opinion: step.1,
                reasoning: step.2,
                confidence: step.3
            )
            councilDeliberation.append(msg)
        }

        speakingAgent = nil

        // Final Proposal
        let proposal = TradeProposal(
            action: userPrompt.uppercased(),
            inputToken: "USDC",
            inputAmount: "10.00",
            outputToken: "WETH",
            expectedOutput: "0.00378",
            riskLevel: "LOW",
            consensus: "APPROVED",
            reasoning: "Council reached consensus (4 Support, 1 Concern). Uniswap v4 Hook constraints verified safe.",
            votes: TradeProposal.VoteTally(support: 4, oppose: 0, abstain: 1),
            dynamicFeeBps: 5,
            maxSwapSize: "500 USDC",
            sentimentScore: 0.82
        )

        activeProposal = proposal
        isDeliberating = false

        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    // MARK: - Execute Proposal on Uniswap v4 Hook
    public func executeProposal(_ proposal: TradeProposal) async {
        guard let p = activeProposal else { return }
        
        let tx = "0x" + UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(40)
        var updated = p
        updated.txHash = tx
        updated.isExecuted = true
        
        // Update balance
        usdcBalance -= 10.00
        ethBalance += 0.00378
        ytestBalance += 2.50
        xp += 150
        
        activeProposal = updated
        recentReceipts.insert(updated, at: 0)

        showToast("Swap Confirmed on Base Sepolia! Router: 0x492E...4104")
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    public func depositYTest(amount: Double) {
        ytestBalance += amount
        showToast("Deposited \(String(format: "%.2f", amount)) $YTEST into ClearSync Channel")
    }

    public func withdrawYTest(amount: Double) {
        guard ytestBalance >= amount else {
            showToast("Insufficient balance to withdraw")
            return
        }
        ytestBalance -= amount
        showToast("Withdrew \(String(format: "%.2f", amount)) $YTEST from ClearSync Channel")
    }

    public func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            if self?.toastMessage == message {
                self?.toastMessage = nil
            }
        }
    }
}
