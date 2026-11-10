# Hyperliquid Streaming Recipes

## Critical Rules

1. GraphQL WebSocket URL: `wss://streaming.goldrushdata.com/graphql` (this is the GraphQL streaming endpoint - distinct from the Hyperliquid WebSocket API at `wss://hypercore.goldrushdata.com/ws?key=<KEY>`, which is covered in `websocket-api.md`)
2. Chain enum: `HYPERCORE_MAINNET` (SCREAMING_SNAKE_CASE)
3. HIP-3 and HIP-4 pair address syntax: `<deployer>:<symbol>-<quote>` (e.g. `xyz:GOLD-USDC`)
4. HIP-3 and HIP-4 token address syntax: plain symbol (e.g. `GOLD`, `OIL`)
5. `walletTxs` accepts up to thousands of wallet addresses per subscription
6. Pre-decoded events: `HypercoreFillTransaction` (with `liquidation`), `HypercoreLedgerEvent` (20+ subtypes), `HypercoreFundingEvent`, `HypercoreDepositEvent`, `HypercoreWithdrawalEvent`, `HypercoreDelegationEvent`

## Common Recipes

| Goal | Endpoint | Filter |
|------|----------|--------|
| Wallet firehose | `walletTxs` | `chain_name: HYPERCORE_MAINNET, wallet_addresses: [...]` |
| HIP-3 / HIP-4 OHLCV by pair | `ohlcvCandlesForPair` | `pair_addresses: ["xyz:GOLD-USDC", ...]` |
| HIP-3 / HIP-4 OHLCV by token | `ohlcvCandlesForToken` | `token_addresses: ["GOLD", "OIL", ...]` |
| Liquidation tape | `walletTxs` → `HypercoreFillTransaction.liquidation` non-null | filter client-side |
| Vault leaderboard | `walletTxs` → `HypercoreLedgerEvent.delta` (`LedgerVaultLeaderCommission`, `LedgerVaultDistribution`) | aggregate per vault |

---

The public Hyperliquid WebSocket caps you at **1000 subscriptions per IP**, and every REST endpoint is weight-rate-limited per IP and per address. That's nowhere near enough to track every active trader on Hyperliquid in real time - exactly what copy-trade, whale alerts, and "follow the flow" features need.

GoldRush's `walletTxs` subscription has **zero rate limits** and scales to thousands of concurrent wallet subscriptions on a single connection.

## No public "all users" or leaderboard endpoint

Hyperliquid's public `/info` API has no endpoint that lists every user, and the leaderboard you see in the frontend is backed by an internal endpoint that isn't part of the documented API - so there's no supported way to enumerate or scrape all addresses upstream. GoldRush gives you two supported paths instead:

- **Discover active traders in real time.** The **`allFills`** channel streams every fill on HyperCore across every wallet - each entry carries the trader's address, so the live tape doubles as a rolling census of who is active right now. **`liquidationFills`** does the same for every liquidation.
- **Follow a cohort at scale.** Once you have a set of addresses (top traders, whales, a copy-trade list), the `walletTxs` firehose below streams all of their activity over a single connection with no per-IP or per-address limit - something the public 1000-subscription cap makes impossible.

## What you get

- **One connection, many wallets.** Pass an array of wallet addresses; updates for any of them come through the same stream.
- **Pre-decoded events.** Fills, funding, vault actions, ledger events, deposits, withdrawals, and delegations come through as typed GraphQL union members - no parsing.
- **Liquidation context inline.** When a fill is part of a liquidation, the `liquidation` block is attached directly.
- **Sub-second latency.** Tokyo-colocated, validator-peered ingestion.

## Subscribe

