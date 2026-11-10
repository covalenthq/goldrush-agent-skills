# GoldRush Hyperliquid API Overview

## Quick Reference

| Item | Value |
|------|-------|
| **Info API URL** | `https://hypercore.goldrushdata.com/info` |
| **Method** | `POST` |
| **Authentication** | `Authorization: Bearer <GOLDRUSH_API_KEY>` (same key as the Foundational API) |
| **Rate Limit** | None |
| **Wire compatibility** | Byte-for-byte with `POST api.hyperliquid.xyz/info` for implemented types |
| **Networks** | Mainnet only |
| **HyperCore historical depth** | Block 606,858,021 onward (2025-05-25T14:32:53Z) |
| **HyperEVM historical depth** | Genesis |

## Surfaces

| Surface | What it provides |
|---------|------------------|
| Info API | Drop-in replacement for `POST /info` (58 current types, including `activeAssetData`, `outcomeMeta`, and GoldRush-native `batchClearinghouseState`/`batchSpotClearinghouseState`; unsupported types return a JSON error) |
| WebSocket API | Drop-in replacement for `wss://api.hyperliquid.xyz/ws` at `wss://hypercore.goldrushdata.com/ws?key=<KEY>`. No 1000-subscription-per-IP cap. Channels: `l2Book` (aggregated, optional `coin`), `l2BookDiff` (GoldRush-native L2 snapshot + per-block diffs, single coin / list / wildcard), `l4Book` (GoldRush-native order-level snapshot + per-block diffs) |
| Real-time GraphQL streams | Real-time `walletTxs`, `ohlcvCandlesForPair`, `ohlcvCandlesForToken` |
| Foundational API | HyperEVM (chain `999`) token balances, transfers, NFTs, gas |

---

GoldRush is the **complete, low-latency data layer for Hyperliquid** - the indexer and data provider that aggregates everything you need to build on Hyperliquid - HyperCore, HIP-3, HIP-4, and HyperEVM - under one API key.

> **Note:** **Hyperliquid - HyperCore historical coverage starts at block `606,858,021` (`2025-05-25T14:32:53Z`).**

Every data type (fill, order, trade, funding, and ledger event) from that block onward is retained and queryable.


### Drop-in Hyperliquid API replacement

Drop-in replacement for both the public `/info` REST API and `/ws` WebSocket. Change one URL to remove rate limits and unlock more data. Hosted at `hypercore.goldrushdata.com`.

### Real-time Streaming

Wallet firehose, OHLCV for every HIP-3 and HIP-4 market the moment it goes live, and pre-decoded liquidations and vault events.

### HyperEVM coverage

Token balances, transfers, approvals, NFTs, and gas for HyperEVM - same shape as every other EVM chain on GoldRush.

## Drop-in coverage: REST + WebSocket

GoldRush replaces **both** of Hyperliquid's public surfaces with a single host - `hypercore.goldrushdata.com`. Same request bodies, same response shapes, same subscription payloads as the public API. Swap the URL, add the GoldRush API key, and your existing clients work unchanged - with no rate limits and no per-IP subscription caps.

> **Note:** **Auth differs between REST and WebSocket.** REST takes an `Authorization: Bearer ` header. The WebSocket takes a `?key=` query parameter (most WebSocket clients can't send headers during the upgrade handshake). Same key for both.


### REST /info API

Drop-in replacement for `POST https://api.hyperliquid.xyz/info`. 17 wire-compatible `type` values plus GoldRush-native batch endpoints (`batchClearinghouseState`, `batchSpotClearinghouseState`) for up to 50 wallets per call.

### WebSocket API

Drop-in replacement for `wss://api.hyperliquid.xyz/ws` with no 1000-subscription-per-IP cap. Subscribe to `l2Book` (aggregated snapshots - omit `coin` to stream **every asset** on one subscription), the GoldRush-native `l2BookDiff` (snapshot plus per-block diffs of changed `{px, sz, n}` levels - accepts a single coin, a list, or wildcard), or the GoldRush-native `l4Book` (per-order snapshot plus per-block diffs with `user`, `oid`, `cloid`, and trigger metadata exposed).

## Hyperliquid API limitations addressed by GoldRush

The public Hyperliquid `/info` API is generous, but it has hard limits that most production apps run into:

- **1200 weight/min/IP** rate limits per address.
- **1000 WebSocket subscriptions per IP** - not enough to track every active trader.
- **WebSocket subscription filters are required** - every subscription must specify an asset (e.g. `coin` on `l2Book`), forcing per-asset fan-out that burns through the 1000-subscription cap. GoldRush makes these filters **optional** so a single wildcard subscription streams every asset.
- **No batch address endpoints** - account-state calls are single-wallet only; GoldRush adds `batchClearinghouseState` and `batchSpotClearinghouseState` for up to 50 wallets per request.
- **`userFills` capped at ~10,000 rows** - active traders blow through that in weeks.
- **Liquidations buried inside fills** as a thin stub; vault, staking, and delegation data arrives untyped.
- **HIP-3 and HIP-4 discovery is manual** - `candleSnapshot` is poll-based and effectively limited to mainstream markets.
- **No HyperEVM concept at all** - DEXes, NFT mints, and lending live on chain `999` and the `/info` API doesn't see them.

GoldRush closes every one of these gaps. See **GoldRush vs Hyperliquid public API** for the full breakdown.

## What's included

## Infrastructure

GoldRush runs its own Hyperliquid indexing infrastructure - purpose-built to be the fastest, most reliable Hyperliquid data provider for production apps and quant desks:

- **Dedicated Hyperliquid nodes in Tokyo** - co-located with Hyperliquid's validator infrastructure for low-latency reads.
- **Private backbone** for high-throughput data ingestion.
- **No rate limits** - bypass the public `/info` and WebSocket constraints entirely.
- **Full historical backfill** - every fill, funding payment, and ledger event back to HyperCore block `606,858,021` (`2025-05-25T14:32:53Z`). HyperEVM coverage goes back to genesis.

## Quickstart

Here are three "first 5 minutes" quickstarts. Pick whichever maps to what you are building.


### Upgrade from the public Hyperliquid API

Already using `api.hyperliquid.xyz/info`? Change the URL and add one header.

### Watch wallets

Subscribe to thousands of HyperCore wallets in one connection.

### Fan out across many wallets

Fetch account state for up to 50 wallets in one call.

## All Hyperliquid endpoints

Every Hyperliquid endpoint reference page, grouped by surface. The **Info API** and **WebSocket API** overviews cover each `type` in context; the full index below links straight to every endpoint's request/response schema.

---

Pick the path that matches what you're building. All three use the same GoldRush API key.

## Prerequisites

A GoldRush API key. Sign up at [goldrush.dev/platform](https://goldrush.dev/platform/auth/register/), or apply to the Early Builders Program for free credits.

### Vibe Coders

$10/mo - Built for solo builders and AI-native workflows.

### Teams

$250/mo - Production-grade with priority support.

### Early Builders

Pre-revenue? Up to 1M credits over 12 months, free.

---

## 1. Drop-in Info API

If your code already calls `POST https://api.hyperliquid.xyz/info`, swap the URL to `https://hypercore.goldrushdata.com/info` and add an `Authorization: Bearer` header. The request body and response shape stay byte-for-byte identical.

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer " \
  -H "Content-Type: application/json" \
  -d '{"type": "metaAndAssetCtxs"}'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "clearinghouseState",
    user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    dex: "",
  }),
});

