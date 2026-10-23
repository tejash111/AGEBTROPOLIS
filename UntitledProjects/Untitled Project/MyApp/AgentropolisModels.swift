import SwiftUI

// MARK: - Smart Contract Addresses (Base Sepolia)
public struct ContractAddresses {
    public static let universalRouter = "0x492E6456D9528771018DeB9E87ef7750EF184104"
    public static let councilFeeHook = "0xddda04328455FfbeeBb4a4Fb6ef2292c586E4080"
    public static let swapGuardHook = "0xA7a8c5D56E6B7318a3Fa61b71A9905e59f474080"
    public static let sentimentOracleHook = "0xE18ef4b29F0DCFf955F6852d468bC18f121a4040"
    public static let erc8004Registry = "0x8004A818BFB912233c491871b3d84c89A494BD9e"
    public static let poolManager = "0x05E73354cFDd6745C338b50BcFDfA3Aa6fA03408"
    
    public static let weth = "0x4200000000000000000000000000000000000006"
    public static let usdc = "0x036CbD53842c5426634e7929541eC2318f3dCF7e"
}

// MARK: - Agent Roles & Visual Identity
public enum AgentRole: String, CaseIterable, Identifiable {
    case alphaHunter = "alpha-hunter"
    case riskSentinel = "risk-sentinel"
    case macroOracle = "macro-oracle"
    case devilsAdvocate = "devils-advocate"
    case councilClerk = "council-clerk"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .alphaHunter: return "Alpha Hunter"
        case .riskSentinel: return "Risk Sentinel"
        case .macroOracle: return "Macro Oracle"
        case .devilsAdvocate: return "Devil's Advocate"
        case .councilClerk: return "Council Clerk"
        }
    }

    public var emoji: String {
        switch self {
        case .alphaHunter: return "🎯"
        case .riskSentinel: return "🛡️"
        case .macroOracle: return "🔮"
        case .devilsAdvocate: return "😈"
        case .councilClerk: return "📋"
        }
    }

    public var color: Color {
        switch self {
        case .alphaHunter: return .neonGreen
        case .riskSentinel: return .neonOrange
        case .macroOracle: return .neonPurple
        case .devilsAdvocate: return .neonRed
        case .councilClerk: return .neonCyan
        }
    }

    public var roleDescription: String {
        switch self {
        case .alphaHunter: return "Seeks highest APY & yield opportunities"
        case .riskSentinel: return "Capital defense & impermanent loss veto"
        case .macroOracle: return "Macro market trends & sentiment index"
        case .devilsAdvocate: return "Contrarian stress-tester & worst-case analysis"
        case .councilClerk: return "Synthesizes final consensus & triggers v4 hooks"
        }
    }

    public var catchphrase: String {
        switch self {
        case .alphaHunter: return "\"Profit is the only metric that matters.\""
        case .riskSentinel: return "\"Safety first. Capital preserved second.\""
        case .macroOracle: return "\"The macro trends don't lie.\""
        case .devilsAdvocate: return "\"But have you considered a 40% flash drawdown?\""
        case .councilClerk: return "\"Synthesizing consensus for Base Sepolia dispatch.\""
        }
    }
}

// MARK: - Deliberation Stance
public enum DeliberationOpinion: String, CaseIterable {
    case support = "SUPPORT"
    case concern = "CONCERN"
    case oppose = "OPPOSE"
    case neutral = "NEUTRAL"

    public var color: Color {
        switch self {
        case .support: return .neonGreen
        case .concern: return .neonOrange
        case .oppose: return .neonRed
        case .neutral: return .neonCyan
        }
    }
}

// MARK: - Council Message
public struct CouncilMessage: Identifiable, Equatable {
    public let id: String
    public let agentRole: AgentRole
    public let opinion: DeliberationOpinion
    public let reasoning: String
    public let confidence: Int // 0 - 100
    public let timestamp: Date

    public init(id: String = UUID().uuidString, agentRole: AgentRole, opinion: DeliberationOpinion, reasoning: String, confidence: Int, timestamp: Date = Date()) {
        self.id = id
        self.agentRole = agentRole
        self.opinion = opinion
        self.reasoning = reasoning
        self.confidence = confidence
        self.timestamp = timestamp
    }
}

