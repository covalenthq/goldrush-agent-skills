---
name: goldrush-hyperliquid
description: "GoldRush Hyperliquid API - the complete data layer for Hyperliquid (HyperCore + HIP-3 + HyperEVM). Use this skill whenever the user is building on Hyperliquid, mentions hitting Hyperliquid /info rate limits or the 1000-subscription-per-IP cap on wss://api.hyperliquid.xyz/ws, needs a drop-in replacement for api.hyperliquid.xyz/info or /ws, wants to subscribe to l2Book (aggregated order book, wildcard coin) or the GoldRush-native l4Book (order-level diff stream with user/oid/cloid/tif), wants HIP-3 market data, needs real-time wallet streaming for HyperCore, or needs pre-decoded liquidations or vault events. The Info API and WebSocket API at hypercore.goldrushdata.com are byte-for-byte wire-compatible with the public Hyperliquid endpoints and have no rate limits or per-IP subscription caps. For non-Hyperliquid blockchain data, use goldrush-foundational-api instead."
---

# GoldRush Hyperliquid API

The complete data layer for Hyperliquid. One API key unlocks:

- **Info API** - drop-in replacement for `POST api.hyperliquid.xyz/info` at `hypercore.goldrushdata.com/info`. No rate limits. Same request body, same response shape.
- **WebSocket API** - drop-in replacement for `wss://api.hyperliquid.xyz/ws` at `wss://hypercore.goldrushdata.com/ws?key=<KEY>`. No 1000-subscription-per-IP cap. `l2Book` (wildcard `coin`) and the GoldRush-native `l4Book` order-level diff stream.
- **Foundational API** - HyperEVM token balances, transfers, approvals, NFTs, gas.

## Drop-in Info API

```typescript
// Before
fetch("https://api.hyperliquid.xyz/info", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({ type: "clearinghouseState", user: "0x...", dex: "" }),
});

// After - same body, no rate limits
fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ type: "clearinghouseState", user: "0x...", dex: "" }),
});
```

That's it. Existing SDKs (`nomeida/hyperliquid` for JS, `hyperliquid-python-sdk` for Python) work after a `baseUrl` override.

## Available Info API types (today)

