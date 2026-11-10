# LLM Integration Guide

# GoldRush API - LLM Integration Guide (Condensed)

**Purpose:** Quick reference for LLMs and AI agents to correctly use the GoldRush API, focusing on error prevention and critical validation rules.

---

## Quick Reference

| Item | Value |
|------|-------|
| **Base URL** | `https://api.covalenthq.com/v1` |
| **Authentication** | Bearer token in `Authorization` header |
| **API Key** | Sign up at goldrush.dev/platform (starts with `cqt_` or `ckey_`) |
| **TypeScript SDK** | `@covalenthq/client-sdk` |
| **Response Format** | JSON |
| **Protocol** | HTTPS only (HTTP will fail) |

**Rate Limits:**
- Free 14 day trial: 25,000 API credits/month, 4 requests/second, no overages
- Vibe Coding tier: $10/month for 10,000 included API credits, 4 requests/second, overages at $0.001/credit
- Professional: $250/month for 300,000 included API credits, 50 requests/second, overages at $0.00077/credit
- x402 (Pay-Per-Request): No subscription required, 100 requests/minute per wallet, pay with stablecoins on Base

---

## Chain Names (CRITICAL)

Chain names use the format: `{network}-{environment}`. These are **case-sensitive** and must match exactly.

### Supported Chain Names Table

| Common Name | Chain Name (API Parameter) | Chain ID | Support Level |
|-------------|---------------------------|----------|---------------|
| Base | `base-mainnet` | 8453 | foundational |
| BNB Smart Chain (BSC) | `bsc-mainnet` | 56 | foundational |
| Ethereum | `eth-mainnet` | 1 | foundational |
| Gnosis | `gnosis-mainnet` | 100 | foundational |
| Optimism | `optimism-mainnet` | 10 | foundational |
| Polygon | `matic-mainnet` | 137 | foundational |
| ADI Chain | `adi-mainnet` | 36900 | frontier |
| ApeChain | `apechain-mainnet` | 33139 | frontier |
| Arbitrum | `arbitrum-mainnet` | 42161 | frontier |
| Arbitrum Nova | `arbitrum-nova-mainnet` | 42170 | frontier |
| Arc | `arc-mainnet` | 5042 | frontier |
| Avalanche C-Chain | `avalanche-mainnet` | 43114 | frontier |
| Axie/Ronin | `axie-mainnet` | 2020 | frontier |
| Berachain | `berachain-mainnet` | 80094 | frontier |
| Bitcoin | `btc-mainnet` | 20090103 | frontier |
| HyperCore | `hypercore-mainnet` | na | frontier |
| HyperEVM | `hyperevm-mainnet` | 999 | frontier |
| Ink | `ink-mainnet` | 57073 | frontier |
| Linea | `linea-mainnet` | 59144 | frontier |
| Mantle | `mantle-mainnet` | 5000 | frontier |
| MegaETH | `megaeth-mainnet` | 4326 | frontier |
| Monad | `monad-mainnet` | 143 | frontier |
| Oasis Sapphire | `oasis-sapphire-mainnet` | 23294 | frontier |
| Plasma | `plasma-mainnet` | 9745 | frontier |
| Scroll | `scroll-mainnet` | 534352 | frontier |
| Sei | `sei-mainnet` | 1329 | frontier |
| Solana | `solana-mainnet` | 1399811149 | frontier |
| Sonic | `sonic-mainnet` | 146 | frontier |
| Taiko | `taiko-mainnet` | 167000 | frontier |
| Unichain | `unichain-mainnet` | 130 | frontier |
| Viction | `viction-mainnet` | 88 | frontier |
| World Chain | `world-mainnet` | 480 | frontier |
| zkSync Era | `zksync-mainnet` | 324 | frontier |
| Blast | `blast-mainnet` | 81457 | community |
| Canto | `canto-mainnet` | 7700 | community |
| Celo | `celo-mainnet` | 42220 | community |
| Cronos zkEVM | `cronos-zkevm-mainnet` | 388 | community |
| Fantom | `fantom-mainnet` | 250 | community |
| Moonbeam | `moonbeam-mainnet` | 1284 | community |
| Moonriver | `moonbeam-moonriver` | 1285 | community |
| Oasis | `emerald-paratime-mainnet` | 42262 | community |
| opBNB | `bnb-opbnb-mainnet` | 204 | community |
| ZetaChain | `zetachain-mainnet` | 7000 | community |
| Cronos | `cronos-mainnet` | 25 | archived |
| Harmony | `harmony-mainnet` | 1666600000 | archived |

**Note:** Always use the "Chain Name (API Parameter)" value in API calls. Using common names will result in errors.


**Chain Support Levels:**