```typescript GoldRush SDK
import { GoldRushClient } from "@covalenthq/client-sdk";

const client = new GoldRushClient(process.env.GOLDRUSH_API_KEY);

const SUBSCRIPTION_QUERY = `
  subscription {
    walletTxs(
      wallet_addresses: [
        "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "0x5078c2fbea2b2ad61bc840bc023ecb5df8b5ecaf",
        "0xba1ad77b1c46a7c2c43cf5e10c14e8f0d7d6d5e3"
      ]
      chain_name: HYPERCORE_MAINNET
    ) {
      tx_hash
      block_signed_at
      from_address
      decoded_details {
        ... on HypercoreFillTransaction {
          coin
          side
          price
          size
          closed_pnl
          fee
          fee_token
          builder
          builder_fee
          liquidation {
            method
            liquidated_user
            market_price
          }
        }
        ... on HypercoreFundingEvent {
          coin
          funding_rate
          funding_amount
        }
        ... on HypercoreDepositEvent { amount }
        ... on HypercoreWithdrawalEvent { amount }
        ... on HypercoreDelegationEvent {
          validator
          amount
          is_undelegate
        }
      }
    }
  }
`;

client.StreamingService.rawQuery(
  SUBSCRIPTION_QUERY,
  {},
  {
    next: (data) => console.log(JSON.stringify(data, null, 2)),
    error: (err) => console.error(err),
    complete: () => console.log("done"),
  }
);
```

```python Python
import asyncio
import os
from gql import gql, Client
from gql.transport.websockets import WebsocketsTransport

WS_URL = "wss://streaming.goldrushdata.com/graphql"

SUBSCRIPTION = gql("""
subscription {
  walletTxs(
    wallet_addresses: [
      "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
      "0x5078c2fbea2b2ad61bc840bc023ecb5df8b5ecaf"
    ]
    chain_name: HYPERCORE_MAINNET
  ) {
    tx_hash
    block_signed_at
    from_address
    decoded_details {
      ... on HypercoreFillTransaction {
        coin side price size closed_pnl fee
        liquidation { method liquidated_user market_price }
      }
      ... on HypercoreFundingEvent { coin funding_rate funding_amount }
    }
  }
}
""")

async def main():
    transport = WebsocketsTransport(
        url=WS_URL,
        init_payload={"GOLDRUSH_API_KEY": os.environ["GOLDRUSH_API_KEY"]},
    )
    async with Client(transport=transport, fetch_schema_from_transport=False) as session:
        async for result in session.subscribe(SUBSCRIPTION):
            print(result)

asyncio.run(main())
```

## Patterns

### Copy-trading

Subscribe to a curated list of high-PnL wallets. Filter the incoming stream on `HypercoreFillTransaction`, then mirror the `coin`, `side`, and `size` to your own execution layer.

### Live whale feed

Subscribe to the top-N wallets by balance or notional position. Display every fill, liquidation, and large transfer in a chronological tape.

### Liquidation alerts

Filter the stream on `HypercoreFillTransaction` events where `liquidation` is non-null. Push the event payload to a notification channel (Discord, Telegram, push). Each event includes the liquidated user, mark price, and method (`Market` vs `Backstop`).

### Position monitoring

Pair the stream with periodic **`clearinghouseState`** calls to maintain accurate per-wallet position state without polling between fills.

## Production considerations

The happy-path example above is enough to prototype. Three things to add before shipping:

- **Reconnect on close or error.** The `complete` callback fires on a clean stream close; `error` fires on transport errors. In both cases, re-invoke the subscribe function with backoff so the firehose self-heals after network blips:

```typescript TypeScript
function subscribe() {
  client.StreamingService.rawQuery(
    SUBSCRIPTION_QUERY,
    {},
    {
      next: (data) => handleEvent(data),
      error: (err) => { console.error(err); setTimeout(subscribe, 1000); },
      complete: () => setTimeout(subscribe, 1000),
    },
  );
}

subscribe();
```

