# GoldRush JSON-RPC Overview

## Quick Reference

| Item | Value |
|------|-------|
| **Endpoint** | `https://rpc.goldrushdata.com/v1/{chain}` |
| **Authentication** | `Authorization: Bearer <GOLDRUSH_API_KEY>` (same key as Foundational/x402) |
| **EVM methods** | `eth_*`, `net_*`, `web3_*`, `debug_*`, `trace_*` |
| **Solana methods** | account/block/transaction/token/slot/network/inflation reads + WebSocket subscriptions |
| **Launch chains** | Ethereum, Polygon, BNB, Arbitrum, Base, HyperEVM, MegaETH, Monad, Tempo, Solana |
| **Archive depth** | full archive |
| **Pricing** | pay-per-call from GoldRush credit balance |
| **SLA** | 99.9% monthly uptime for production accounts |
| **Compatibility** | EVM: viem, ethers, web3.js, web3.py. Solana: @solana/kit, @solana/web3.js, solana-py. All via custom-headers transport. |

## Decision matrix

Use **JSON-RPC** when you need raw, untyped, opcode-level access for wallets, indexers, simulators, or anything that calls an EVM node directly.

Use **Foundational API** (REST) when you need decoded, typed, multi-chain reads such as token balances, NFT metadata, USD pricing, and transaction histories.

Use **Hyperliquid** for Hyperliquid-specific perp/spot account, market, and L2 book data.

Use **x402** when an autonomous agent needs blockchain data without an API key.

---

GoldRush JSON-RPC gives you raw, uniform JSON-RPC access to every chain GoldRush supports: EVM chains and Solana. On EVM chains it is drop-in compatible with `viem`, `ethers`, `web3.js`, and `web3.py`, with archive depth, `debug_*`, and `trace_*`. On Solana it speaks the full Solana JSON-RPC and WebSocket subscription protocol, drop-in compatible with `@solana/kit`, `@solana/web3.js`, and `solana-py`.

> **Note:** GoldRush JSON-RPC uses the **same API key** as your other GoldRush products. No new account, no second dashboard.

## What is JSON-RPC?

JSON-RPC is the standard remote-procedure-call protocol that blockchain nodes expose. A client sends a JSON request naming a method (e.g. `eth_getBalance`, `eth_call`, `getAccountInfo`) with its parameters, and the node returns a JSON result. An **RPC endpoint** is the URL you send these requests to, and an **RPC node** is the server (an Ethereum, EVM, or Solana node) that answers them. Wallets, indexers, and dapps talk to chains almost entirely through JSON-RPC.

Running your own node to serve JSON-RPC is operationally heavy, so most teams use a hosted RPC endpoint instead. GoldRush JSON-RPC is one such endpoint, with multi-provider failover and archive depth, described next.

## What is GoldRush JSON-RPC?

A JSON-RPC interface in front of a smart router that fronts multiple independent upstream providers. GoldRush continuously collects analytics per `(provider, chain, method)` triple, including success rate, p50/p95 latency, error class, and cost. Each incoming call is routed to the provider that currently scores best on the cost/performance frontier for that chain and method. Failed providers are demoted automatically and re-probed on a backoff.

```
                       ╔═ GoldRush Edge ════╗
                       ║                    ║░            ╔═════════════════╗
╔══════════╗           ║   ╔══════════════╗ ║░            ║ Best upstream   ║░
║ Your App ║░ ──API──▶ ║   ║ Smart Router ║ ║░ ──route──▶ ║ provider for    ║░
╚══════════╝░          ║   ╚══════════════╝ ║░            ║ (chain, method) ║░
 ░░░░░░░░░░░░          ║                    ║░            ╚═════════════════╝░
                       ╚════════════════════╝░             ░░░░░░░░░░░░░░░░░░░
                        ░░░░░░░░░░░░░░░░░░░░░░
```

The result: lower p99 latency than any single provider, no single-vendor dependency, and a uniform error surface across chains and node software.

## What you get

- Pay-per-call from your GoldRush credits
- Archive depth (full historical state)
- `debug_*` and `trace_*` namespaces
- Sub-100ms p50 latency from regional edge POPs
- 99.9% production SLA
- Suited for explorers, indexers, wallets, and production apps