Chains are categorized into four support levels. See [Chain Documentation](#chain-documentation) for complete definitions.

- **Foundational** (6 chains) - Full feature parity including historical balances, token holders at any block, and DEX spot prices
- **Frontier** (28 chains) - Core features with expanding coverage; includes all non-EVM chains
- **Community** (14 chains) - Growing integration with all core onchain data
- **Archived** (5 chains) - Limited data availability, no live data

---

## Parameter Naming Convention

GoldRush uses different naming conventions depending on the context:

| Context | Convention | Example |
|---------|-----------|----------|
| TypeScript SDK | camelCase | `chainName`, `walletAddress` |
| REST API Path Parameters | camelCase | `{chainName}`, `{walletAddress}` |
| REST API Query Parameters | kebab-case | `quote-currency`, `block-height` |
| JSON Response Fields | snake_case | `chain_id`, `updated_at` |

### Parameter Mapping (SDK ↔ REST API)

| SDK Parameter | REST Query Parameter |
|--------------|---------------------|
| chainName | N/A (path parameter) |
| walletAddress | N/A (path parameter) |
| quoteCurrency | quote-currency |
| blockHeight | block-height |
| noLogs | no-logs |
| withInternal | with-internal |
| withState | with-state |
| withInputData | with-input-data |

---

## Input Validation Rules

### Ethereum Addresses

- **Format:** `0x` followed by 40 hexadecimal characters
- **Regex:** `^0x[a-fA-F0-9]{40}$`
- **Case:** Insensitive (both `0xabc...` and `0xABC...` are valid)
- **Special Values:** Also accepts ENS names (e.g., `vitalik.eth`), RNS, Lens Handles, Unstoppable Domains

**Examples:**
- ✅ Valid: `0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045`
- ✅ Valid: `vitalik.eth`
- ❌ Invalid: `d8dA6BF26964aF9D7eEd9e03E53415D37aA96045` (missing 0x)
- ❌ Invalid: `0xd8dA6BF` (too short)

### Chain Names

- **Format:** Exact match from supported chains table (case-sensitive)

**Examples:**
- ✅ Valid: `eth-mainnet`
- ❌ Invalid: `ethereum` (use `eth-mainnet`)
- ❌ Invalid: `Eth-Mainnet` (case-sensitive)
- ❌ Invalid: `eth_mainnet` (use hyphen, not underscore)

### Block Heights

- **Type:** Integer ≥ 0
- **Special Value:** `"latest"` for current block
- **Maximum:** Current chain height (varies by chain)

**Examples:**
- ✅ Valid: `12345678`
- ✅ Valid: `latest`
- ❌ Invalid: `-1`

### Quote Currency

- **Type:** String (case-insensitive)
- **Supported Values:** `USD`, `CAD`, `EUR`, `SGD`, `INR`, `JPY`, `VND`, `CNY`, `KRW`, `RUB`, `TRY`, `NGN`, `ARS`, `AUD`, `CHF`, `GBP`
- **Default:** `USD`

### Pagination

- **Page Numbers:** 0-indexed (first page is `0`)
- **Page Size:** 100 items per page (default, not configurable for most endpoints)
- **End Detection:**
  - If returned page has < 100 items, it's the last page
  - Check `has_more` field in response (where available)
  - Use `links.next` for next page URL (where available)

---

## Understanding Balance Fields

```json
{
  "contract_decimals": 18,
  "balance": "1500000000000000000",
  "quote_rate": 2500.50,
  "quote": 3750.75,
  "pretty_quote": "$3,750.75"
}
```

**Field Explanations:**
- `balance`: Raw token amount as string (to handle large numbers/BigInt). This is **NOT** the human-readable value.
- `contract_decimals`: Number of decimal places for this token
- `quote_rate`: Current price of 1 token in quote currency (e.g., USD)
- `quote`: Total value of this token holding in quote currency
- `pretty_quote`: Formatted currency string for display

**To get human-readable balance:**

```javascript
const humanReadable = parseFloat(balance) / Math.pow(10, contract_decimals);
// Example: "1500000000000000000" / 10^18 = 1.5 tokens
```

---

## Understanding Transaction Fields

```json
{
  "successful": true,
  "value": "0",
  "gas_spent": 21000,
  "gas_price": 50000000000,
  "fees_paid": "1050000000000000",
  "gas_quote": 2.75,
  "gas_quote_rate": 2500.00
}
```

**Field Explanations:**
- `successful`: Boolean indicating if transaction succeeded
- `value`: Amount of native token transferred (as string, in wei for EVM chains)
- `gas_spent`: Actual gas units consumed
- `gas_price`: Gas price in wei (for EVM chains)
- `fees_paid`: Total fee in wei (`gas_spent × gas_price`)
- `gas_quote`: Total fee in quote currency (e.g., USD)
- `gas_quote_rate`: Native token price used for conversion

---

## Error Responses

All error responses follow this schema:

```json
{
  "data": null,
  "error": true,
  "error_message": "Human-readable error description",
  "error_code": 401
}
```

### Common Error Codes

| HTTP Status | error_code | Meaning | Solution |
|------------|-----------|---------|----------|
| 401 | 401 | Invalid or missing API key | Check Authorization header format: `Bearer <GOLDRUSH_API_KEY>` |
| 400 | 400 | Invalid request parameters | Verify chain name, address format, or other parameters |
| 404 | 404 | Resource not found | Check if chain name is valid or address has activity |
| 429 | 429 | Rate limit exceeded | Reduce request frequency or upgrade plan |
| 500 | 500 | Internal server error | Retry request, contact support if persists |

---

## Best Practices for LLMs

### 1. Always Validate Chain Names

```typescript
const VALID_CHAINS = [
  "eth-mainnet", "matic-mainnet", "base-mainnet",
  "arbitrum-mainnet", "optimism-mainnet", "bsc-mainnet"
];

function isValidChain(chainName: string): boolean {
  return VALID_CHAINS.includes(chainName);
}
```

### 2. Handle BigInt Balance Values Correctly

```typescript
// ❌ WRONG
const balance = parseInt(item.balance); // Will overflow for large values

// ✅ CORRECT
const balance = parseFloat(item.balance) / Math.pow(10, item.contract_decimals);
```

### 3. Implement Pagination Properly

```typescript
// ✅ CORRECT
let page = 0;
let allItems = [];
let hasMore = true;

while (hasMore) {
  const resp = await fetchPage(page);
  allItems.push(...resp.items);
  hasMore = resp.items.length === 100; // Full page = more data likely exists
  page++;
}
```

### 4. Use Appropriate Error Handling

```typescript
const resp = await client.BalanceService.getTokenBalancesForWalletAddress(
  chainName,
  address
);

if (resp.error) {
  // Handle error - don't try to access resp.data
  console.error(resp.error_message);
  return;
}

// Safe to access resp.data here
const balances = resp.data.items;
```

---

## Common Mistakes to Avoid

### ❌ Using Wrong Chain Name Format

```typescript
// WRONG
const chain = "ethereum";
const chain = "polygon";

// CORRECT
const chain = "eth-mainnet";
const chain = "matic-mainnet";
```

### ❌ Treating Balance as Number

```typescript
// WRONG
const balance = parseInt(item.balance); // Overflow!

// CORRECT
const balance = parseFloat(item.balance) / Math.pow(10, item.contract_decimals);
```

### ❌ Forgetting to Check Error Response

```typescript
// WRONG
const resp = await client.getSomething();
const data = resp.data.items; // May crash if error

// CORRECT
const resp = await client.getSomething();
if (!resp.error) {
  const data = resp.data.items;
}
```

### ❌ Not Handling Pagination

```typescript
// WRONG - only gets first 100 transactions
const resp = await client.getTransactions(chain, address, { page: 0 });

// CORRECT - gets all transactions
let page = 0;
let allTxs = [];
while (true) {
  const resp = await client.getTransactions(chain, address, { page });
  if (resp.error || resp.data.items.length === 0) break;
  allTxs.push(...resp.data.items);
  if (resp.data.items.length < 100) break;
  page++;
}
```

### ❌ Missing Bearer Prefix in Authorization

```bash
# WRONG
curl -H "Authorization: <GOLDRUSH_API_KEY>"

# CORRECT
curl -H "Authorization: Bearer <GOLDRUSH_API_KEY>"
```

### ❌ Using HTTP Instead of HTTPS

```bash
# WRONG
http://api.covalenthq.com/v1/...

# CORRECT
https://api.covalenthq.com/v1/...
```

---

## Frequently Asked Questions (LLM-Specific)

### Q: How do I convert balance to human-readable format?

**A:** Divide the balance string by 10^contract_decimals:

```typescript
const humanReadable = parseFloat(balance) / Math.pow(10, contract_decimals);
// Example:
// balance = "1500000000000000000"
// contract_decimals = 18
// humanReadable = 1.5 tokens
```

### Q: What's the difference between `quote` and `quote_rate`?

**A:**
- `quote_rate`: Price of 1 token in quote currency (e.g., $2,500.50 per ETH)
- `quote`: Total value of the balance in quote currency (balance × quote_rate)

### Q: How do I know which chains support internal transactions?

**A:** Only Foundational chains support tracing features (`with-internal`, `with-state`, `with-input-data`). Currently, only `eth-mainnet` fully supports all tracing features. Check the endpoint documentation for "Foundational Chains" support.

### Q: How do I handle ENS names?

**A:** Just pass the ENS name directly as the wallet address. GoldRush automatically resolves it:

```typescript
const resp = await client.BalanceService.getTokenBalancesForWalletAddress(
  "eth-mainnet",
  "vitalik.eth" // Automatically resolved
);
```

### Q: What's the difference between `balances_v2` and `balances_native`?

**A:**
- `balances_v2`: Returns ALL tokens (native + ERC20 + NFTs)
- `balances_native`: Returns ONLY the native token (ETH, MATIC, etc.)

Use `balances_native` for lightweight queries when you only need the native token balance.

### Q: How do I filter out spam tokens?

**A:** Use the `no-spam` query parameter:

```bash
curl "https://api.covalenthq.com/v1/eth-mainnet/address/0x.../balances_v2/?no-spam=true"
```

### Q: When should I use the SDK vs direct REST calls?

**A:**
- **Use SDK:** TypeScript/JavaScript projects, automatic pagination, type safety
- **Use REST:** Python, Go, or any other language; curl testing; maximum flexibility

### Q: How often does data update?

**A:**
- Real-time endpoints: 30 seconds or 2 blocks (whichever is faster)
- Historical data: Indexed from genesis block
- NFT metadata: Cached, use `with-uncached=true` to force refresh

---

## Quick Reference: Endpoint URL Patterns

| Data Type | URL Pattern |
|-----------|------------|
| Token Balances | `/v1/{chain}/address/{address}/balances_v2/` |
| Native Balance Only | `/v1/{chain}/address/{address}/balances_native/` |
| Transaction History | `/v1/{chain}/address/{address}/transactions_v3/page/{page}/` |
| Single Transaction | `/v1/{chain}/transaction_v2/{txHash}/` |
| NFT Metadata | `/v1/{chain}/tokens/{contract}/nft_metadata/{tokenId}/` |
| Token Holders | `/v1/{chain}/tokens/{contract}/token_holders_v2/` |
| Cross-Chain Activity | `/v1/address/{address}/activity/` |
| Security Approvals | `/v1/{chain}/approvals/{address}/` |
| ERC20 Transfers | `/v1/{chain}/address/{address}/transfers_v2/` |
| Historical Prices | `/v1/pricing/historical_by_address/{chain}/{contract}/` |

---

## Additional Resources

- **Full API Documentation:** https://goldrush.dev/docs/
- **API Reference:** https://goldrush.dev/docs/api-reference/
- **Guides & Tutorials:** https://goldrush.dev/guides/
- **Supported Chains:** https://goldrush.dev/docs/chains/overview
- **Status Page:** https://status.goldrush.dev/
- **Get API Key:** https://goldrush.dev/platform
- **Discord Community:** https://discord.gg/8ZWgu2pWY4
- **GitHub:** https://github.com/covalenthq

---

## System Prompt Suggestion for AI Agents

When building AI agents that use GoldRush API, include this in your system prompt:

```
You have access to the GoldRush API for blockchain data. Key points:

1. Chain names use format like "eth-mainnet", "matic-mainnet", "base-mainnet" - never use common names like "ethereum" or "polygon"
2. Balance fields are strings representing large numbers. Divide by 10^contract_decimals to get human-readable values
3. All requests require "Authorization: Bearer <GOLDRUSH_API_KEY>" header
4. Pagination returns 100 items per page. If result has 100 items, more pages likely exist
5. Base URL: https://api.covalenthq.com/v1
6. Always check resp.error before accessing resp.data
7. Ethereum addresses: 0x + 40 hex chars, or ENS names
8. For detailed integration guidance, refer to the LLM Integration Guide
```

---

**Last Updated:** January 2025
**API Version:** v1
**Documentation Version:** 2.0 (LLM-Optimized Condensed)


---

# Error Handling & Troubleshooting

The GoldRush Foundational API (REST) returns structured errors when something goes wrong. This page is the single reference for understanding error codes, handling rate limits, implementing retries, and debugging common issues.

> **Note:** **Failed requests are free.** No API credits are deducted for any response outside the `2xx` range, whatever the cause. A `429`, a `501`, a `556` and a `500` all cost you nothing, so a retry is never a billing risk.

Retries do still count against your **rate limit**, which is why the guidance below is about backing off correctly rather than about cost.

## Standard and GoldRush-specific codes

Not every code this API returns is a registered HTTP status code. It is worth knowing which is which, because off-the-shelf HTTP clients, proxies and monitoring tools only understand the registered ones and will usually flatten the rest into a generic "5xx".

  
**Standard HTTP codes:** `400` `401` `402` `403` `404` `406` `410` `416` `429` `500` `501` `503` `504` `507`

    Registered status codes. Several carry a GoldRush-specific meaning, noted in the table below.

  
**GoldRush-specific codes:** `452` `551` `552` `554` `556` `557` `558` `561` `562` `563` `565` `567` `570`

    **Not registered HTTP status codes.** Specific to the GoldRush API. Match on the exact number, not on the `5xx` class.

## The error response body

Every error the API itself generates uses the same envelope as a successful response, with `data` set to `null`:

```json
{
  "data": null,
  "error": true,
  "error_message": "This chain does not currently support flag: with-state.",
  "error_code": 501
}
```

Three things to note:

- `error_code` is a **JSON number**, not a string. Compare it with `501`, not `"501"`.
- `error_code` always equals the HTTP status code, so you can branch on either one.
- `error_message` carries the specific reason. Two requests can share a status code and mean entirely different things, so log the message as well as the code.

The one exception is a bare `500`, which is returned with an empty body. Treat a response that has a `5xx` status and no parseable JSON as a `500`.

> **Warning:** **A request with no `Authorization` header at all is rejected by the edge proxy, not by the API**, and returns an HTML body rather than JSON:

```html
401 Authorization Required ...
```

A missing or malformed key sent *with* the request returns the normal JSON `401`. If your client parses every response body as JSON, guard this one case, or check the `Content-Type` header before parsing.

## Standard HTTP status codes

These are all registered HTTP status codes. Where our meaning is narrower or more specific than the generic one, it is spelled out here.

| Code | Name | What it means at GoldRush |
| :--- | :--- | :--- |
| `400` | Bad Request | Malformed parameters, invalid address format |
| `401` | Unauthorized | Missing or incorrect API key |
| `402` | Payment Required | Three distinct causes, told apart by `error_message`: credit limit exceeded, a paywalled feature on your tier, or a paused subscription on a production key |
| `403` | Forbidden | API key is valid but not authorized for the resource |
| `404` | Not Found | The endpoint path does not exist, or the specific record (transaction hash, block) was not found. Also returned when a requested block height has not been reached yet on that chain |
| `406` | Not Acceptable | The request would predictably time out with these parameters, so it was not attempted. Reduce the date range or page size and retry |
| `410` | Gone | The endpoint or the chain has been sunsetted. Stop calling it and remove any scheduled jobs that do |
| `416` | Range Not Satisfiable | A query transform supplied with the request failed to parse |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | An unclassified server-side failure. Unlike every other code on this page, a `500` has **no JSON body** |
| `501` | Not Implemented | The chain or endpoint does not support what you asked for. This is the most commonly misread code we return, so it has its own section below |
| `503` | Service Unavailable | The chain is under maintenance, or a backend queue is full |
| `504` | Gateway Timeout | A database query exceeded its statement timeout. Narrow the query and retry |
| `507` | Insufficient Storage | The response was too large to buffer. Reduce `page-size` and retry |

### 501 is a capability answer, not an outage

A `501` means your request was well-formed and your key was fine, but the chain or endpoint cannot serve that particular thing. It is a stable answer rather than a transient one, so retrying it unchanged will not succeed until that support actually ships. It is returned in three situations:

- **An unsupported chain.** Note that an unrecognized chain name returns `501`, not `404`:

  ```json
  { "data": null, "error": true, "error_message": "Chain nosuchchain-mainnet not supported.", "error_code": 501 }
  ```

- **A feature flag the chain does not support.** Flags such as `with-state` and `with-input-data` are only available on chains with the underlying data. The flag is valid, the chain just cannot serve it:

  ```json
  { "data": null, "error": true, "error_message": "This chain does not currently support flag: with-state.", "error_code": 501 }
  ```

  Rather than discovering this by trial, read the capability flags on **`/v1/chains/`**, such as `is_internal_tx_supported` and `is_input_data_supported`, and skip the call when the flag is false.

- **An endpoint restricted to certain chains**, for example an EVM-only endpoint called on a non-EVM chain.

> **Note:** The gate runs before the identifier is looked up, so a transaction hash that does not exist returns `404` on a chain that supports the flag and `501` on a chain that does not. That makes a throwaway hash a cheap way to test chain support.

## GoldRush-specific status codes

> **Warning:** The codes in this section are **not registered HTTP status codes**. They are specific to the GoldRush API.

They exist so that different backend conditions stay distinguishable instead of collapsing into one generic `500`, which is what makes a useful retry policy possible at all. The tradeoff is that generic HTTP tooling does not know them: most clients, proxies and dashboards will report them only as "a 5xx". **Match on the exact number**, and if you alert on error classes, give at least `556` and `565` their own treatment.

All of these carry the normal JSON error body described above.

| Code | `error_message` | What happened | What to do |
| :--- | :--- | :--- | :--- |
| `452` | Please un-stealth your User-Agent | Your client sent a browser `User-Agent` but is not a browser | **Do not retry.** Set an honest `User-Agent` that identifies your application, then retry once |
| `551` | Worker thread failed to respond in time | A worker did not finish within its deadline | **Retry with exponential backoff.** If it repeats on the same parameters, the request is probably too broad: narrow the date range or page size |
| `552` | Connection to web3 provider failed | We could not reach the chain's node for a live call | **Retry with exponential backoff**, up to 3 to 5 attempts |
| `554` | Timed out while waiting to acquire a database connection | All pooled database connections were busy | **Retry with exponential backoff.** Transient and usually clears within seconds |
| `556` | Too many concurrent database requests | Deliberate load shedding. The query was refused on purpose to protect a saturated backend | **Retry with exponential backoff, and lower your concurrency.** Do not retry tightly, see the note below |
| `557` | Database replica cancelled query to retain sync with primary | A read replica cancelled the query to stay in sync | **Retry once, immediately.** This one is usually gone on the next attempt |
| `558` | Database unexpectedly closed connection | The connection dropped mid-query | **Retry with exponential backoff**, up to 3 attempts |
| `561` | Could not acquire NFT metadata scraper from pool | The NFT metadata scraping pool was exhausted | **Retry with exponential backoff.** Consider spacing out bulk NFT metadata jobs |
| `562` | Failed to connect to upstream third-party service | A third-party data provider we depend on was unreachable | **Retry with exponential backoff.** Recovery depends on a third party, so allow a longer ceiling, 30 to 60 seconds |
| `563` | Connection to upstream third-party service timed out | A third-party data provider did not answer in time | **Retry with exponential backoff**, same longer ceiling as `562` |
| `565` | Unable to find referenced `` in database; DB has fallen behind web3 source | The record exists on chain but our indexed copy has not caught up. Most often a transaction requested within seconds of being mined | **Wait at least 10 seconds, then retry once.** See the note below, do not retry immediately |
| `567` | Chain dataset is currently unavailable | The dataset for that chain is temporarily not readable | **Retry after 30 seconds or more.** If it persists past a few minutes, treat that chain as down and fail over |
| `570` | Contract execution error during web3 call | The contract call reverted on chain | **Do not retry.** This is a correct answer about the contract, not a failure on our side. Check your call arguments |

> **Tip:** **`556` is the one to watch.** It means the request was refused on purpose while the backend was under load, not that anything is broken. A burst of `556` is the correct signal to back off; clients that retry it aggressively make the condition worse and last longer.

> **Note:** **`565` is short-lived by design.** The response is cached for only 10 seconds, because the usual cause is that indexing is a few seconds behind the chain tip. Waiting 10 to 15 seconds and retrying once resolves most occurrences. If a `565` for the same record persists for minutes, raise it on the [support page](https://goldrush.dev/platform/support/).

## What to do with every code

Sorted by what the right response actually is, rather than by number.

### Retry with exponential backoff

`429`, `500`, `503`, `504`, `551`, `552`, `554`, `556`, `557`, `558`, `561`, `562`, `563`, `565`, `567`

These are transient. The same request may well succeed later. Use the loop in [Retry Strategies](#retry-strategies) below, with these adjustments:

- **`557`:** retry once immediately before backing off. It usually clears on the next attempt.
- **`565`:** wait at least 10 seconds before the first retry.
- **`562` and `563`:** recovery depends on a third party, so allow a ceiling of 30 to 60 seconds rather than a few seconds.
- **`429`:** back off until your request rate is under the limit for your plan. More attempts will not help.

### Change the request, then retry

`406`, `507`

The request as sent will keep failing, but a narrower one will succeed. Reduce `page-size`, shorten the date range, or split the query, then send it again.

### Fix something, then retry once

`400` fix the parameters. `401` fix the API key. `402` check `error_message` to see which of the three causes applies, then raise your spending limit, upgrade your plan, or resume your subscription. `452` send an honest `User-Agent`.

### Do not retry

`403`, `410`, `416`, `501`, `570`

These are stable answers, not failures in progress. Retrying returns exactly the same thing. `410` means the endpoint or chain is gone for good, so remove the call and any scheduled job that makes it. `501` means the capability does not exist on that chain, so check `/v1/chains/` and skip it. `570` means the contract reverted, which is a real answer about the contract.

> **Note:** **None of this costs credits.** Error responses are not billed, so the cost of a retry is only the rate limit slot it consumes and the latency it adds. Optimize your retry policy for recovery time and for not amplifying an incident, not for spend.

## Rate Limits

The Foundational API enforces rate limits based on your plan tier:

| Plan | Rate Limit | API Credits |
| :--- | :--- | :--- |
| 14-day Free Trial | 4 RPS | 25,000 |
| Vibe Coding ($10/mo) | 4 RPS | 10,000 |
| Professional ($250/mo) | 50 RPS | 300,000 |
| Inner Circle | Custom (up to 100+ RPS) | Custom SLA |

Rate limits are enforced **per API key and IP address**. When you exceed your limit, you'll receive a `429 Too Many Requests` response. Back off and retry using the strategies below.

## Retry Strategies

### Exponential Backoff with Jitter

Retry on the transient set only, and use exponential backoff with random jitter so that many clients recovering from the same incident do not retry in lockstep.

A retry loop written against `429`, `500` and `503` alone will miss most of what the API actually returns under load, because the specific codes above are used in preference to a generic `500`. Include them explicitly.

```typescript TypeScript
// Transient: a later attempt may succeed with the same request.
const RETRYABLE = new Set([
  429, 500, 503, 504,
  551, 552, 554, 556, 557, 558, 561, 562, 563, 565, 567,
]);

async function fetchWithRetry(
  url: string,
  options: RequestInit,
  maxRetries = 5
): Promise {
  for (let attempt = 0; attempt  setTimeout(r, baseDelay + jitter));
      continue;
    }

    throw new Error(`Request failed: ${response.status}`);
  }

  throw new Error("Max retries exceeded");
}
```

```python Python
import time
import random
import requests

# Transient: a later attempt may succeed with the same request.
RETRYABLE = {
    429, 500, 503, 504,
    551, 552, 554, 556, 557, 558, 561, 562, 563, 565, 567,
}

def fetch_with_retry(url, headers, max_retries=5):
    for attempt in range(max_retries):
        response = requests.get(url, headers=headers)

        if response.ok:
            return response

        if response.status_code in RETRYABLE:
            # 565 means indexing is a few seconds behind the chain tip,
            # so give it a floor of 10s rather than retrying immediately.
            base_delay = 10 if response.status_code == 565 else (2 ** attempt)
            jitter = random.uniform(0, 1)
            time.sleep(base_delay + jitter)
            continue

        response.raise_for_status()

    raise Exception("Max retries exceeded")
```

> **Warning:** Never put `403`, `410`, `416`, `501` or `570` in a backoff loop. They are stable answers about the request, the chain or the contract, so every attempt returns the same thing while still consuming a rate limit slot. See [What to do with every code](#what-to-do-with-every-code) for the codes that are worth one retry after you fix something.

### SDK Built-in Retries

The [GoldRush TypeScript Client SDK](https://www.npmjs.com/package/@covalenthq/client-sdk) handles retries and rate limiting automatically - no manual retry logic needed when using the SDK.

## Debugging Tips

  
### Verify your API key format

GoldRush API keys follow the pattern `cqt_wF...` or `cqt_rQ...` (26 base58 characters after the prefix). Double-check for trailing whitespace or truncation.

  
### Check supported chains

An unsupported or misspelled chain returns `501`, not `404`, with `"Chain  not supported."` in `error_message`. A `404` on a chain-scoped path usually means the record was not found, not that the chain is wrong. See **Supported Chains** for the full list.

  
### Inspect the full error body

Don't rely on the HTTP status code alone. The JSON response body contains an `error_message` field with specific details about what went wrong. This matters most for `402` and `501`, where one status code covers several unrelated causes that only the message distinguishes.

  
### Test with curl

Isolate issues from your application code by testing directly:

    ```bash
    # Foundational API
    curl -X GET https://api.covalenthq.com/v1/eth-mainnet/address/demo.eth/balances_v2/ \
         -u : \
         -H 'Content-Type: application/json'
    ```

  
### Monitor credit usage

Track your API credit consumption on the [GoldRush Platform dashboard](https://goldrush.dev/platform) to avoid unexpected `402` errors.

  
### Contact support for persistent server-side errors

If you're consistently hitting `500`, `503`, or any of the GoldRush-specific `5xx` codes after backing off, open a ticket on the [GoldRush support page](https://goldrush.dev/platform/support/) with your API key prefix, the endpoint, the exact `error_code` and `error_message`, and timestamps of the failures.

    The support form asks for the endpoint and chain directly, so filing there routes the issue faster than describing it in free text.

    Include the exact code. `556` and `565` in particular point at very different causes from a generic `500`, and quoting the number shortens the diagnosis considerably.

## Quick Reference

  
### Foundational API Auth

API key setup, authentication methods, and SDK usage.

### FAQ

Common questions about plans, rate limits, and features.

### Supported Chains

Full list of supported blockchains and endpoints.

---

# Frequently Asked Questions

## General Questions

### What is the GoldRush API?

GoldRush offers the most comprehensive Blockchain Data API suite for developers, analysts, and enterprises.

### What can I do with the GoldRush API?

The GoldRush API provides fast, accurate, and developer-friendly access to the essential onchain data for building DeFi dashboards, wallets, trading bots, AI Agents, tax and compliance platforms. 

### Do I need API keys to use GoldRush?
Yes. The credential you need depends on the product:

- **API key** (read-only) - covers the Foundational API, CLI, and x402.

It's available on the [GoldRush platform](https://goldrush.dev/platform) once you sign up.

### If a client asks how to verify that GoldRush API is real-time or low-latency, how can we demonstrate or prove that?

You can demonstrate real-time or low-latency capabilities through:
* Timestamp validation: Pull `/v1/{chain_id}/block_v2/latest/` and compare the block timestamp with the current time (should be sub-second to a few seconds behind depending on chain).
* Latency benchmarks: Use tools like curl or Postman to measure API response time.

### Besides the common 401, 402, and 429 error codes, are there any other error responses we should be aware of?

Yes. Additional error codes include:

* `400 Bad Request` – Invalid parameters or malformed request.
* `402 Payment Required` – Alloted credits exceeded and need to enable Flex Credits or upgrade subscription tier.
* `403 Forbidden` – API key is valid but not authorized for the resource.
* `404 Not Found` – Endpoint or data not available (e.g. unsupported chain).
* `500 Internal Server Error` – Unexpected failure on GoldRush's side.
* `503 Service Unavailable` – Maintenance or backend issue.

Each error includes a descriptive JSON body for debugging. For a complete guide to error codes, retry strategies, and debugging tips, see **Error Handling & Troubleshooting**.

## Foundational API Questions

### What is the rate limit for API calls?

The GoldRush Foundational API enforces rate limits based on the user's plan:
* 14-day Free Trial: 4 requests per second (RPS), 25,000 API credits.
* Vibe Coding Plan ($10/mo): 4 RPS, 10,000 API credits.
* Professional Plan ($250/mo): 50 RPS, 300,000 API credits.
* Inner Circle: Custom limits, typically up to 100 RPS or higher, based on SLAs.

Rate limits are enforced per API key and IP, and requests exceeding limits receive a `429 Too Many Requests` error. For a complete guide to error codes, retry strategies, and debugging tips, see **Error Handling & Troubleshooting**.

### Which plan is right for me?

**Vibe Coding Plan ($10/mo)** is built for:
* Solo founders and indie hackers shipping fast
* Hackathon teams and weekend projects
* AI-native builders using Cursor, Windsurf, or Claude
* Prototyping and validating ideas before scaling

**Professional Plan ($250/mo)** is built for:
* Teams building production applications
* Apps that need higher rate limits (50 RPS)
* Projects requiring priority support
* Companies with compliance or reliability requirements

You can start with Vibe Coding and upgrade to Professional as your project scales. For a full breakdown of plans, the free trial, and credit-based [GoldRush API pricing](https://goldrush.dev/pricing/), see the pricing page.

### Can I upgrade from Vibe Coding to Professional?

Yes. You can upgrade at any time from the [GoldRush platform](https://goldrush.dev/platform). Your API key stays the same, so no code changes are needed.

### Does GoldRush support Hyperliquid?

Yes. GoldRush supports Hyperliquid's native chain (HyperCore) with zero rate limits. You can stream real-time fills, liquidations, funding rates, vault actions, delegations, deposits, withdrawals, and OHLCV pricing data for all Hyperliquid markets - including data not available through the public Hyperliquid API.

GoldRush runs dedicated Hyperliquid nodes in Tokyo with a private backbone for low-latency data ingestion. See the **HyperCore chain page** for full details and code examples.

### What are Redstone Bolt price feeds?

Redstone Bolt provides ultra-low-latency CEX price data for 9 major tokens on MegaETH, including BTC, ETH, SOL, BNB, XRP, ADA, DOGE, USDT, and USDC. Prices are updated every **2.4 ms** (~400 updates/sec), sourced from Binance, Coinbase, OKX, Bitget, and Kraken via Bolt nodes co-located with MegaETH sequencer infrastructure. Bolt-powered feeds use the `REDSTONE-` prefix (e.g. `REDSTONE-BTC`, `REDSTONE-ETH`).

---

## Not finding answers?

- ****Error Handling & Troubleshooting**** — Debug issues and retry strategies
- ****What is GoldRush**** — Understand the core platform
- ****GoldRush SDKs & CLI**** — Get started with code
- ****Powered by GoldRush**** — See real-world examples