- **Validate addresses up front.** Malformed wallet addresses can surface via `error` and tear down the whole subscription. Pre-filter the input list with `/^0x[a-fA-F0-9]{40}$/` (or your library's validator) before passing it in.
- **No gap-fill on reconnect.** The subscription delivers events from the moment it opens - events that occurred during a disconnect are not replayed. For continuity across the gap, query **`userFillsByTime`** over the disconnect window after reconnecting.

## Scaling

| Scale | Approach |
|---|---|
| Up to ~1,000 wallets | One subscription with the full address list. |
| 1,000 – 10,000+ wallets | Shard across multiple subscriptions on the same connection. The SDK reuses one WebSocket. |
| Live cohort changes | Unsubscribe and resubscribe with the new address list - no need to tear down the connection. |

For very high fan-out, contact us about dedicated capacity.

## Related

- `HypercoreFillTransaction` - full type reference.
- `HypercoreLedgerEvent` - vault, staking, borrow/lend, rewards subtypes.
- **Liquidations and vault events** - full decoded-event walkthrough.
- Wallet Activity Stream - subscription reference.

---

HIP-3 lets builders deploy their own perp markets on Hyperliquid - equities, commodities, niche assets - and new ones appear constantly. The public `candleSnapshot` is poll-based and effectively limited to mainstream markets, and discovering HIP-3 markets means stitching market IDs by hand.

GoldRush's `ohlcvCandlesForPair` and `ohlcvCandlesForToken` are real-time WebSocket streams that address HIP-3 markets natively with the **deployer-prefix syntax**. List, chart, or stream any market the moment it goes live.

## Stream OHLCV for a HIP-3 pair

```typescript GoldRush SDK
import {
  GoldRushClient,
  StreamingChain,
  StreamingInterval,
  StreamingTimeframe,
} from "@covalenthq/client-sdk";

const client = new GoldRushClient(process.env.GOLDRUSH_API_KEY);

client.StreamingService.subscribeToOHLCVPairs(
  {
    chain_name: StreamingChain.HYPERCORE_MAINNET,
    pair_addresses: ["xyz:GOLD-USDC", "flx:OIL-USDH"],
    interval: StreamingInterval.ONE_MINUTE,
    timeframe: StreamingTimeframe.ONE_HOUR,
  },
  {
    next: (data) => console.log("OHLCV:", data),
    error: (err) => console.error(err),
    complete: () => console.log("done"),
  }
);
```

```bash Install
npm install @covalenthq/client-sdk
```

## Stream OHLCV for a token (across all markets)

```typescript
client.StreamingService.subscribeToOHLCVTokens(
  {
    chain_name: StreamingChain.HYPERCORE_MAINNET,
    token_addresses: ["GOLD", "OIL", "HYPE"],
    interval: StreamingInterval.ONE_MINUTE,
    timeframe: StreamingTimeframe.ONE_HOUR,
  },
  {
    next: (data) => console.log("Token OHLCV:", data),
    error: (err) => console.error(err),
  }
);
```

This aggregates across all DEXes and HIP-3 deployers carrying that token.

## Patterns

### "New markets" discovery tab

When a HIP-3 deployer launches a new market, the OHLCV stream picks it up the moment a candle starts forming. Combine `ohlcvCandlesForPair` with periodic listing logic to surface new markets in a "trending" tab.

### Deployer-scoped leaderboards

Group `HypercoreFillTransaction` events from `walletTxs` by HIP-3 deployer prefix. Compute per-deployer volume, fee revenue, top traders.

### Cross-deployer charting

A single chart widget that "just works" on `xyz:GOLD-USDC`, `BTC-USDC`, or any future HIP-3 market without special-casing the request. Pass the address through unchanged.

## Reference

- OHLCV Pairs Stream
- OHLCV Tokens Stream
- **HIP-4 outcome markets** - same address syntax, applied to prediction-market outcomes.
- **HyperCore chain page** - full HIP-3 example addresses and Hyperliquid Explorer references.
- [Live HIP-3 Market Screener](https://hyperliquid.goldrush.dev) - the public app we built on top of these streams.

## On the roadmap

A `perpDexs` Info API type that lists all HIP-3 builder-deployed perp DEXes with metadata.

---

HIP-4 launched on Hyperliquid mainnet on **2 May 2026** and added a new asset class to HyperCore: **outcome markets**. Outcomes are fully-collateralized binary contracts that trade on the same CLOB as spot and perps, settle in USDH, and resolve to either `0` or `1` against an authorized oracle at expiry.

Because outcome markets ride the same matching engine as every other HyperCore market, you don't need a new client, a new WebSocket, or a new schema to stream them. Every primitive in this section - `ohlcvCandlesForPair`, `ohlcvCandlesForToken`, and `walletTxs` - works on HIP-4 markets from the moment they go live.

## HIP-4 in 60 seconds

| Property | Value |
|---|---|
| **Contract type** | Binary outcome (`Yes` / `No`), USDH-collateralized, no liquidation. |
| **Price range** | `0.001` to `0.999`. The price *is* the implied probability. |
| **Settlement** | Resolves to `0` or `1` against an authorized oracle at the resolution timestamp. PnL settles in USDH. |
| **Lifecycle** | Opening auction (~15 min single-price clearing) → continuous CLOB trading → oracle settlement → halt + auto-settle. |
| **Fees** | Zero to open. Fees apply on close, burn, or settlement. |
| **Deployment** | Initial markets are curated and validator-deployed. Permissionless builder deployment follows in stages, mirroring HIP-3's rollout. |
| **Market encoding** | `encoding = 10 * outcome + side`. Each side of an outcome is its own tradeable market - `outcome 123, side 0` becomes encoding `1230`, `outcome 123, side 1` becomes `1231`. Use the encoding prefixed with a '#' to reference HIP-4 markets in the OHLCV endpoints. |

The first live market is a recurring **daily BTC binary outcome** that resolves against the HyperCore BTC mark price at a fixed UTC timestamp.

> **Tip:** Read the canonical spec: [HIP-4: Outcome markets](https://hyperliquid.gitbook.io/hyperliquid-docs/hyperliquid-improvement-proposals-hips/hip-4-outcome-markets).

## Discover live HIP-4 markets

HIP-4 ships its own dedicated Info type, ****`outcomeMeta`**** - separate from `metaAndAssetCtxs` (which covers perps and spot). It returns the active outcome universe: each entry carries an integer `outcome` ID, a `name`, a structured `description`, and a `sideSpecs` array.

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"type": "outcomeMeta"}'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({ type: "outcomeMeta" }),
});