## What's supported

- **10 mainnet networks at launch**: Ethereum, Polygon, BNB Smart Chain, Arbitrum, Base, HyperEVM, MegaETH, Monad, Tempo, and Solana
- **EVM methods** across the `eth_*`, `net_*`, `web3_*`, `debug_*`, and `trace_*` namespaces
- **Solana methods**: the full account, block, transaction, token, slot, network, and inflation method set, plus WebSocket subscriptions (`accountSubscribe`, `logsSubscribe`, `programSubscribe`, `signatureSubscribe`, …)
- **Drop-in compatibility** with `viem`, `ethers`, `web3.js`, `web3.py` (EVM) and `@solana/kit`, `@solana/web3.js`, `solana-py` (Solana), plus raw `fetch` and `curl`
- **Header-based authentication** so your API key never appears in URLs, server logs, or copy-pasted endpoints

See **supported chains** for the full chain list. Each chain page enumerates its methods by category in the sidebar.

## JSON-RPC vs Foundational API

**JSON-RPC:** Raw, untyped, opcode-level access. You compose calls. Best for: building wallets, indexers, simulators, and anything that needs the lowest level of node access.

**Foundational API:** Decoded, typed, multi-chain REST endpoints (token balances, NFT metadata, USD pricing, transaction histories). Best for: dashboards, agents, anything that consumes already-enriched data.

The two products use the same API key. Use them together: JSON-RPC for primitives, Foundational API for the heavy lifting.

## Next steps

### Quickstart

Make your first call in under a minute.

### Authentication

How to attach your API key to requests.

### Supported chains

Which networks are live.

### Migrating from another provider

Side-by-side diffs against Infura, Alchemy, and Ankr.

---

The **Edge tier** is the production endpoint for GoldRush JSON-RPC. It runs from regional edge POPs in front of an analytics-driven multi-provider router, with archive depth, the `debug_*` and `trace_*` namespaces, and an SLA.

## Endpoint

```
https://rpc.goldrushdata.com/v1/{chain}
```

See **Authentication** for header setup.

## What you get

| Feature | Edge |
|---------|------|
| `eth_*`, `net_*`, `web3_*` methods | ✅ |
| `debug_*` namespace | ✅ |
| `trace_*` namespace | ✅ |
| Archive depth (full historical state) | ✅ |
| Sub-100ms p50 latency | ✅ |
| 99.9% uptime SLA | ✅ |
| Rate limit | Account-scoped, configurable |
| Multi-provider failover | ✅ |

## How requests are routed

```
                          ╔═ Edge POP (closest) ════════════════════════════╗
                          ║                                                 ║░            ╔══════════╗
╔══════════╗              ║   ╔══════╗    ╔═══════╗    ╔══════════════════╗ ║░            ║ Upstream ║░
║ Your App ║░ ──HTTP/2──▶ ║   ║ Auth ║ ─▶ ║ Cache ║ ─▶ ║ Analytics Router ║ ║░ ──route──▶ ║ nodes    ║░
╚══════════╝░             ║   ╚══════╝    ╚═══════╝    ╚══════════════════╝ ║░            ╚══════════╝░
 ░░░░░░░░░░░░             ║                                                 ║░             ░░░░░░░░░░░░
                          ╚═════════════════════════════════════════════════╝░
                           ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
```

The Edge layer:

1. **Authenticates** the request, so invalid keys never hit the upstream.
2. **Caches** safe-to-cache reads (e.g. `eth_getBlockByNumber` for finalized blocks) at the edge.
3. **Routes** the call to whichever upstream provider currently scores highest on cost and performance for that specific `(chain, method)` route. Scores are continuously updated from rolling-window success rate, latency, error class, and cost analytics.
4. **Re-routes on failure** to the next-best provider, and feeds the failure back into the score so the routing table self-corrects in seconds.

The result: lower p99 latency than any single provider, and no single-vendor dependency.

## Archive depth

Edge serves historical state and traces back to the chain's earliest available archive block. Depth varies by chain. See **debug and trace** for the per-chain matrix.

## SLA and rate limits