| Type | Use |
|---|---|
| `metaAndAssetCtxs` | Perp universe + per-asset live mark price, funding, OI, day volume |
| `meta` | Perp universe metadata only - size decimals, max leverage, margin tiers (no live context) |
| `spotMetaAndAssetCtxs` | Spot universe + per-pair live mark price, mid, day volume |
| `spotMeta` | Spot universe metadata only - pairs and the full token registry (no live context) |
| `outcomeMeta` | Active HIP-4 outcome universe with outcome IDs, descriptions, and Yes/No side specs |
| `settledOutcome` | Resolution data for a settled HIP-4 outcome - original `spec`, `settleFraction` paid to `Yes`, and `details` describing how it resolved |
| `l2Book` | Aggregated Level-2 order book snapshot for one coin (`{px, sz, n}` bid/ask levels) |
| `candleSnapshot` | Historical OHLCV candles for a coin and interval over a time window |
| `fundingHistory` | Market-wide historical funding rates and premiums for a coin over a time window |
| `clearinghouseState` | Per-user perp account: positions, margin, account value |
| `spotClearinghouseState` | Per-user spot balances |
| `frontendOpenOrders` | Per-user open orders with TP/SL trigger metadata |
| `activeAssetData` | Per-user, per-asset trading limits, leverage setting, available size, and mark price |
| `subAccounts` | Sub-accounts owned by a master, each with inlined perp and spot state |
| `webData2` | Composite frontend snapshot for a wallet - clearinghouse state, open orders, perp meta/asset contexts, spot asset contexts, TWAP and vault state in one round-trip |
| `userFills` | Most recent fills for a user |
| `userFillsByTime` | Fills bounded by a time window |
| `userCompletedTrades` | Latest fully-closed round-trip trades for a wallet, newest-first (default 100, max 500), each with realized PnL, funding, fees, VWAP entry/exit. **GoldRush-native** |
| `userCompletedTradesByTime` | Fully-closed round-trip trades over a `close_time` window, oldest-first, with a `{close_time}_{tx_index}` keyset cursor for forward paging. **GoldRush-native** |
| `userPnlSummary` | One aggregate object per wallet - net realized PnL, win/loss rate, trade count, volume, fees, funding, active days, account age, and traded pairs. **GoldRush-native** |
| `userTwapSliceFills` | Most recent TWAP slice fills tagged with the parent `twapId` |
| `userTwapSliceFillsByTime` | TWAP slice fills bounded by a time window. Served from GoldRush's historical store so windows extend past upstream's 10,000-fill retention |
| `userFunding` | Funding payment history with rate, applied size, USDC delta |
| `userNonFundingLedgerUpdates` | Ledger events except funding - deposits, withdrawals, transfers, vault flows, liquidations |
| `userVaultEquities` | Per-vault locked equity with unlock timestamps |
| `delegatorSummary` | Current delegated, undelegated, and pending-withdrawal HYPE totals |
| `delegatorHistory` | Delegate, undelegate, deposit, and withdrawal staking events |
| `delegatorRewards` | Accrued staking rewards (delegation and validator commission) |
| `allMids` | Current mid price for every actively traded coin (coin->price map; spot pairs keyed `@index`) |
| `perpDexLimits` | Per-DEX open-interest, position-size, and transfer limits for a HIP-3 perp DEX |
| `marginTable` | Margin-tier (leverage-bracket) table for a `marginTableId` |
| `maxMarketOrderNtls` | Maximum market-order notional for each leverage bucket |
| `perpsAtOpenInterestCap` | Perp coins currently at their open-interest cap |
| `exchangeStatus` | Current exchange operational status and server time |
| `validatorL1Votes` | Pending validator L1 governance votes/actions |
| `spotDeployState` | Spot-token deployment state and gas auction for a deployer |
| `perpDeployAuctionStatus` | Current perp-deploy Dutch-auction status |
| `liquidatable` | Accounts currently eligible for liquidation |
| `openOrders` | A wallet's resting open orders (coin, side, `limitPx`, `sz`, `oid`) |
| `userRole` | Account role - `user`, `agent`, `vault`, or `subAccount` (with its master) |
| `userFees` | Fee schedule and recent daily trading volume |
| `userRateLimit` | API rate-limit usage, cap, and cumulative volume |
| `userAbstraction` | Account-abstraction mode (`disabled` or `unifiedAccount`) |
| `extraAgents` | Approved API-agent wallets (name, address, validUntil) |
| `userToMultiSigSigners` | Authorized signers and threshold for a multi-sig account (null if not multi-sig) |
| `maxBuilderFee` | Max builder fee (tenths of a bp) a user approved for a builder |
| `delegations` | Active HYPE staking delegations, per validator |
| `userBorrowLendInterest` | Borrow/lend interest accrual history over a time window |
| `vaultSummaries` | Summary information for every vault |
| `vaultDetails` | Full detail for one vault - leader, portfolio, APR, followers |
| `leadingVaults` | Vaults that a user leads |
| `portfolioState` | Perp + spot state + account-abstraction mode for a wallet in one call (`dex: "ALL_DEXES"` for all DEXes). **GoldRush-native** |
| `allPerpMetas` | Universe + margin tables for every perp DEX in one array (index 0 native, then HIP-3). **GoldRush-native** |
| `batchClearinghouseState` | Perp account state for 1-50 wallets in one request. **GoldRush-native**, no upstream equivalent |
| `batchSpotClearinghouseState` | Spot balances for 1-50 wallets in one request. **GoldRush-native**, no upstream equivalent |
| `builderFills` | Most recent fills attributed to a builder address (up to 2,000) for revenue attribution and order-flow analytics. **GoldRush-native**, no upstream equivalent |
| `builderFillsByTime` | Builder-attributed fills bounded by a time window for revenue attribution and fee accounting. **GoldRush-native**, no upstream equivalent |

Any other `type` value returns `{"error":"unsupported_type","type":"<the type you sent>"}`. Type expansion is on the roadmap.

## Available WebSocket subscriptions (today)