const { outcomes } = await response.json();
```

```json outcomeMeta response
{
  "outcomes": [
    {
      "outcome": 123,
      "name": "Recurring",
      "description": "class:priceBinary|underlying:HYPE|expiry:20260310-1100|targetPrice:34.5|period:3m",
      "sideSpecs": [
        { "name": "Yes" },
        { "name": "No" }
      ]
    }
  ]
}
```

The `description` is a pipe-delimited spec. Parse it once and you get the full market definition:

| Field | Example | Meaning |
|---|---|---|
| `class` | `priceBinary` | Market class (binary outcome on a price threshold). |
| `underlying` | `HYPE` | Asset the outcome resolves against. |
| `expiry` | `20260310-1100` | Resolution timestamp, `YYYYMMDD-HHMM` UTC. |
| `targetPrice` | `34.5` | Threshold the underlying is compared against at expiry. |
| `period` | `3m` | Recurrence cadence for repeating markets. |

A typical discovery flow:

1. Call `outcomeMeta` to enumerate live `outcome` IDs and parse each `description`.
2. Compute the encoding for each side: `encoding = 10 * outcome + side`. Each side trades as its own market, so an outcome with `Yes` (side 0) and `No` (side 1) yields two encodings. Reference the market with the encoding prefixed with a '#'.
3. Subscribe to OHLCV for the encodings you want to track.
4. Stream fills via `walletTxs` for any address active on those markets.

> **Tip:** `outcomeMeta` is now available on the GoldRush drop-in Info API at `POST https://hypercore.goldrushdata.com/info`, wire-equal to upstream Hyperliquid. See the full **API reference**.

## Stream live probabilities (OHLCV)