const data = await response.json();
console.log(data);
```

```python Python
import os
import requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={
        "Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}",
        "Content-Type": "application/json",
    },
    json={
        "type": "frontendOpenOrders",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "dex": "",
    },
)

print(response.json())
```

That's it. No rate limits, faster reads, and the response is byte-equal to Hyperliquid (modulo live-value drift). See the full migration guide for SDK overrides and behavioral notes:

### Info API Migration Guide

Side-by-side examples in JS, Python, and cURL - including how to point existing SDKs at GoldRush.

---

## 2. Stream wallet activity

Subscribe to one or many HyperCore wallets in real time over WebSocket. Pre-decoded events include fills with liquidation context, funding payments, vault actions, and 20+ ledger subtypes.

```typescript GoldRush SDK
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
          coin
          side
          price
          size
          closed_pnl
          liquidation { method liquidated_user market_price }
        }
        ... on HypercoreFundingEvent { coin funding_rate funding_amount }
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

```bash Install
npm install @covalenthq/client-sdk
```

The `walletTxs` subscription has zero rate limits and scales to thousands of concurrent wallet subscriptions per connection. See **Wallet firehose** for the full pattern.

---

## 3. Fan out across many wallets

Need account state for many wallets at once? `batchClearinghouseState` and `batchSpotClearinghouseState` accept **1 to 50 wallets per call** and fan them out in parallel against our private node. There is no equivalent on the public Hyperliquid `/info` API.

Each slot in the response is either the raw upstream object for that wallet (success) or a thin error envelope (`{error, user, message}`) when an individual wallet fails. The HTTP status stays `200 OK` even on partial failure - always check for the `error` key on each slot.

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "batchClearinghouseState",
    users: [
      "0xb0a55f13d22f66e6d495ac98113841b2326e9540",
      "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
      "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    ],
  }),
});

const slots = await response.json();

for (const [i, slot] of slots.entries()) {
  if ("error" in slot) {
    console.warn(`wallet ${slot.user} failed: ${slot.message}`);
    continue;
  }
  console.log(`wallet ${i}: ${slot.withdrawable} USD withdrawable`);
}
```

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "batchSpotClearinghouseState",
    "users": [
      "0xb0a55f13d22f66e6d495ac98113841b2326e9540",
      "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc"
    ]
  }'
```

Duplicates in `users` are removed (case-insensitive); input order is preserved for the survivors.

For batches larger than 50, issue multiple calls. Use cases: portfolio dashboards, multi-wallet PnL aggregators, fleet-level liquidation risk monitoring, treasury balance reconciliation. Full reference: **`batchClearinghouseState`**, **`batchSpotClearinghouseState`**.

---

## What's next


### WebSocket API

Drop-in `wss://` replacement with `l2Book`, `l2BookDiff`, and the GoldRush-native `l4Book` order-level stream. No per-IP subscription cap.

### HIP-3 markets

Real-time OHLCV for every builder-deployed perp market - equities, commodities, niche assets.

### Liquidations & vault events

Pre-decoded `LedgerLiquidation`, `LedgerVaultDeposit`, `LedgerVaultWithdraw`, and 17 more subtypes.

### Live analytics

HIP-3 Market Screener, Liquidation Cascade Map, Market Health Score.