// MARK: - Trade Proposal & Consensus
public struct TradeProposal: Identifiable, Equatable {
    public let id: String
    public let action: String
    public let inputToken: String
    public let inputAmount: String
    public let outputToken: String
    public let expectedOutput: String
    public let riskLevel: String // "LOW", "MODERATE", "HIGH"
    public let consensus: String // "APPROVED", "MAJORITY", "CONTESTED", "VETOED"
    public let reasoning: String
    public let votes: VoteTally
    
    // Uniswap v4 Hook Parameters Slide-In
    public let dynamicFeeBps: Int
    public let maxSwapSize: String
    public let sentimentScore: Double
    
    public var txHash: String?
    public var isExecuted: Bool

    public struct VoteTally: Equatable {
        public let support: Int
        public let oppose: Int
        public let abstain: Int
        
        public init(support: Int, oppose: Int, abstain: Int) {
            self.support = support
            self.oppose = oppose
            self.abstain = abstain
        }
    }

    public init(
        id: String = "council-\(Int(Date().timeIntervalSince1970))",
        action: String,
        inputToken: String,
        inputAmount: String,
        outputToken: String,
        expectedOutput: String,
        riskLevel: String,
        consensus: String,
        reasoning: String,
        votes: VoteTally,
        dynamicFeeBps: Int = 5,
        maxSwapSize: String = "500 USDC",
        sentimentScore: Double = 0.78,
        txHash: String? = nil,
        isExecuted: Bool = false
    ) {
        self.id = id
        self.action = action
        self.inputToken = inputToken
        self.inputAmount = inputAmount
        self.outputToken = outputToken
        self.expectedOutput = expectedOutput
        self.riskLevel = riskLevel
        self.consensus = consensus
        self.reasoning = reasoning
        self.votes = votes
        self.dynamicFeeBps = dynamicFeeBps
        self.maxSwapSize = maxSwapSize
        self.sentimentScore = sentimentScore
        self.txHash = txHash
        self.isExecuted = isExecuted
    }
}

// MARK: - Limit Order & Trade Tower
public struct LimitOrder: Identifiable, Equatable {
    public let id: String
    public let tokenIn: String
    public let tokenOut: String
    public let direction: String // "BUY" | "SELL"
    public let targetPrice: Double
    public let amount: Double
    public var status: Status
    public let createdAt: Date
    public var txHash: String?
    public var towerCoord: CGPoint // Coordinate on city map

    public enum Status: String {
        case construction = "CONSTRUCTING"
        case active = "ACTIVE"
        case completed = "FILLED"

        public var color: Color {
            switch self {
            case .construction: return .cyberMuted
            case .active: return .neonCyan
            case .completed: return .cyberYellow
            }
        }
    }
}

// MARK: - ERC-8004 Agent NFT Profile
public struct AgentNFT: Identifiable, Equatable {
    public let id: String
    public let tokenId: Int
    public let name: String
    public let strategy: String // "dca", "momentum", "arbitrage", "yield"
    public let riskTolerance: String // "conservative", "moderate", "aggressive"
    public let reputation: Int // 0 - 100
    public let txHash: String
    public var isDeployed: Bool
    public let description: String

    public var strategyColor: Color {
        switch strategy.lowercased() {
        case "arbitrage": return .neonGreen
        case "momentum": return .neonMagenta
        case "dca": return .cyberYellow
        case "yield": return .neonCyan
        default: return .white
        }
    }
}

// MARK: - Street Coins ($YTEST)
public struct StreetCoin: Identifiable, Equatable {
    public let id: String
    public var position: CGPoint // 2D grid position
    public let type: CoinType
    public var isCollected: Bool

    public enum CoinType: String {
        case bronze = "BRONZE"
        case silver = "SILVER"
        case gold = "GOLD"

        public var value: Double {
            switch self {
            case .bronze: return 0.1
            case .silver: return 0.5
            case .gold: return 1.0
            }
        }

        public var color: Color {
            switch self {
            case .bronze: return Color(hex: "CD7F32")
            case .silver: return Color(hex: "C0C0C0")
            case .gold: return Color(hex: "FFD700")
            }
        }
    }
}

// MARK: - Roaming Autonomous Agent in Metropolis
public struct RoamingAgent: Identifiable, Equatable {
    public let id: String
    public let nft: AgentNFT
    public var position: CGPoint
    public var targetNodeIndex: Int
    public var currentAction: String
    public var coinsCollected: Int
}

// MARK: - Floating Reward Particle
public struct FloatingReward: Identifiable, Equatable {
    public let id: String = UUID().uuidString
    public let text: String
    public let color: Color
    public var position: CGPoint
    public var opacity: Double = 1.0
}