Outcome prices are bounded between `0` and `1`, so an OHLCV candle on a HIP-4 market is, by construction, a **probability candle**. Multiply by 100 for percent.

```typescript GoldRush SDK
import {
  GoldRushClient,
  StreamingChain,
  StreamingInterval,
  StreamingTimeframe,
} from "@covalenthq/client-sdk";

const client = new GoldRushClient(process.env.GOLDRUSH_API_KEY);

client.StreamingService.subscribeToOHLCVPairs(
  {
    chain_name: StreamingChain.HYPERCORE_MAINNET,
    // HIP-4 encoding = 10 * outcome + side. Use the value(s) computed from `outcomeMeta`.
    pair_addresses: ["#1230"],
    interval: StreamingInterval.ONE_MINUTE,
    timeframe: StreamingTimeframe.ONE_HOUR,
  },
  {
    next: (candle) => {
      const probabilityPct = (candle.close * 100).toFixed(2);
      console.log(`${candle.pair_address} implied: ${probabilityPct}%`);
    },
    error: (err) => console.error(err),
  }
);
```

```graphql GraphQL Subscription
subscription {
  ohlcvCandlesForPair(
    chain_name: HYPERCORE_MAINNET
    pair_addresses: ["1230"]
    interval: ONE_MINUTE
    timeframe: ONE_HOUR
  ) {
    pair_address
    open
    high
    low
    close
    volume
    timestamp
  }
}
```

For a broader feed - every outcome market that references a given underlying - subscribe at the **token** level:

```typescript
client.StreamingService.subscribeToOHLCVTokens(
  {
    chain_name: StreamingChain.HYPERCORE_MAINNET,
    token_addresses: ["BTC"],
    interval: StreamingInterval.ONE_MINUTE,
    timeframe: StreamingTimeframe.ONE_HOUR,
  },
  {
    next: (data) => console.log("BTC-referenced markets:", data),
    error: (err) => console.error(err),
  }
);
```

## Stream fills on an outcome market

Every fill on a HIP-4 market arrives as a `HypercoreFillTransaction` inside `walletTxs`. The `coin` field carries the outcome symbol, `price` is the implied probability at fill time, and `closed_pnl` realises in USDH against the `0` / `1` settlement boundary.

```typescript
import { GoldRushClient } from "@covalenthq/client-sdk";

const client = new GoldRushClient(process.env.GOLDRUSH_API_KEY);

const SUBSCRIPTION_QUERY = `
  subscription {
    walletTxs(
      wallet_addresses: ["0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00"]
      chain_name: HYPERCORE_MAINNET
    ) {
      tx_hash
      block_signed_at
      from_address
      decoded_details {
        ... on HypercoreFillTransaction {
          coin
          side
          price
          size
          closed_pnl
          fee
          fee_token
          builder
          builder_fee
        }
        ... on HypercoreLedgerEvent {
          ledger_type
          time
          delta {
            ... on LedgerSpotTransfer { token amount usdc_value }
          }
        }
      }
    }
  }
`;

client.StreamingService.rawQuery(
  SUBSCRIPTION_QUERY,
  {},
  {
    next: (data) => console.log(JSON.stringify(data, null, 2)),
    error: (err) => console.error(err),
  }
);
```

## Detect settlement

When an outcome resolves, three things happen in quick succession on-chain:

1. Trading on the market halts.
2. Open orders cancel.
3. Each holder's position settles to USDH PnL against the final outcome (`0` or `1`).

Hyperliquid hasn't published a dedicated ledger-event subtype for outcome settlement, so today the reliable detection pattern is derived from the primitives that *are* exposed:

- The **last fill** on a HIP-4 market closes at price `0` or `1`.
- Followed by a **USDH ledger delta** on every position-holder's account corresponding to their settled PnL.

```typescript
function isSettlementFill(fill) {
  return fill.price === 1 || fill.price === 0;
}
```

Combine this with periodic **`clearinghouseState`** snapshots if you need to reconcile post-settlement balances.

## Patterns

### Live probability tape