| Channel | Use |
|---|---|
| `l2Book` | Aggregated `{px, sz, n}` order book per tick. `coin` is **optional** - omit to stream every asset on one subscription. Drop-in for `wss://api.hyperliquid.xyz/ws` `l2Book`, no per-IP cap. |
| `l2BookDiff` | Initial L2 `Snapshot` per coin plus per-block `Updates` carrying only changed `{px, sz, n}` levels. `coin` accepts a single asset, an array, or wildcard. **GoldRush-native**, no upstream equivalent. |
| `l4Book` | Order-level snapshot of every resting order plus per-block diffs (`order_statuses` + `book_diffs`). Exposes `user`, `oid`, `cloid`, `tif`, `triggerCondition`. `coin` is **required**. **GoldRush-native**, no upstream equivalent. |
| `userFills` | Live trade fills for one or more wallets, batched per block as `[address, fill]` tuples. Aliases `user` / `users` accepted. |
| `orderUpdates` | Live order lifecycle events (placements, fills, cancels, rejections) for one or more wallets, batched per block as an `updates` array tagged with the originating `user`. |
| `liquidationFills` | Global stream of every liquidation fill on HyperCore. Same shape as `userFills` with a non-null `liquidation` object on every entry. **GoldRush-native**, no upstream equivalent. |
| `allFills` | Global stream of every fill on HyperCore in real time. Optional `coin` filter narrows to a single market. Same per-fill shape as `userFills`. **GoldRush-native**, no upstream equivalent. |
| `builderFills` | Live attributed fills for one or more builder addresses, with `builder` and `builderFee` on every entry. Pass `builder` (single) or `addresses` (array). **GoldRush-native**, no upstream equivalent. |
| `userNonFundingLedgerUpdates` | Live non-funding ledger events (deposits, withdrawals, transfers, liquidations, vault actions, staking, rewards) for one or more wallets. |

## When to use which surface

| Need | Use |
|---|---|
| Account state, market snapshot, open orders | Info API (`POST /info`) |
| Live order book - aggregated price levels, wildcard across all assets | WebSocket API `l2Book` on `wss://hypercore.goldrushdata.com/ws` |
| Live order book - per-order detail, queue position, per-user flow attribution | WebSocket API `l4Book` (snapshot + per-block diffs, **GoldRush-native**) |
| Real-time wallet activity (1 → 10,000 wallets) | `walletTxs` subscription |
| HIP-3 and HIP-4 OHLCV candles | `ohlcvCandlesForPair` with `xyz:GOLD-USDC` syntax |
| Pre-decoded liquidations and vault events | `walletTxs` → `HypercoreFillTransaction.liquidation`, `HypercoreLedgerEvent` |
| HyperEVM (chain `999`) token balances/transfers/NFTs | Foundational API on `hyperevm-mainnet` |

## Critical rules

1. **Info API endpoint URL** - `https://hypercore.goldrushdata.com/info` (note: `hypercore`, not `hyperliquid`).
2. **Info API auth header** - `Authorization: Bearer <GOLDRUSH_API_KEY>`. Same key as Foundational.
3. **WebSocket API endpoint URL** - `wss://hypercore.goldrushdata.com/ws?key=<GOLDRUSH_API_KEY>`. Auth is a `?key=` query parameter at connect time; **no `Authorization` header is sent**. Same key as the Info API.
4. **Wire-compat with Hyperliquid** - Info API request body and WebSocket subscription payloads are byte-for-byte identical to the public Hyperliquid endpoints for implemented types/channels.
5. **`l4Book` is GoldRush-only** - it does not exist on `wss://api.hyperliquid.xyz/ws`. `coin` is required; `l2Book`'s `coin` is optional (wildcard streams every asset).
6. **HIP-3 and HIP-4 syntax** - `<deployer>:<symbol>-<quote>` for OHLCV pairs (e.g. `xyz:GOLD-USDC`); plain symbol for OHLCV tokens.
7. **Streaming chain enum** - `HYPERCORE_MAINNET` (SCREAMING_SNAKE_CASE), not `hypercore-mainnet`.
8. **Historical depth** - HyperCore data starts at block 606,858,021 (2025-05-25T14:32:53Z); HyperEVM goes back to genesis.
9. **No rate limits** on the Info API and WebSocket API for HyperCore. No 1000-subscription-per-IP cap on the WebSocket API.

## Reference Files

| File | When to read |
|------|-------------|
| [overview.md](references/overview.md) | Need full product overview, infrastructure details, or what's available across all surfaces |
| [info-api.md](references/info-api.md) | Building against the `POST /info` endpoint - migration, SDK overrides, per-endpoint reference |
| [websocket-api.md](references/websocket-api.md) | Building against `wss://hypercore.goldrushdata.com/ws` - `l2Book` aggregated snapshots, `l4Book` order-level diffs, per-endpoint reference and recipes |
| [streaming.md](references/streaming.md) | Building real-time features over GraphQL streaming subscriptions - wallet firehose, HIP-3 and HIP-4 OHLCV, liquidations and vault events |
| [roadmap.md](references/roadmap.md) | What's shipping next - type expansion, time-travel, cross-venue, signed responses |
