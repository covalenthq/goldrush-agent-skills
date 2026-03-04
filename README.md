# GoldRush Agent Skills

LLMs have broad knowledge but shallow precision — when an AI agent needs to call a blockchain API, it's working from training data that may be outdated, incomplete, or just wrong, leading to hallucinated endpoints, incorrect parameters, and wasted credits. GoldRush Agent Skills solve this by embedding structured, specification-compliant API documentation directly into the agent's context window, giving it the exact routing logic, endpoint details, and workflow patterns it needs to make correct calls on the first try. No web scraping, no RAG pipelines — just self-contained skill files that work across **Claude Code**, **OpenClaw**, **Cursor**, **Windsurf**, **Cline**, and any agent that supports SKILL.md.

Browse the full agent directory at [goldrush.dev/agents](https://goldrush.dev/agents/).

## Skills


| Skill | Description |
|-------|-------------|
| **[goldrush-foundational-api](goldrush-foundational-api/)** | REST API for historical and near-real-time data across 100+ chains — balances, transactions, NFTs, prices |
| **[goldrush-streaming-api](goldrush-streaming-api/)** | Real-time GraphQL subscriptions over WebSocket — OHLCV candles, DEX pairs, wallet activity |
| **[goldrush-cli](goldrush-cli/)** | Terminal-first blockchain data tool with MCP support for Claude Desktop and Claude Code |
| **[goldrush-x402](goldrush-x402/)** | Pay-per-request blockchain data via the x402 protocol — no API key, no signup, just a funded wallet |

## Get Started

### 1. Get a GoldRush API key

Sign up at [goldrush.dev](https://goldrush.dev) — 14-day free trial + $10/month vibe coding tier available. 

### 2. Install the skill

Copy the relevant skill folder into your agent's skills directory. Each skill contains a `SKILL.md` entry point and a `references/` directory with detailed documentation.

```
goldrush-cli/
├── SKILL.md              ← entry point
└── references/
    └── overview.md

goldrush-foundational-api/
├── SKILL.md              ← entry point
└── references/
    ├── overview.md
    ├── endpoints-balances.md
    ├── endpoints-transactions.md
    ├── endpoints-nft-security-crosschain.md
    ├── endpoints-utility.md
    ├── integration-guide.md
    └── workflows.md

goldrush-streaming-api/
├── SKILL.md              ← entry point
└── references/
    ├── overview.md
    ├── endpoints.md
    └── sdk-guide.md

goldrush-x402/
├── SKILL.md              ← entry point
└── references/
    ├── overview.md
    ├── endpoints.md
    └── ai-agents.md
```

### 3. Verify

Ask your agent:

> "Get the token balances for vitalik.eth on Ethereum"

## Which Skill Should I Use?

| Use case | Skill |
|----------|-------|
| Ad-hoc terminal queries, MCP integration | **goldrush-cli** |
| Historical data, batch queries, REST endpoints | **goldrush-foundational-api** |
| Real-time price feeds, live DEX monitoring, streaming | **goldrush-streaming-api** |
| Autonomous agents, no API key, pay-per-request | **goldrush-x402** |

## Supported Chains

GoldRush supports **100+ chains** including Ethereum, Solana, Base, BNB, Arbitrum, Polygon, Optimism, Avalanche, and many more. See the full list at [goldrush.dev/docs/networks](https://goldrush.dev/docs/networks/).

## Links

- [GoldRush](https://goldrush.dev/platform) — Platform & API keys
- [GoldRush Docs](https://goldrush.dev/docs) — API documentation
- [Agent Directory](https://goldrush.dev/agents/) — Setup guides for all supported AI agents
- [TypeScript SDK](https://www.npmjs.com/package/@covalenthq/client-sdk) — `npm install @covalenthq/client-sdk`
- [GoldRush CLI](https://www.npmjs.com/package/@covalenthq/goldrush-cli) — `npx @covalenthq/goldrush-cli`

## License

MIT — see [LICENSE](LICENSE).