Subscribe to `ohlcvCandlesForPair` at `ONE_MINUTE` interval. Render each candle as `close * 100 %` to drive a Polymarket-style probability sparkline.

### Outcome leaderboards

Subscribe to a curated wallet list with `walletTxs`, filter `HypercoreFillTransaction` events whose `coin` matches a HIP-4 symbol, and aggregate notional (`price * size`) per wallet per market. Surface the largest open positions on each outcome.

### Settlement-PnL feed

For each position-holder on a market, capture the USDH ledger delta in the resolution window. Rank by realised PnL to produce a "biggest winners / losers on this outcome" feed every time a market resolves.

### Cross-market cohort stream

Subscribe to every active HIP-4 symbol in a single `ohlcvCandlesForPair` request. One connection, many markets - lets you build a full HIP-4 dashboard without sharding.

### "New outcomes" discovery

Once permissionless builder deployment opens, new outcomes appear in `outcomeMeta` the moment they're registered. Poll `outcomeMeta` on a short cadence and diff the `outcome` IDs against the previous snapshot; subscribe to OHLCV for any new entry. The candle stream picks up the opening auction the instant a price prints.

## Reference

- [HIP-4: Outcome markets (Hyperliquid official spec)](https://hyperliquid.gitbook.io/hyperliquid-docs/hyperliquid-improvement-proposals-hips/hip-4-outcome-markets)
- **`outcomeMeta` Info API reference** - request and response schema.
- `HypercoreFillTransaction` - full type reference.
- OHLCV Pairs Stream / OHLCV Tokens Stream
- Wallet Activity Stream
- **HIP-3 markets recipe** - identical address syntax, useful for builder-deployer prefixes.

## On the roadmap

- Parsed `description` fields on `outcomeMeta` (class, underlying, expiry, targetPrice, period) returned alongside the raw string.
- Multi-outcome (non-binary) market support, tracking the upstream HIP-4 rollout.

---

The public Hyperliquid `/info` API surfaces raw building blocks; you write the parser. **Liquidations** are buried inside fills as a thin stub, and **vault, staking, and delegation** activity arrives as untyped ledger updates you have to classify yourself.

GoldRush ships every one of these pre-decoded and typed.

## What's pre-decoded

### Liquidations

Inline with the fill that triggered them, with full context:

| Field | Description |
|---|---|
| `method` | `Market` or `Backstop`. |
| `liquidated_user` | The wallet whose position was liquidated. |
| `market_price` | Mark price at the moment of liquidation. |
| `liquidated_positions[]` | Every position closed by the liquidation (coin + size). |
| `account_value` | Account value at the time of liquidation. |
| `leverage_type` | Cross or isolated. |

### 20+ ledger event subtypes

| Subtype | Description |
|---|---|
| `LedgerLiquidation` | Standalone liquidation ledger event with full position list. |
| `LedgerVaultDeposit` | Deposit into a vault. |
| `LedgerVaultWithdraw` | Withdrawal request from a vault, with commission and basis. |
| `LedgerVaultLeaderCommission` | Commission earned by a vault leader. |
| `LedgerVaultDistribution` | Distribution from a vault to depositors. |
| `LedgerVaultCreate` | New vault creation event. |
| `LedgerCStakingTransfer` | Hyperliquid staking deposit/withdrawal. |
| `LedgerBorrowLend` | Borrow or lend operation. |
| `LedgerRewardsClaim` | Validator or program reward claim. |
| `LedgerDeposit`, `LedgerWithdraw` | Bridge in/out. |
| `LedgerInternalTransfer` | Sub-account transfer. |
| `LedgerSpotTransfer` | Spot token transfer with USDC value. |
| `LedgerSubAccountTransfer` | Sub-account funds movement. |
| `LedgerSend` | Cross-DEX send (with `source_dex` and `destination_dex`). |
| `LedgerAccountClassTransfer` | Account-class movement (perp/spot). |
| `LedgerAccountActivationGas` | Activation gas charged on first deposit. |
| `LedgerSpotGenesis` | Spot token genesis allocation. |
| `LedgerDeployGasAuction` | HIP-3 market deployment gas auction. |
| `LedgerPerpDexClassTransfer` | Transfer between HIP-3 perp DEXes and core perp. |

See `HypercoreLedgerEvent` for the full type with all fields.

### Funding, deposits, withdrawals, delegations

Each gets its own typed event:

- `HypercoreFundingEvent` - funding rate payment with coin, rate, and amount.
- `HypercoreDepositEvent` - cross-chain deposit into HyperCore.
- `HypercoreWithdrawalEvent` - finalized cross-chain withdrawal.
- `HypercoreDelegationEvent` - staking delegation or undelegation with validator address.

## Subscribe

Pull liquidations, fills, and ledger events for a wallet (or many) in one stream:

```typescript
import { GoldRushClient } from "@covalenthq/client-sdk";

const client = new GoldRushClient(process.env.GOLDRUSH_API_KEY);

const SUBSCRIPTION_QUERY = `
  subscription {
    walletTxs(
      wallet_addresses: ["0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00"]
      chain_name: HYPERCORE_MAINNET
    ) {
      tx_hash
      block_signed_at
      decoded_details {
        ... on HypercoreFillTransaction {
          coin side price size closed_pnl
          liquidation {
            method
            liquidated_user
            market_price
          }
        }
        ... on HypercoreLedgerEvent {
          ledger_type
          time
          delta {
            ... on LedgerLiquidation {
              account_value
              leverage_type
              liquidated_ntl_pos
              liquidated_positions { coin szi }
            }
            ... on LedgerVaultDeposit { vault user usdc }
            ... on LedgerVaultWithdraw {
              vault user requested_usd commission basis closing_cost
            }
            ... on LedgerVaultLeaderCommission { vault usdc }
            ... on LedgerVaultDistribution { vault usdc }
            ... on LedgerCStakingTransfer { token amount is_deposit }
            ... on LedgerBorrowLend { token amount interest_amount operation }
            ... on LedgerRewardsClaim { amount }
          }
        }
      }
    }
  }
`;

client.StreamingService.rawQuery(
  SUBSCRIPTION_QUERY,
  {},
  {
    next: (data) => console.log(JSON.stringify(data, null, 2)),
    error: (err) => console.error(err),
  }
);
```

## Patterns

### Live liquidation tape

Filter the stream on `HypercoreFillTransaction` where `liquidation` is non-null. Display each liquidation in a chronological feed with the user, mark price, method, and total position value.

### "X just got liquidated for $Y" notifications

Push every non-null `liquidation` to a notification channel. Use `account_value` to compute the dollar size and `liquidated_positions[]` to list the markets.

### Position-risk warnings

Combine **`clearinghouseState`** (read `liquidationPx`, `marginUsed`, `accountValue`) with live `LedgerLiquidation` events for similar wallets to flag at-risk positions before they liquidate.

### Vault leaderboards

Aggregate `LedgerVaultLeaderCommission` and `LedgerVaultDistribution` events per vault address. Surface top-performing vaults by commission earned or distribution payout.

### Staking and rewards tabs

Subscribe to `LedgerCStakingTransfer`, `HypercoreDelegationEvent`, and `LedgerRewardsClaim` for a user. Display delegation history, current stake, and rewards earned.

### Borrow/lend position trackers

Filter on `LedgerBorrowLend` for `operation: "borrow" | "repay" | "open" | "close"`. Display per-token borrow positions with cumulative interest.

## Historical depth

Every fill, funding payment, and ledger event is retained back to HyperCore block **606,858,021** (2025-05-25T14:32:53Z).

## Reference

- `HypercoreFillTransaction`
- `HypercoreLedgerEvent`
- `HypercoreFundingEvent`
- `HypercoreDepositEvent`
- `HypercoreWithdrawalEvent`
- `HypercoreDelegationEvent`
- Decoded Events Guide - every type, every subtype.