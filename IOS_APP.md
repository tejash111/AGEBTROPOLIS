# Agentropolis iOS — Native Swift App with Liquid Glass UI

Agentropolis converted into a native iOS application built with SwiftUI, matching [agentropolis.paracausal.tech/app](https://agentropolis.paracausal.tech/app) with a modern **Liquid Glass (Glassmorphism)** aesthetic.

---

## 📱 Features

- **Liquid Glass Design System**:
  - Specular glossy highlights and refractive gradient borders.
  - Multi-layer `.ultraThinMaterial` frosted glass.
  - Ambient liquid aurora glows in the background (Cyan, Magenta, Yellow/Green) that dynamically refract through floating glass surfaces.
  - Floating Liquid Glass Header HUD with live `$YTEST` balance, user level, and ENS identity (`agentropolis.eth`).
  - Floating Liquid Glass Bottom Navigation Dock with illuminated active tab selector.

- **Interactive Metropolis Canvas (`CityCanvasView`)**:
  - Cyberpunk street grid with road lane markings and glowing street lamps.
  - Crystalline glass Tech Towers with illuminated circuit cores (Alpha Vault, Sentinel HQ, Matrix Pool, Yellow Hub).
  - Physical **Trade Towers** rising from the ground for active Uniswap v4 limit orders.
  - Roaming autonomous AI agents (Luna DCA, Vortex Momentum, etc.) traveling between road waypoints.
  - Street coins ($YTEST) with touch-collection and rising particle animations.
  - Floating `+ PLACE LIMIT ORDER` liquid glass button.

- **AI Council Chamber (`CouncilRoomView`)**:
  - Floating frosted glass Council Table with glowing holographic seats for the 5 agents:
    - 🎯 **Alpha Hunter** (Yield maximizer, APY hunter)
    - 🛡️ **Risk Sentinel** (Capital defense, impermanent loss & veto)
    - 🔮 **Macro Oracle** (Trend analysis, market sentiment index)
    - 😈 **Devil's Advocate** (Contrarian stress-tester)
    - 📋 **Council Clerk** (Consensus aggregator & proposal drafter)
  - 1-on-1 private encrypted chat uplink with individual agents.
  - Turn-by-turn multi-agent deliberation transcript feed.
  - Final Consensus Proposal Card with **Uniswap v4 Hook Parameters** (`CouncilFeeHook`, `SwapGuardHook`, `SentimentOracleHook`).
  - Base Sepolia execution with verified transaction receipts.

- **ERC-8004 Agent Marketplace & Minting (`AgentMarketplaceView`)**:
  - On-chain registry of agents pulled from ERC-8004 contract `0x8004A818BFB912233c491871b3d84c89A494BD9e`.
  - Filter by strategy: All, DCA, Momentum, Arbitrage, Yield.
  - "Mint New Agent" form generating on-chain NFT profiles.
  - Deploy agents into the city grid for 0.01 `$YTEST`.

- **Limit Order Construction (`LimitOrderSheet`)**:
  - Token pair swapper (WETH / USDC), direction toggle (BUY / SELL), target price, and order amount.
  - Constructs a Trade Tower structure at assigned city coordinates.

- **Yellow Network ClearSync Session (`YellowSessionSheet`)**:
  - Gas-free state channel dashboard tracking micro-actions and gas savings.
  - Off-chain `$YTEST` deposit and withdraw actions.

---

## 🚀 How to Run the iOS App

Open the project in Xcode:

```bash
open "UntitledProjects/Untitled Project/Untitled Project.xcodeproj"
```

1. Select scheme **MyApp**.
2. Select an iPhone Simulator (e.g., iPhone 18 Pro, iPhone 17).
3. Press **Cmd + R** to run.
