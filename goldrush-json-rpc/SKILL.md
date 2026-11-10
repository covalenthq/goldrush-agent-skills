---
name: goldrush-json-rpc
description: "GoldRush JSON-RPC: multi-chain EVM and Solana JSON-RPC endpoints. An analytics-driven router scores every (provider, chain, endpoint) triple by success rate, latency, error class, and cost, and dispatches each call to whichever upstream is currently winning that route. Use this skill when the user needs raw JSON-RPC access on EVM chains (eth_*, net_*, web3_*, debug_*, trace_*) or Solana/SVM (getAccountInfo, getBalance, getProgramAccounts, getMultipleAccounts, getTransaction, sendTransaction, simulateTransaction, getSignaturesForAddress, getTokenAccountsByOwner, getLatestBlockhash, getSlot, getBlock, and WebSocket subscriptions accountSubscribe / logsSubscribe / programSubscribe / signatureSubscribe), is building a wallet/dApp/indexer/simulator, mentions edge RPC, archive node access, Geth or Erigon style traces, Solana RPC, lamports, commitment levels, versioned transactions, or wants to migrate from Infura/Alchemy/Ankr/Helius/Triton/QuickNode. Endpoint at rpc.goldrushdata.com - pay-per-call from GoldRush credits, full archive depth, EVM debug_* and trace_* namespaces, Solana HTTP + WebSocket, sub-100ms p50 latency, 99.9% production SLA. Authentication via Authorization: Bearer <GOLDRUSH_API_KEY> header (same key as other GoldRush products). If the user wants structured/decoded data (token balances, NFT metadata, USD pricing) use goldrush-foundational-api instead. If the user is building an autonomous agent that can pay per request without an API key, use goldrush-x402 instead."
---

# GoldRush JSON-RPC

Multi-chain JSON-RPC service backed by an analytics-driven router that scores every `(provider, chain, endpoint)` triple by success rate, p50/p95 latency, error class, and cost, and dispatches each call to whichever upstream is currently winning that route.

- **Endpoint**: `https://rpc.goldrushdata.com/v1/{chain}` (HTTP); `wss://rpc.goldrushdata.com/v1/{chain}` (Solana subscriptions)
- **Pricing**: pay-per-call from your GoldRush credit balance
- **EVM namespaces**: `eth_*`, `net_*`, `web3_*`, `debug_*`, `trace_*`
- **Solana**: full account/block/transaction/token/slot/network/inflation method set + WebSocket subscriptions
- **Depth**: full archive (per-chain coverage varies for `debug_*`/`trace_*`)
- **SLA**: 99.9% monthly uptime for production accounts

The same GoldRush API key works across all GoldRush products. Authentication is via `Authorization: Bearer <key>` HTTP header, so keys never appear in URLs.

## Header-based auth pattern

```http
POST /eth-mainnet HTTP/1.1
Host: rpc.goldrushdata.com
Authorization: Bearer <GOLDRUSH_API_KEY>
Content-Type: application/json

{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}
```

For libraries: pass headers via the standard custom-fetch / custom-headers transport.

```typescript
// ethers v6
const url = "https://rpc.goldrushdata.com/v1/eth-mainnet";
const fetchReq = new ethers.FetchRequest(url);
fetchReq.setHeader("Authorization", `Bearer ${process.env.GOLDRUSH_API_KEY}`);
const provider = new ethers.JsonRpcProvider(fetchReq);

// viem
const client = createPublicClient({
  transport: http("https://rpc.goldrushdata.com/v1/eth-mainnet", {
    fetchOptions: { headers: { Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}` } },
  }),
});

// web3.js
new Web3(new Web3.providers.HttpProvider(
  "https://rpc.goldrushdata.com/v1/eth-mainnet",
  { headers: [{ name: "Authorization", value: `Bearer ${process.env.GOLDRUSH_API_KEY}` }] }
));

// web3.py
Web3(Web3.HTTPProvider(
  "https://rpc.goldrushdata.com/v1/eth-mainnet",
  request_kwargs={"headers": {"Authorization": f"Bearer {GOLDRUSH_API_KEY}"}},
))
```

## Launch chains

| Slug | Chain | Chain ID |
|------|-------|---------:|
| `eth-mainnet` | Ethereum | 1 |
| `matic-mainnet` | Polygon | 137 |
| `bsc-mainnet` | BNB Smart Chain | 56 |
| `arbitrum-mainnet` | Arbitrum | 42161 |
| `base-mainnet` | Base | 8453 |
| `hyperevm-mainnet` | HyperEVM | 999 |
| `megaeth-mainnet` | MegaETH | 4326 |
| `monad-mainnet` | Monad | 143 |
| `tempo-mainnet` | Tempo | 4217 |
| `solana-mainnet` | Solana | n/a (SVM) |

Solana uses the Solana JSON-RPC method set (not `eth_*`), over HTTP and over WebSocket (`wss://rpc.goldrushdata.com/v1/solana-mainnet`) for subscriptions. With `@solana/kit`: `createSolanaRpcFromTransport(createDefaultRpcTransport({ url, headers: { Authorization: \`Bearer ${key}\` } }))`. With `@solana/web3.js`: `new Connection(url, { httpHeaders: { Authorization: \`Bearer ${key}\` } })`.

## Product decision matrix

| Need | Use |
|------|-----|
| Raw `eth_call`, `eth_getLogs`, `eth_sendRawTransaction` | **JSON-RPC** |
| `debug_traceTransaction`, `trace_block`, archive history | **JSON-RPC** |
| Token balances, NFT metadata, USD pricing, decoded events | **goldrush-foundational-api** (REST) |
| Autonomous agent without an API key | **goldrush-x402** (pay-per-call) |

## Cross-reference

JSON-RPC is the **lowest-level** GoldRush product. For most application-level needs (wallet UIs, dashboards, agents), one of the higher-level products is a better fit. JSON-RPC is the right choice when you need primitives, i.e. when the response of a `Foundational API` call would already be one round-trip too many.

## Reference Files

| File | When to read |
|------|-------------|
| [overview.md](references/overview.md) | Need the full product overview, pricing details, or quickstart code |
| [methods.md](references/methods.md) | Need the full EVM method catalog, per-method parameters/returns, or the `debug_*`/`trace_*` per-chain support matrix |
| [methods-solana.md](references/methods-solana.md) | Need the Solana (SVM) method catalog, per-method parameters/returns, commitment/encoding semantics, or the WebSocket subscription methods |
| [quickstart.md](references/quickstart.md) | Need per-library setup boilerplate (ethers, viem, web3.js, web3.py for EVM; @solana/kit, @solana/web3.js, solana-py for Solana) or the authentication header reference |