- **Uptime SLA**: 99.9% per calendar month
- **Rate limit**: configurable per account; defaults to 1,000 RPS
- **Burst**: 2× the configured RPS for up to 60 seconds

Need a higher limit? Contact your GoldRush account manager.

### debug_* and trace_*

Method list and per-chain availability.

### Failover and SLA

How the Edge layer handles upstream failures.

### Pricing

Per-method credit rates.

### Migration

Side-by-side diffs from other providers.

---

GoldRush JSON-RPC is pay-per-call from your GoldRush credit balance. The same credits work across every GoldRush product.

## Rates

Each method is priced in **credits per call**.

| Tier | Rate | Methods |
|------|-----:|---------|
| **Standard** | **0.01 credits** | All `eth_*`, `net_*`, and `web3_*` methods. |
| **Trace** | **0.015 credits** | Debug and trace methods (see below). |

### Trace-tier methods

The following methods are charged at **0.015 credits per call** because they replay execution against archive state:

- `debug_traceTransaction`
- `debug_traceCall`
- `debug_traceBlockByNumber`
- `debug_traceBlockByHash`
- `trace_block`
- `trace_transaction`
- `trace_filter`
- `trace_call`
- `trace_callMany`
- `trace_rawTransaction`
- `trace_replayBlockTransactions`
- `trace_replayTransaction`
- `trace_get`

## Solana rates

GoldRush routes Solana through a multi-provider backend (an RPC aggregator that fronts dRPC and others), which classifies every method as **light** or **heavy**. We mirror that split, so two tiers cover every Solana method:

| Tier | Rate | Methods |
|------|-----:|---------|
| **Light** | **0.01 credits** | Single-object reads and writes, and all subscriptions: `getAccountInfo`, `getBalance`, `getSlot`, `getBlockHeight`, `getLatestBlockhash`, `getTransaction`, `sendTransaction`, `simulateTransaction`, `getSignatureStatuses`, `getHealth`, `getVersion`, `getEpochInfo`, `getTokenAccountBalance`, `getTokenSupply`, and the WebSocket subscriptions (`accountSubscribe`, `logsSubscribe`, `signatureSubscribe`, …), billed per delivered notification. |
| **Heavy** | **0.05 credits** | Unbounded account/program scans, block bodies, and signature/range history: `getProgramAccounts`, `getBlock`, `getBlocks`, `getBlocksWithLimit`, `getBlockProduction`, `getMultipleAccounts`, `getLargestAccounts`, `getVoteAccounts`, `getSignaturesForAddress`, `getTokenAccountsByOwner`, `getTokenAccountsByDelegate`, `getTokenLargestAccounts`, `getInflationReward`, `getSupply`, `getLeaderSchedule`, `getRecentPerformanceSamples` (plus the deprecated `getConfirmed*` equivalents). |

Opening or closing a subscription is free; you are billed only for notifications delivered.

> **Note:** `getProgramAccounts` and `programSubscribe` can return large result sets. Always scope them with `filters` (`dataSize`, `memcmp`) and `dataSlice` to keep both responses and your credit usage small.

## How to estimate cost

A typical wallet that polls `eth_blockNumber` once per second and `eth_getBalance` once per minute uses:

```
eth_blockNumber:  0.01 × 60 × 60 × 24 = 864.0 / day
eth_getBalance:   0.01 × 60 × 24      =  14.4 / day
                                       ────────
                                       ~880 credits / day
```

A block-explorer indexer that calls `debug_traceBlockByNumber` once per finalized block on Ethereum (~12s blocks):

```
debug_traceBlockByNumber: 0.015 × 7,200 blocks/day = 108 credits / day
```

## What counts as a call

- **Each request** in a JSON-RPC batch counts separately. A batch of 10 `eth_getBalance` calls costs 0.1 credits.
- **Failed requests** caused by user error (`-32600`, `-32602`) are not charged. Failures inside the upstream node (e.g. revert in `eth_call`) **are** charged, since the node did the work.
- **Cached responses** are charged at the standard rate. Edge caching reduces *latency*, not cost.

### Endpoint details

Production endpoint with archive, debug, trace.

### Supported chains

Each chain's method catalog, grouped by category.