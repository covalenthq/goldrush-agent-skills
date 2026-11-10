# Hyperliquid Info API

## Available Types (today)

| Type | Body | Returns |
|------|------|---------|
| `metaAndAssetCtxs` | `{type:"metaAndAssetCtxs",dex:""}` | Tuple [meta, assetCtxs[]] - perp universe + per-asset mark, funding, OI, day volume |
| `meta` | `{type:"meta",dex:""}` | Perp universe metadata only - size decimals, max leverage, margin tiers (no live context) |
| `spotMetaAndAssetCtxs` | `{type:"spotMetaAndAssetCtxs"}` | Tuple [spotMeta, assetCtxs[]] - spot universe + per-pair mark, mid, day volume |
| `spotMeta` | `{type:"spotMeta"}` | Spot universe metadata only - pairs and the full token registry (no live context) |
| `outcomeMeta` | `{type:"outcomeMeta"}` | Active HIP-4 outcome universe with outcome IDs, descriptions, and Yes/No side specs |
| `l2Book` | `{type:"l2Book",coin:"BTC"}` | Aggregated Level-2 order book snapshot for one coin (bid/ask {px, sz, n} levels) |
| `candleSnapshot` | `{type:"candleSnapshot",req:{coin:"BTC",interval:"1h",startTime:...}}` | Historical OHLCV candles for a coin and interval over a time window |
| `fundingHistory` | `{type:"fundingHistory",coin:"BTC",startTime:...}` | Market-wide historical funding rates and premiums for a coin over a time window |
| `clearinghouseState` | `{type:"clearinghouseState",user:"0x...",dex:""}` | Perp account state |
| `spotClearinghouseState` | `{type:"spotClearinghouseState",user:"0x...",dex:""}` | Spot balances |
| `frontendOpenOrders` | `{type:"frontendOpenOrders",user:"0x...",dex:""}` | Open orders w/ TP/SL metadata |
| `activeAssetData` | `{type:"activeAssetData",user:"0x...",coin:"ETH"}` | Per-user, per-asset leverage, max trade sizes, available-to-trade amounts, and mark price |
| `subAccounts` | `{type:"subAccounts",user:"0x..."}` | Sub-accounts owned by a master, each with inlined perp and spot state |
| `userFills` | `{type:"userFills",user:"0x..."}` | Most recent fills for a user |
| `userFillsByTime` | `{type:"userFillsByTime",user:"0x...",startTime:...}` | Fills bounded by a time window |
| `userCompletedTrades` | `{type:"userCompletedTrades",user:"0x..."}` | Latest fully-closed round-trip trades for a wallet, newest-first (default 100, max 500), each with realized PnL, funding, fees, VWAP entry/exit. **GoldRush-native** |
| `userCompletedTradesByTime` | `{type:"userCompletedTradesByTime",user:"0x...",startTime:...}` | Fully-closed round-trip trades over a close_time window, oldest-first, with a `{close_time}_{tx_index}` keyset cursor for forward paging. **GoldRush-native** |
| `userPnlSummary` | `{type:"userPnlSummary",user:"0x..."}` | One aggregate object per wallet - net realized PnL, win/loss rate, trade count, volume, fees, funding, active days, account age, traded pairs. **GoldRush-native** |
| `userTwapSliceFills` | `{type:"userTwapSliceFills",user:"0x..."}` | Most recent TWAP slice fills tagged with parent `twapId` |
| `userFunding` | `{type:"userFunding",user:"0x...",startTime:...}` | Funding payment history with rate, applied size, USDC delta |
| `userNonFundingLedgerUpdates` | `{type:"userNonFundingLedgerUpdates",user:"0x...",startTime:...}` | Ledger events except funding - deposits, withdrawals, transfers, vault flows, liquidations |
| `userVaultEquities` | `{type:"userVaultEquities",user:"0x..."}` | Per-vault locked equity with unlock timestamps |
| `delegatorSummary` | `{type:"delegatorSummary",user:"0x..."}` | Current delegated, undelegated, pending-withdrawal HYPE totals |
| `delegatorHistory` | `{type:"delegatorHistory",user:"0x..."}` | Delegate, undelegate, deposit, and withdrawal staking events |
| `delegatorRewards` | `{type:"delegatorRewards",user:"0x..."}` | Accrued staking rewards (delegation and validator commission) |
| `allMids` | `{type:"allMids",dex:""}` | Current mid price for every actively traded coin (coin->price map; spot pairs keyed @index) |
| `perpDexLimits` | `{type:"perpDexLimits",dex:"xyz"}` | Per-DEX open-interest, position-size, and transfer limits for a HIP-3 perp DEX |
| `marginTable` | `{type:"marginTable",id:56}` | Margin-tier (leverage-bracket) table for a marginTableId |
| `maxMarketOrderNtls` | `{type:"maxMarketOrderNtls"}` | Maximum market-order notional for each leverage bucket |
| `perpsAtOpenInterestCap` | `{type:"perpsAtOpenInterestCap"}` | Perp coins currently at their open-interest cap |
| `exchangeStatus` | `{type:"exchangeStatus"}` | Current exchange operational status and server time |
| `validatorL1Votes` | `{type:"validatorL1Votes"}` | Pending validator L1 governance votes/actions |
| `spotDeployState` | `{type:"spotDeployState",user:"0x..."}` | Spot-token deployment state and gas auction for a deployer |
| `perpDeployAuctionStatus` | `{type:"perpDeployAuctionStatus"}` | Current perp-deploy Dutch-auction status |
| `liquidatable` | `{type:"liquidatable"}` | Accounts currently eligible for liquidation |
| `openOrders` | `{type:"openOrders",user:"0x...",dex:""}` | A wallet resting open orders (coin, side, limitPx, sz, oid) |
| `userRole` | `{type:"userRole",user:"0x..."}` | Account role - user, agent, vault, or subAccount (with master) |
| `userFees` | `{type:"userFees",user:"0x..."}` | Fee schedule and recent daily trading volume |
| `userRateLimit` | `{type:"userRateLimit",user:"0x..."}` | API rate-limit usage, cap, and cumulative volume |
| `userAbstraction` | `{type:"userAbstraction",user:"0x..."}` | Account-abstraction mode (disabled or unifiedAccount) |
| `extraAgents` | `{type:"extraAgents",user:"0x..."}` | Approved API-agent wallets (name, address, validUntil) |
| `userToMultiSigSigners` | `{type:"userToMultiSigSigners",user:"0x..."}` | Authorized signers and threshold for a multi-sig account (null if not multi-sig) |
| `maxBuilderFee` | `{type:"maxBuilderFee",user:"0x...",builder:"0x..."}` | Max builder fee (tenths of a bp) a user approved for a builder |
| `delegations` | `{type:"delegations",user:"0x..."}` | Active HYPE staking delegations, per validator |
| `userBorrowLendInterest` | `{type:"userBorrowLendInterest",user:"0x...",startTime:...}` | Borrow/lend interest accrual history over a time window |
| `vaultSummaries` | `{type:"vaultSummaries"}` | Summary information for every vault |
| `vaultDetails` | `{type:"vaultDetails",vaultAddress:"0x..."}` | Full detail for one vault - leader, portfolio, APR, followers |
| `leadingVaults` | `{type:"leadingVaults",user:"0x..."}` | Vaults that a user leads |
| `portfolioState` | `{type:"portfolioState",user:"0x...",dex:""}` | Perp + spot state + account-abstraction mode in one call (dex:"ALL_DEXES" for all dexes). **GoldRush-native** |
| `allPerpMetas` | `{type:"allPerpMetas"}` | Universe + margin tables for every perp DEX in one array (index 0 native, then HIP-3). **GoldRush-native** |
| `batchClearinghouseState` | `{type:"batchClearinghouseState",users:["0x...",...],dex:""}` | Array of clearinghouseState slots, 1-50 wallets. **GoldRush-native** (no upstream equivalent) |
| `batchSpotClearinghouseState` | `{type:"batchSpotClearinghouseState",users:["0x...",...]}` | Array of spotClearinghouseState slots, 1-50 wallets. **GoldRush-native** (no upstream equivalent) |

Any other `type` value returns `{"error":"unsupported_type","type":"<the type you sent>"}` with HTTP 400. Requests are not forwarded to upstream Hyperliquid.

## Migration Pattern

```typescript
// Before
fetch("https://api.hyperliquid.xyz/info", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify(body),
});

// After -same body, no rate limits
fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify(body),
});
```

---

The GoldRush Hyperliquid Info API is a **drop-in replacement** for `POST https://api.hyperliquid.xyz/info`. The request body, the response shape, and the JSON keys are byte-for-byte identical to the public Hyperliquid API. The only differences are the URL and the authentication header.

Forty-nine wire-compatible `type` values are supported today across market metadata, user state, user history, vaults, and staking - plus nine GoldRush-native types (two batched state lookups, two builder-keyed fill feeds, a portfolio composite, an all-DEX metadata fan-out, and three completed-trade / PnL analytics products) with no upstream equivalent.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## The most-requested reads

Most Hyperliquid apps start from the same REST calls - a user's **trades** and their **account state**. Over the drop-in `/info` API that is:

- **User trades (fills)** - **`userFills`** for the latest fills, or **`userFillsByTime`** for a time window (GoldRush serves these past upstream's ~10,000-fill retention limit).
- **Perp account state** - **`clearinghouseState`** for a single wallet, or **`batchClearinghouseState`** for up to 50 wallets in one request.
- **Spot balances** - **`spotClearinghouseState`**, or **`batchSpotClearinghouseState`** for many wallets at once.

Every type below is called the same way - `POST /info` with a `type` field - so these are the same requests you already make against `api.hyperliquid.xyz`, pointed at a faster, unthrottled host.

## Comparison with the public Hyperliquid API

| | Public API  | GoldRush |
|---|---|---|
| URL| `https://api.hyperliquid.xyz/info` | `https://hypercore.goldrushdata.com/info`|
| Auth | None | `Authorization: Bearer ` |
| Rate limit | 1200 weight/min/IP | None |
| Orderbook latency target | `p50`: `~280 ms` | `p50`: `"}` instead of being forwarded |

## Available types

The Info API supports the wire-compatible drop-in types below, organized by what they return. Nine GoldRush-native types (`batchClearinghouseState`, `batchSpotClearinghouseState`, `builderFills`, `builderFillsByTime`, `portfolioState`, `allPerpMetas`, `userCompletedTrades`, `userCompletedTradesByTime`, `userPnlSummary`) have no upstream Hyperliquid equivalent.

### Market metadata

| Type | Body | Returns |
|---|---|---|
| **`metaAndAssetCtxs`** | `{"type": "metaAndAssetCtxs", "dex": ""}` | Tuple `[meta, assetCtxs[]]` - perp universe + per-asset live mark price, funding, OI, day volume. |
| **`meta`** | `{"type": "meta", "dex": ""}` | Perp universe metadata only - size decimals, max leverage, margin tiers. No live context. |
| **`spotMetaAndAssetCtxs`** | `{"type": "spotMetaAndAssetCtxs"}` | Tuple `[spotMeta, assetCtxs[]]` - spot universe + per-pair live mark price, mid, day volume. |
| **`spotMeta`** | `{"type": "spotMeta"}` | Spot universe metadata only - pairs and the full token registry. No live context. |
| **`outcomeMeta`** | `{"type": "outcomeMeta"}` | Active HIP-4 outcome universe - integer outcome IDs, names, structured descriptions, and `sideSpecs` (`Yes` / `No`). |
| **`settledOutcome`** | `{"type": "settledOutcome", "outcome": 1}` | Resolution data for a settled HIP-4 outcome - the original `spec`, `settleFraction` paid to `Yes`, and `details` describing how the outcome resolved. |
| **`l2Book`** | `{"type": "l2Book", "coin": "BTC"}` | Aggregated Level-2 order book snapshot for one coin - bids and asks as `{px, sz, n}` levels. |
| **`candleSnapshot`** | `{"type": "candleSnapshot", "req": {"coin": "BTC", "interval": "1h", "startTime": …}}` | Historical OHLCV candles for a coin and interval over a time window. |
| **`fundingHistory`** | `{"type": "fundingHistory", "coin": "BTC", "startTime": …}` | Market-wide historical funding rates and premiums for a coin over a time window. |
| **`perpDexs`** | `{"type": "perpDexs"}` | List of HIP-3 builder-deployed perp DEXes (index `0` = canonical Hyperliquid; each entry has `name`, `full_name`, `deployer`, `oracle_updater`). |
| **`allPerpMetas`** | `{"type": "allPerpMetas"}` | Universe + margin tables for **every** perp DEX in one array (index `0` = native, then HIP-3 DEXes in `perpDexs` order). **GoldRush-native**. |
| **`allMids`** | `{"type": "allMids", "dex": ""}` | Current mid price for every actively traded coin, as a `coin → price` map (spot pairs keyed `@index`). |
| **`perpDexLimits`** | `{"type": "perpDexLimits", "dex": "xyz"}` | Per-DEX open-interest, position-size, and transfer limits for a HIP-3 perp DEX. |
| **`marginTable`** | `{"type": "marginTable", "id": 56}` | Margin-tier (leverage-bracket) table for a `marginTableId`. |
| **`maxMarketOrderNtls`** | `{"type": "maxMarketOrderNtls"}` | Maximum market-order notional for each leverage bucket. |
| **`perpsAtOpenInterestCap`** | `{"type": "perpsAtOpenInterestCap"}` | List of perp coins currently at their open-interest cap. |
| **`exchangeStatus`** | `{"type": "exchangeStatus"}` | Current exchange operational status and server time. |
| **`validatorL1Votes`** | `{"type": "validatorL1Votes"}` | Pending validator L1 governance votes/actions. |
| **`spotDeployState`** | `{"type": "spotDeployState", "user": "0x…"}` | Spot-token deployment state and gas auction for a deployer. |
| **`perpDeployAuctionStatus`** | `{"type": "perpDeployAuctionStatus"}` | Current perp-deploy Dutch-auction status. |
| **`liquidatable`** | `{"type": "liquidatable"}` | Accounts currently eligible for liquidation. |

### User account state

| Type | Body | Returns |
|---|---|---|
| **`clearinghouseState`** | `{"type": "clearinghouseState", "user": "0x…", "dex": ""}` | Perp account: positions, margin summary, account value, withdrawable. |
| **`spotClearinghouseState`** | `{"type": "spotClearinghouseState", "user": "0x…", "dex": ""}` | Spot balances per token, total USD value. |
| **`frontendOpenOrders`** | `{"type": "frontendOpenOrders", "user": "0x…", "dex": ""}` | Open orders + trigger metadata (TP/SL, `isPositionTpsl`, `reduceOnly`, `orderType`). |
| **`activeAssetData`** | `{"type": "activeAssetData", "user": "0x…", "coin": "ETH"}` | Per-user, per-asset trading state: leverage, directional max trade sizes, available-to-trade amounts, and mark price. |
| **`subAccounts`** | `{"type": "subAccounts", "user": "0x…"}` | List of sub-accounts owned by a master, each with its inlined perp and spot state. |
| **`webData2`** | `{"type": "webData2", "user": "0x…"}` | Composite frontend snapshot for a wallet - `clearinghouseState`, `openOrders`, perp `meta`/`assetCtxs`, `spotAssetCtxs`, TWAP and vault state in a single round-trip. |
| **`openOrders`** | `{"type": "openOrders", "user": "0x…", "dex": ""}` | A wallet's resting open orders (coin, side, `limitPx`, `sz`, `oid`). |
| **`userRole`** | `{"type": "userRole", "user": "0x…"}` | Account role - `user`, `agent`, `vault`, or `subAccount` (with its master). |
| **`userFees`** | `{"type": "userFees", "user": "0x…"}` | Fee schedule and recent daily trading volume for a wallet. |
| **`userRateLimit`** | `{"type": "userRateLimit", "user": "0x…"}` | API rate-limit usage, cap, and cumulative volume. |
| **`userAbstraction`** | `{"type": "userAbstraction", "user": "0x…"}` | Account-abstraction mode (`"disabled"` or `"unifiedAccount"`). |
| **`extraAgents`** | `{"type": "extraAgents", "user": "0x…"}` | Approved API-agent wallets, each with `name` and `validUntil`. |
| **`userToMultiSigSigners`** | `{"type": "userToMultiSigSigners", "user": "0x…"}` | Authorized signers and threshold for a multi-sig account (`null` if not multi-sig). |
| **`maxBuilderFee`** | `{"type": "maxBuilderFee", "user": "0x…", "builder": "0x…"}` | Maximum builder fee (tenths of a bp) a user has approved for a builder. |
| **`portfolioState`** | `{"type": "portfolioState", "user": "0x…", "dex": ""}` | Perp `clearinghouseState` + `spotClearinghouseState` + `userAbstraction` in one call (`dex: "ALL_DEXES"` for all DEXes). **GoldRush-native**. |

### User history

| Type | Body | Returns |
|---|---|---|
| **`userFills`** | `{"type": "userFills", "user": "0x…"}` | Most recent fills for a wallet (up to 2,000). |
| **`userFillsByTime`** | `{"type": "userFillsByTime", "user": "0x…", "startTime": …}` | Fills bounded by a time window. |
| **`userCompletedTrades`** | `{"type": "userCompletedTrades", "user": "0x…"}` | Latest fully-closed round-trip trades for a wallet, newest-first (default 100, max 500), each with realized PnL, funding, fees, and VWAP entry/exit. **GoldRush-native**. |
| **`userCompletedTradesByTime`** | `{"type": "userCompletedTradesByTime", "user": "0x…", "startTime": …}` | Fully-closed round-trip trades over a `close_time` window, oldest-first, with a `{close_time}_{tx_index}` keyset cursor for forward paging. **GoldRush-native**. |
| **`userPnlSummary`** | `{"type": "userPnlSummary", "user": "0x…"}` | One aggregate object per wallet - net realized PnL, win/loss rate, trade count, volume, fees, funding, active days, account age, and traded pairs. **GoldRush-native**. |
| **`userTwapSliceFills`** | `{"type": "userTwapSliceFills", "user": "0x…"}` | Most recent TWAP slice fills, each tagged with the parent `twapId`. |
| **`userTwapSliceFillsByTime`** | `{"type": "userTwapSliceFillsByTime", "user": "0x…", "startTime": …}` | TWAP slice fills bounded by a time window. Served from GoldRush's historical store so windows extend past upstream's 10,000-fill retention. |
| **`userFunding`** | `{"type": "userFunding", "user": "0x…", "startTime": …}` | Funding payment history with rate, applied size, and USDC delta per event. |
| **`userNonFundingLedgerUpdates`** | `{"type": "userNonFundingLedgerUpdates", "user": "0x…", "startTime": …}` | Ledger events except funding - deposits, withdrawals, transfers, vault flows, liquidations. |

### Vaults & staking

| Type | Body | Returns |
|---|---|---|
| **`userVaultEquities`** | `{"type": "userVaultEquities", "user": "0x…"}` | Per-vault locked equity with unlock timestamps. |
| **`delegatorSummary`** | `{"type": "delegatorSummary", "user": "0x…"}` | Current delegated, undelegated, and pending-withdrawal HYPE totals. |
| **`delegatorHistory`** | `{"type": "delegatorHistory", "user": "0x…"}` | Delegate, undelegate, deposit, and withdrawal staking events. |
| **`delegatorRewards`** | `{"type": "delegatorRewards", "user": "0x…"}` | Accrued staking rewards (delegation and validator commission). |
| **`delegations`** | `{"type": "delegations", "user": "0x…"}` | Active HYPE staking delegations, per validator. |
| **`userBorrowLendInterest`** | `{"type": "userBorrowLendInterest", "user": "0x…", "startTime": …}` | Borrow/lend interest accrual history over a time window. |
| **`borrowLendUserState`** | `{"type": "borrowLendUserState", "user": "0x…"}` | Current borrow and supply balance per token, plus account health and health factor. |
| **`vaultSummaries`** | `{"type": "vaultSummaries"}` | Summary information for every vault on the platform. |
| **`vaultDetails`** | `{"type": "vaultDetails", "vaultAddress": "0x…"}` | Full detail for one vault - leader, portfolio history, APR, followers. |
| **`leadingVaults`** | `{"type": "leadingVaults", "user": "0x…"}` | Vaults that a user leads. |

### Builder activity

| Type | Body | Returns |
|---|---|---|
| **`builderFills`** | `{"type": "builderFills", "builder": "0x…"}` | Most recent fills attributed to a builder address (up to 2,000). **GoldRush-native**, no upstream equivalent. |
| **`builderFillsByTime`** | `{"type": "builderFillsByTime", "builder": "0x…", "startTime": …}` | Builder-attributed fills bounded by a time window. **GoldRush-native**, no upstream equivalent. |

### GoldRush-native batch

| Type | Body | Returns |
|---|---|---|
| **`batchClearinghouseState`** | `{"type": "batchClearinghouseState", "users": ["0x…", …], "dex": ""}` | Array of `clearinghouseState` slots. **GoldRush-native**, 1 to 50 wallets per call. |
| **`batchSpotClearinghouseState`** | `{"type": "batchSpotClearinghouseState", "users": ["0x…", …]}` | Array of `spotClearinghouseState` slots. **GoldRush-native**, 1 to 50 wallets per call. |

If you send a `type` that isn't in the table above, the response body is `{"error":"unsupported_type","type":""}`. Requests are not forwarded to upstream Hyperliquid.

## How clients see it

Existing Hyperliquid SDKs work unchanged after a `baseUrl` override. See **SDK compatibility** for `nomeida/hyperliquid` (JS) and `hyperliquid-dex/hyperliquid-python-sdk` setup snippets.

## Errors

| Status | Body | Cause |
|---|---|---|
| `400` | `{"error":"invalid request"}` | Malformed body. |
| `400` | `{"error":"unsupported_type","type":""}` | The `type` field isn't one of the natively-supported types. |
| `401` | `{"error":"unauthorized"}` | Missing or invalid `Authorization` header. |
| `429` | n/a | **Not returned.** GoldRush has no per-IP rate limit on `/info` - any retry logic you carried over from `api.hyperliquid.xyz` can stay in place but won't fire. |
| `5xx` | Server error | Internal server error. |

## Networks

Mainnet only. Testnet support is deferred.

## Next


### Migration guide

Side-by-side examples - change one URL and one header.

### SDK compatibility

Drop-in setup for `nomeida/hyperliquid` and `hyperliquid-python-sdk`.

### Limits and caching

No rate limits - what to know about caching and recommended polling cadences.

### API reference

Per-endpoint request and response schemas.

---

Moving from the public Hyperliquid `/info` API to GoldRush is two changes:

1. **URL** - replace `api.hyperliquid.xyz/info` with `hypercore.goldrushdata.com/info`.
2. **Header** - add `Authorization: Bearer `.

That's it. The request body and response shape are byte-for-byte identical.

## Side-by-side

### cURL

```bash Public Hyperliquid
curl -X POST https://api.hyperliquid.xyz/info \
  -H "Content-Type: application/json" \
  -d '{
    "type": "clearinghouseState",
    "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    "dex": ""
  }'
```

```bash GoldRush
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "clearinghouseState",
    "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    "dex": ""
  }'
```

### JavaScript / TypeScript

```typescript Public Hyperliquid
const response = await fetch("https://api.hyperliquid.xyz/info", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    type: "metaAndAssetCtxs",
    dex: "",
  }),
});

const data = await response.json();
```

```typescript GoldRush
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "metaAndAssetCtxs",
    dex: "",
  }),
});

const data = await response.json();
```

### Python

```python Public Hyperliquid
import requests

response = requests.post(
    "https://api.hyperliquid.xyz/info",
    json={
        "type": "spotClearinghouseState",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "dex": "",
    },
)

print(response.json())
```

```python GoldRush
import os
import requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "spotClearinghouseState",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "dex": "",
    },
)

print(response.json())
```

## Behavioral notes

Things to be aware of when you cut over.

### Response is byte-equal, modulo live drift

For implemented types, the response body matches Hyperliquid byte-for-byte - same keys, same nesting, same value types. Numeric fields update independently on each side, so a market-price field will diverge by tens of milliseconds, but the schema is identical.

### Unsupported types return a JSON error

Types that GoldRush doesn't natively serve return `{"error":"unsupported_type","type":""}` with HTTP 400. They are not forwarded to upstream Hyperliquid. See the **Info API overview** for the current list of supported types.

### Auth errors return JSON

A missing or invalid key returns `401` with body `{"error":"unauthorized"}`. Public Hyperliquid has no auth and never returns 401.

### Existing SDKs work after a `baseUrl` override

The two most-used SDKs work unchanged:

- `nomeida/hyperliquid` (JavaScript)
- `hyperliquid-dex/hyperliquid-python-sdk` (Python)

See **SDK compatibility** for the override snippets.

## Authentication

The Info API uses your standard GoldRush API key. The same key works against the **Foundational API**. If you don't have one yet, [sign up here](https://goldrush.dev/platform/auth/register/).

Never hardcode keys in source. Use environment variables or a secrets manager.

## What you gain

- **No rate limits.** No 1200 weight/min cap, no per-address throttling, no IP buckets.
- **Faster reads.** Sub-150 ms p50 target for warm responses; orderbook reads driven from a live WebSocket-fed cache.
- **More types.** Batched user state, builder-attribution data, liquidation feed, and composites.
- **HIP-3 and HIP-4 first-class.** Deployer-prefix syntax (`xyz:GOLD-USDC`) is supported across `meta` and `metaAndAssetCtxs` when a `dex` is provided.
- **One key for everything Hyperliquid.** The same API key unlocks HyperEVM via the Foundational API.

---

The most popular Hyperliquid SDKs work against GoldRush after a one-line `baseUrl` override and adding an `Authorization` header.

## JavaScript / TypeScript: [`nomeida/hyperliquid`](https://github.com/nomeida/hyperliquid)

### Install

```bash npm
npm install hyperliquid
```

```bash yarn
yarn add hyperliquid
```

### Configure

```typescript
import { Hyperliquid } from "hyperliquid";

const sdk = new Hyperliquid({
  // Point at GoldRush
  baseUrl: "https://hypercore.goldrushdata.com",
  // Inject the Authorization header on every request
  headers: {
    Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}`,
  },
});

// Existing methods work unchanged
const ctxs = await sdk.info.metaAndAssetCtxs();
const account = await sdk.info.clearinghouseState({
  user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
});
const spot = await sdk.info.spotClearinghouseState({
  user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
});
const orders = await sdk.info.frontendOpenOrders({
  user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
});
```

> **Note:** If your SDK version doesn't expose a `headers` option, wrap `fetch` to inject the header globally before instantiating the SDK. See the patch pattern below.

### Header injection fallback

```typescript
const originalFetch = globalThis.fetch;
globalThis.fetch = (input, init = {}) => {
  const headers = new Headers(init.headers);
  if (typeof input === "string" && input.startsWith("https://hypercore.goldrushdata.com")) {
    headers.set("Authorization", `Bearer ${process.env.GOLDRUSH_API_KEY}`);
  }
  return originalFetch(input, { ...init, headers });
};
```

## Python: [`hyperliquid-dex/hyperliquid-python-sdk`](https://github.com/hyperliquid-dex/hyperliquid-python-sdk)

### Install

```bash
pip install hyperliquid-python-sdk
```

### Configure

```python
import os
from hyperliquid.info import Info

# Point Info at GoldRush
info = Info(base_url="https://hypercore.goldrushdata.com", skip_ws=True)

# Inject the Authorization header on the underlying session
info.session.headers.update({
    "Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"
})

# Existing methods work unchanged
ctxs = info.meta_and_asset_ctxs()
account = info.user_state("0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00")
spot = info.spot_user_state("0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00")
orders = info.frontend_open_orders("0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00")
```

> **Tip:** `skip_ws=True` is recommended when using the Info API only - it skips the WebSocket connection that the SDK opens by default to upstream Hyperliquid.

## Verification

After cutover, confirm everything is wired correctly:

1. **Diff a known wallet** - call `clearinghouseState` for the same wallet against both endpoints; the JSON shape (keys, nesting, types) should match exactly.
2. **Confirm auth** - remove the API key and confirm you get a `401` with body `{"error":"unauthorized"}`. If you get any other response, your request isn't reaching GoldRush.

## Other SDKs

The pattern is the same for any HTTP client: override the base URL to `https://hypercore.goldrushdata.com` and attach `Authorization: Bearer `. If you run into a specific SDK that doesn't expose either knob, [open a support ticket](https://goldrush.dev/platform/support/) - we'll publish a recipe.

---

## Hyperliquid API rate limits

The **public Hyperliquid `/info` API** is rate limited to **1200 request weight per minute per IP address**. Every `/info` request carries a weight cost, so heavy usage - polling many wallets, refreshing market state frequently, or running a fleet of workers behind one IP - hits the cap quickly and starts getting throttled.

**The GoldRush Hyperliquid Info API removes this limit entirely.** It's a **drop-in `/info` replacement** on `hypercore.goldrushdata.com/info` with byte-for-byte identical request and response shapes, but **no per-IP, per-key, or per-address rate limits**.

## No rate limits with GoldRush

With no weight cap and no per-IP throttling, you can:

- Poll any user-state endpoint as fast as your code wants.
- Open as many concurrent connections as your client supports.
- Pull state for thousands of wallets in tight loops.

For wallet-level real-time updates without polling at all, use the **`walletTxs` subscription** instead - push-based, also no rate limits.

## How caching works

Responses are served from a real-time cache that's kept fresh by direct ingestion from Hyperliquid. The cache is transparent to your client code - same JSON in, same JSON out.

| Cache layer | Typical freshness |
|---|---|
| User-state types (`clearinghouseState`, `spotClearinghouseState`, `frontendOpenOrders`) | Sub-second after each user event. |
| Market types (`metaAndAssetCtxs`) | Sub-second on every mark-price tick. |

## Recommended polling cadences

You're not rate-limited, but polling smartly saves your own bandwidth.

| Endpoint | Recommended interval | Notes |
|---|---|---|
| `metaAndAssetCtxs` | 1 second | Mark prices update on every tick. |
| `clearinghouseState` | 1 second per user, OR push via **`walletTxs`** | Account state only changes on a user event; push is far more efficient than polling. |
| `spotClearinghouseState` | 5 seconds | Spot balances change less frequently than perp positions. |
| `frontendOpenOrders` | 1 second per user, OR push via `walletTxs` | Same as `clearinghouseState`. |

## Watch out for client-side limits

GoldRush has no rate limits, but the rest of your stack might:

- **Browser fetch concurrency** - most browsers cap at ~6 concurrent requests per host. Use connection pooling on the server side or batch requests.
- **HTTP/2 stream limits** - most clients allow 100+ concurrent streams per connection by default. Bump if you're saturating.
- **OS file descriptor limits** - if you're opening thousands of connections, raise `ulimit -n`.

For multi-wallet fan-out, use the **`batchClearinghouseState`** and **`batchSpotClearinghouseState`** endpoints, which accept up to 50 wallets per call. For more than 50 wallets, issue multiple calls.

## Network and TLS

- **HTTP/2** keep-alive is supported and recommended.
- **TLS 1.2+** required.
- **`Accept-Encoding: gzip`** is honored. `zstd` support is on the roadmap.

## Need higher guarantees?

Enterprise SLA, dedicated capacity, regional pinning, and on-prem options are all available. **Email sales**.

---

# Hyperliquid Info API Reference

## activeAssetData | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "activeAssetData"` is used to fetch a user's active trading limits, leverage setting, available size, and mark price for a single Hyperliquid perpetual asset.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "activeAssetData", "user": "...", "coin": "ETH"}`.
- `coin` accepts the Hyperliquid asset identifier for the target perp market. For HIP-3 markets, pass the same dex-qualified coin string used by Hyperliquid for that asset.
- `maxTradeSzs` and `availableToTrade` are returned as two directional decimal-string values. Preserve the upstream array order and use fixed-precision decimal handling.
- For whole-account position and margin state, use `clearinghouseState`; this endpoint is scoped to one user and one active asset.

Returns per-user, per-asset trading state for one active perpetual market: the user's leverage setting, directional max trade sizes, directional available-to-trade amounts, and the current mark price.

User-keyed and coin-keyed. Use this when a trading UI needs to show how much size a wallet can open or close on a specific asset before placing an order. For full account margin and open positions, use [clearinghouseState](https://goldrush.dev/docs/api-reference/hyperliquid-info/clearinghouse-state); for market metadata and asset context, use [metaAndAssetCtxs](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta-and-asset-ctxs).

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"activeAssetData"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `coin` | `string` | Yes | The perp asset identifier, e.g. `"ETH"` or `"APT"`. For HIP-3 markets, pass the same dex-qualified coin string used by Hyperliquid for that asset. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "activeAssetData",
    "user": "0xb65822a30bbaaa68942d6f4c43d78704faeabbbb",
    "coin": "APT"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "activeAssetData",
    user: "0xb65822a30bbaaa68942d6f4c43d78704faeabbbb",
    coin: "APT",
  }),
});

const activeAsset = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "activeAssetData",
        "user": "0xb65822a30bbaaa68942d6f4c43d78704faeabbbb",
        "coin": "APT",
    },
)

active_asset = response.json()
```

## Response

A single JSON object with the user's active trading configuration and directional trading capacity for the requested asset.

```json
{
  "user": "0xb65822a30bbaaa68942d6f4c43d78704faeabbbb",
  "coin": "APT",
  "leverage": {
    "type": "cross",
    "value": 3
  },
  "maxTradeSzs": ["24836370.4400000013", "24836370.4400000013"],
  "availableToTrade": ["37019438.0284740031", "37019438.0284740031"],
  "markPx": "4.4716"
}
```

### Field descriptions

> **Note:** Prices, sizes, and available amounts are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | Wallet address the active asset data was computed for. |
| `coin` | `string` | Hyperliquid asset identifier, such as `"APT"` or `"ETH"`. |
| `leverage` | `object` | User's configured leverage for this asset. |
| `leverage.type` | `string` | Leverage mode, usually `"cross"` or `"isolated"`. |
| `leverage.value` | `int` | Configured leverage multiplier. |
| `maxTradeSzs` | `array` | Directional maximum trade sizes for this wallet and asset, returned as decimal strings. |
| `availableToTrade` | `array` | Directional available-to-trade amounts for this wallet and asset, returned as decimal strings. |
| `markPx` | `string` | Current mark price for the asset. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### allMids

fetch the current mid price for every actively traded asset in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-07-08_

{/* generated:hl-footer-end */}

---

## allMids | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "allMids"` is used to fetch the current mid price for every actively traded asset in a single call.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "allMids"}`.
- The response is a flat map keyed by asset. Perp assets use their symbol (e.g. `BTC`); spot pairs are keyed as `@` using the spot pair index from [spotMeta](https://goldrush.dev/docs/api-reference/hyperliquid-info/spot-meta).
- The optional `dex` field takes a perp DEX name. It defaults to the empty string, which represents the first (native) perp DEX; pass a HIP-3 dex name to scope mids to that dex.
- Mid prices are returned as decimal strings - keep them as strings or use a fixed-precision decimal type rather than parsing as floats.

Returns the current mid price for every actively traded asset in one call. The mid price is the midpoint between the best bid and the best ask. The payload is a single JSON object mapping each asset key to its mid price as a decimal string.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"allMids"`. |
| `dex` | `string` | No | HIP-3 builder DEX identifier. Empty string (default) returns mids for the first (native) perp DEX. Pass a builder code (e.g. `"xyz"`) to scope mids to a HIP-3 deployer's perp DEX. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "allMids",
    "dex": ""
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "allMids",
    dex: "",
  }),
});

const mids = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "allMids", "dex": ""},
)

mids = response.json()
```

## Response

A JSON object mapping each asset key to its mid price as a decimal string.

```json
{
  "BTC": "64000.0",
  "ETH": "3000.0",
  "@1": "1.0002"
}
```

### Field descriptions

> **Note:** All mid prices are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `{coin}` | `string` | Mid price for the asset, as a decimal string. Perp assets are keyed by symbol (e.g. `BTC`, `ETH`); spot pairs are keyed as `@` using the spot pair index from `spotMeta`. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### candleSnapshot

fetch historical OHLCV candles for a coin and interval over a time window for charting and backtesting.

### fundingHistory

fetch a coin’s historical funding rates and premiums over a time window for funding analytics and basis strategies.

### l2Book

fetch an aggregated Level-2 order book snapshot for a single coin - bids and asks as price, size, and order-count levels.

### l2BookDiffSnapshot

fetch a full-depth L2 order book snapshot for one coin, with height, epoch, and seq to bootstrap the l2BookDiff2 stream.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## allPerpMetas | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "allPerpMetas"` is used to fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native — not part of the original Hyperliquid API. It fans [meta](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta) out across every perp DEX so you get the whole map in one call.
- The response is an array: index `0` is the native Hyperliquid perp DEX; each later entry is a HIP-3 builder-deployed perp DEX, in the same order as [perpDexs](https://goldrush.dev/docs/api-reference/hyperliquid-info/perp-dexs).
- For a single DEX's metadata, use [meta](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta) with the `dex` field — this endpoint is the heavier, all-DEX equivalent.

Returns the full universe and margin tables across every perp DEX on HyperCore. Each element carries a DEX's universe (its perp asset definitions), its marginTables (leverage-bracket tiers), and the collateralToken index.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"allPerpMetas"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "allPerpMetas"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "allPerpMetas",
  }),
});

const allPerpMetas = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "allPerpMetas"},
)

all_perp_metas = response.json()
```

## Response

An array with one entry per perp DEX. Index `0` is the native Hyperliquid perp DEX; later entries are the HIP-3 builder-deployed perp DEXes in `perpDexs` order.

```json
[
  {
    "universe": [
      { "szDecimals": 5, "name": "BTC", "maxLeverage": 40, "marginTableId": 56 },
      { "szDecimals": 4, "name": "ETH", "maxLeverage": 25, "marginTableId": 55 }
    ],
    "marginTables": [
      [50, { "description": "", "marginTiers": [{ "lowerBound": "0.0", "maxLeverage": 50 }] }]
    ],
    "collateralToken": 0
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `[n]` | `object` | Perpetuals metadata for one perp DEX (index `0` = native Hyperliquid; later = HIP-3 DEXes). |
| `[n].universe` | `array` | The DEX's perp asset definitions.  __RESPONSE_ROW__name	string	Asset name (with the DEX prefix for builder-deployed perps, e.g. `xyz:TSLA`). __RESPONSE_ROW__[n].szDecimals	int	Number of decimals for the size field. __RESPONSE_ROW__[n].maxLeverage	int	Maximum leverage for the asset. __RESPONSE_ROW__[n].marginTableId	int	Margin table id referenced in `marginTables`. __RESPONSE_ROW__[n].isDelisted	bool	Present and `true` if the asset is delisted. "> List of `[marginTableId, marginTable]` pairs for this DEX. Each `marginTable` has a `description` and a `marginTiers` array of `{ lowerBound, maxLeverage }` tiers (decimal-string bounds). |
| `collateralToken` | `int` | Token index used as collateral for this DEX. |



{/* generated:hl-linkhub-start */}

## Related endpoints


### perpDeployAuctionStatus

fetch the current perp-deploy Dutch-auction status.

### perpDexLimits

fetch the open-interest, position-size, and transfer limits for a HIP-3 perp DEX.

### perpDexs

enumerate every HIP-3 builder-deployed perpetual DEX on HyperCore.

### meta

fetch the perpetuals universe metadata without live market context.

### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

### outcomeMeta

enumerate all active HIP-4 binary outcome markets on HyperCore.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## batchClearinghouseState | Hyperliquid Info API

**Credit Cost:** 25 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "batchClearinghouseState"` is used to fetch perpetuals account state for up to 50 wallets in a single request.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - No upstream equivalent. This endpoint exists only on `hypercore.goldrushdata.com`. It is not a passthrough.
- Deduplication is case-insensitive. Two addresses that differ only in case (`0xAbC...` vs `0xabc...`) collapse to a single slot in the output, at the position of the first occurrence in the input.
- Order preservation. The order of slots in the response matches the order of unique wallets in the input.
- Partial failure is normal. HTTP `200 OK` is returned even when individual slots are error envelopes. Always check for the `error` key on each slot before using its fields.
- No cursor or pagination. All requested wallets are fanned out in parallel. For batches larger than 50, issue multiple calls.
- Use cases: portfolio dashboards, multi-wallet PnL aggregators, fleet-level liquidation risk monitoring, copy-trade source-wallet inventory.

Fetches perpetuals account state for **1 to 50 wallets** in a single request. The standard Hyperliquid `/info` API is single-wallet, so polling N wallets means N round trips; this endpoint fans them out in parallel against our private node and returns a single combined response.

This is a **GoldRush-native extension**. There is no equivalent on `api.hyperliquid.xyz/info`. The wrapped slots return exactly the same shape as Hyperliquid’s native single-wallet `clearinghouseState`, with a thin per-wallet error envelope when an individual wallet fails.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"batchClearinghouseState"`. |
| `users` | `array` | Yes | List of wallet addresses to query. **1 to 50 entries.** Duplicates are removed (case-insensitive); input order is preserved for the surviving entries. |
| `dex` | `string` | No | Optional perpetuals DEX name. Forwarded unchanged to each per-wallet upstream call. Omit for the primary DEX. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "batchClearinghouseState",
    "users": [
      "0xb0a55f13d22f66e6d495ac98113841b2326e9540",
      "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
      "0x31ca8395cf837de08b24da3f660e77761dfb974b"
    ]
  }'
```

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

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "batchClearinghouseState",
        "users": [
            "0xb0a55f13d22f66e6d495ac98113841b2326e9540",
            "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
            "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        ],
    },
)

slots = response.json()

for i, slot in enumerate(slots):
    if "error" in slot:
        print(f"wallet {slot['user']} failed: {slot['message']}")
        continue
    print(f"wallet {i}: {slot['withdrawable']} USD withdrawable")
```

## Response

```
HTTP/2 200 OK
Content-Type: application/json
```

The body is a JSON array. **Element `i` corresponds to the i-th unique wallet in the deduplicated input order.** Each element is either:

- The raw upstream Hyperliquid response object for that wallet (success), or
- A slot-level error object (failure for that wallet only, see below).

### All success

Example success body for `batchClearinghouseState` with 3 wallets: one empty account, one with a single cross-margin position, one with a single isolated-margin position.

```json
[
  {
    "user":               "0x.....",
    "marginSummary":      {"accountValue":"0.0","totalNtlPos":"0.0","totalRawUsd":"0.0","totalMarginUsed":"0.0"},
    "crossMarginSummary": {"accountValue":"0.0","totalNtlPos":"0.0","totalRawUsd":"0.0","totalMarginUsed":"0.0"},
    "crossMaintenanceMarginUsed": "0.0",
    "withdrawable": "0.0",
    "assetPositions": [],
    "time": 1777671895013
  },
  {
    "user":               "0x.....",
    "marginSummary":      {"accountValue":"28.848558","totalNtlPos":"134.30367","totalRawUsd":"163.152228","totalMarginUsed":"22.383945"},
    "crossMarginSummary": {"accountValue":"28.848558","totalNtlPos":"134.30367","totalRawUsd":"163.152228","totalMarginUsed":"22.383945"},
    "crossMaintenanceMarginUsed": "6.715183",
    "withdrawable": "6.464613",
    "assetPositions": [
      {
        "type": "oneWay",
        "position": {
          "coin": "SUI",
          "szi": "-145.8",
          "leverage": { "type": "cross", "value": 6 },
          "entryPx": "0.91652",
          "positionValue": "134.30367",
          "unrealizedPnl": "-0.674997",
          "returnOnEquity": "-0.0303077319",
          "liquidationPx": "1.0657275328",
          "marginUsed": "22.383945",
          "maxLeverage": 10,
          "cumFunding": { "allTime": "0.348217", "sinceOpen": "0.234102", "sinceChange": "0.206894" }
        }
      }
    ],
    "time": 1777671895076
  },
  {
    "user":               "0x.....",
    "marginSummary":      {"accountValue":"681.226963","totalNtlPos":"1353.54306","totalRawUsd":"-672.316097","totalMarginUsed":"681.226963"},
    "crossMarginSummary": {"accountValue":"0.0","totalNtlPos":"0.0","totalRawUsd":"0.0","totalMarginUsed":"0.0"},
    "crossMaintenanceMarginUsed": "0.0",
    "withdrawable": "0.0",
    "assetPositions": [
      {
        "type": "oneWay",
        "position": {
          "coin": "BTC",
          "szi": "0.01734",
          "leverage": { "type": "isolated", "value": 2, "rawUsd": "-672.316097" },
          "entryPx": "77441.3",
          "positionValue": "1353.54306",
          "unrealizedPnl": "10.710288",
          "returnOnEquity": "0.0159517823",
          "liquidationPx": "39263.3464441622",
          "marginUsed": "681.226963",
          "maxLeverage": 40,
          "cumFunding": { "allTime": "0.326319", "sinceOpen": "0.271556", "sinceChange": "-0.026742" }
        }
      }
    ],
    "time": 1777671895076
  }
]
```

### Mixed result (one wallet failed)

When a single wallet fails (upstream timeout, transport failure, parse failure, etc.), only its slot is replaced with an error object. The rest of the batch is unaffected. The HTTP status is still `200 OK`.

```json
[
  { "withdrawable": "13104.514502", "...": "..." },
  {
    "error": "upstream_error",
    "user": "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
    "message": "overall batch timeout exceeded"
  },
  { "withdrawable": "0.0", "...": "..." }
]
```

### Per-wallet error slot

| Field | Type | Description |
| --- | --- | --- |
| `error` | `string` | Always `"upstream_error"` for slot-level failures. Distinguishes error slots from success slots, which never have a top-level `error` field. |
| `user` | `string` | The exact wallet address (lowercased) whose slot this is. Lets you correlate even if you didn't track input order. |
| `message` | `string` | Human-readable description: `upstream_error: `, `upstream returned HTTP `, `overall batch timeout exceeded`, or similar. |

## clearinghouseState slot field reference

Each success slot mirrors Hyperliquid's native `clearinghouseState` response: `assetPositions[]`, `crossMarginSummary`, `marginSummary`, `crossMaintenanceMarginUsed`, `time`, `withdrawable`. There is no schema imposition - it's the raw upstream object.

For full per-field types and notes (including the two `leverage` shapes and the nullable `liquidationPx`), see the single-wallet endpoint:

### clearinghouseState field reference

Full request and response schema for the single-wallet variant. The batch endpoint returns the same object per slot.

For the canonical upstream documentation, see Hyperliquid's [Perpetuals info docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals).

{/* generated:hl-linkhub-start */}

## Related endpoints


### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### portfolioState

fetch a wallet's perp clearinghouse state, spot balances, and account-abstraction mode in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-13_

{/* generated:hl-footer-end */}

---

## batchSpotClearinghouseState | Hyperliquid Info API

**Credit Cost:** 25 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "batchSpotClearinghouseState"` is used to fetch spot account balances for up to 50 wallets in a single request.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - No upstream equivalent. This endpoint exists only on `hypercore.goldrushdata.com`. It is not a passthrough.
- Deduplication is case-insensitive. Two addresses that differ only in case collapse to a single slot at the position of the first occurrence in the input.
- Order preservation. Slots in the response are in the order of unique wallets in the input.
- Partial failure is normal. HTTP `200 OK` is returned even when individual slots are error envelopes. Always check for the `error` key on each slot before using its fields.
- No cursor or pagination. All requested wallets are fanned out in parallel. For batches larger than 50, issue multiple calls.
- Use cases: token treasury monitoring, holder analytics, balance reconciliation, multi-wallet airdrop eligibility checks.

Fetches spot account state for **1 to 50 wallets** in a single request. The standard Hyperliquid `/info` API is single-wallet; this endpoint fans the requests out in parallel against our private node and returns a combined response.

This is a **GoldRush-native extension**. There is no equivalent on `api.hyperliquid.xyz/info`. The wrapped slots return exactly the same shape as Hyperliquid’s native single-wallet `spotClearinghouseState`, with a thin per-wallet error envelope when an individual wallet fails.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"batchSpotClearinghouseState"`. |
| `users` | `array` | Yes | List of wallet addresses to query. **1 to 50 entries.** Duplicates are removed (case-insensitive); input order is preserved for the surviving entries. |
| `dex` | `string` | No | Reserved for future HIP-3 spot DEX support. Pass empty string or omit. |

### Example

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

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "batchSpotClearinghouseState",
    users: [
      "0xb0a55f13d22f66e6d495ac98113841b2326e9540",
      "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
    ],
  }),
});

const slots = await response.json();

for (const [i, slot] of slots.entries()) {
  if ("error" in slot) {
    console.warn(`wallet ${slot.user} failed: ${slot.message}`);
    continue;
  }
  console.log(`wallet ${i}: ${slot.balances.length} tokens`);
}
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "batchSpotClearinghouseState",
        "users": [
            "0xb0a55f13d22f66e6d495ac98113841b2326e9540",
            "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
        ],
    },
)

slots = response.json()

for i, slot in enumerate(slots):
    if "error" in slot:
        print(f"wallet {slot['user']} failed: {slot['message']}")
        continue
    print(f"wallet {i}: {len(slot['balances'])} tokens")
```

## Response

```
HTTP/2 200 OK
Content-Type: application/json
```

The body is a JSON array. **Element `i` corresponds to the i-th unique wallet in the deduplicated input order.** Each element is either:

- The raw upstream Hyperliquid response object for that wallet (success), or
- A slot-level error object (failure for that wallet only, see below).

### All success

Example success body for `batchSpotClearinghouseState` with 3 wallets: one empty wallet, one with a single USDC balance, one with multiple tokens including held amounts.

```json
[
  {
    "user": "0x.....",
    "balances": [] },
  {
    "user": "0x.....",
    "balances": [
      { "coin": "USDC",  "token": 0,   "total": "0.001124", "hold": "0.0", "entryNtl": "0.0" },
      { "coin": "USDE",  "token": 235, "total": "0.0",      "hold": "0.0", "entryNtl": "0.0" },
      { "coin": "USDT0", "token": 268, "total": "0.0",      "hold": "0.0", "entryNtl": "0.0" },
      { "coin": "USDH",  "token": 360, "total": "0.0",      "hold": "0.0", "entryNtl": "0.0" }
    ],
    "tokenToAvailableAfterMaintenance": [[0, "0.001124"]]
  },
  {
    "user": "0x.....",
    "balances": [
      { "coin": "USDC", "token": 0,   "total": "129411.68874505", "hold": "73888.84763", "entryNtl": "0.0" },
      { "coin": "HYPE", "token": 150, "total": "959.37146013",    "hold": "0.0",         "entryNtl": "33092.4684" },
      { "coin": "UBTC", "token": 197, "total": "0.2104009544",    "hold": "0.0",         "entryNtl": "16128.2486005" },
      { "coin": "UETH", "token": 221, "total": "20.87812637",     "hold": "7.0018",      "entryNtl": "49605.34810641" }
    ]
  }
]
```

### Mixed result (one wallet failed)

When a single wallet fails (upstream timeout, transport failure, parse failure, etc.), only its slot is replaced with an error object. The rest of the batch is unaffected. The HTTP status is still `200 OK`.

```json
[
  { "balances": [...] },
  {
    "error": "upstream_error",
    "user": "0x198ef79f1f515f02dfe9e3115ed9fc07183f02fc",
    "message": "overall batch timeout exceeded"
  }
]
```

### Per-wallet error slot

| Field | Type | Description |
| --- | --- | --- |
| `error` | `string` | Always `"upstream_error"` for slot-level failures. Distinguishes error slots from success slots, which never have a top-level `error` field. |
| `user` | `string` | The exact wallet address (lowercased) whose slot this is. Lets you correlate even if you didn't track input order. |
| `message` | `string` | Human-readable description: `upstream_error: `, `upstream returned HTTP `, `overall batch timeout exceeded`, or similar. |

## spotClearinghouseState slot field reference

Each success slot mirrors Hyperliquid's native `spotClearinghouseState` response: `balances[]` plus the optional `tokenToAvailableAfterMaintenance` field. There is no schema imposition - it's the raw upstream object.

The `tokenToAvailableAfterMaintenance` field is **optional** and only present when at least one token has a non-zero margin-deduction-aware balance. Wallets without this field can simply ignore it; absence is normal for empty or inactive wallets.

For full per-field types and notes, see the single-wallet endpoint:

### spotClearinghouseState field reference

Full request and response schema for the single-wallet variant. The batch endpoint returns the same object per slot.

For the canonical upstream documentation, see Hyperliquid's [Spot info docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/spot).

{/* generated:hl-linkhub-start */}

## Related endpoints


### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### batchClearinghouseState

fetch perpetuals account state for up to 50 wallets in a single request.

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

### spotDeployState

fetch the spot-token deployment state and gas auction for a deployer.

### portfolioState

fetch a wallet's perp clearinghouse state, spot balances, and account-abstraction mode in a single request.

### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-05-21_

{/* generated:hl-footer-end */}

---

## borrowLendUserState | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "borrowLendUserState"` is used to monitor a wallet’s current borrow/lend positions and liquidation risk (account health) in a single call.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "borrowLendUserState", "user": "..."}`.
- `tokenToState` is an array of `[tokenIndex, state]` pairs — empty for users with no borrow/lend positions (the common case). `tokenIndex` is the Hyperliquid token index (e.g. `150` = HYPE on mainnet).
- Each `state` has `borrow` and `supply` objects shaped `{ "value": , "basis":  }` — `value` is the amount owed or held now, `basis` is the cost basis.
- `health` is one of `"healthy"`, `"atRisk"`, or `"liquidatable"`; `healthFactor` is a decimal string, or `null`until the user borrows.
- Balances and `healthFactor` are decimal strings — keep them as strings or use a fixed-precision decimal type rather than parsing as floats.

Returns a user’s current spot borrow/lend state: the borrowed and supplied (lent) balance of each token the user holds a position in, plus an account-level health summary. The payload is a JSON object with tokenToState, health, and healthFactor; tokenToState is an array of [tokenIndex, state] pairs and is empty for users with no borrow/lend positions.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"borrowLendUserState"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "borrowLendUserState",
    "user": "0x2057d4f2b6ea957b63371980775b0a5505a438f0"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "borrowLendUserState",
    user: "0x2057d4f2b6ea957b63371980775b0a5505a438f0",
  }),
});

const state = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "borrowLendUserState",
        "user": "0x2057d4f2b6ea957b63371980775b0a5505a438f0",
    },
)

state = response.json()
```

## Response

A single object. This wallet borrows USDC (token `0`) against HYPE (token `150`) it has supplied:

```json
{
  "tokenToState": [
    [
      0,
      {
        "borrow": { "basis": "550000.13902679", "value": "553106.31635104" },
        "supply": { "basis": "0.0", "value": "0.0" }
      }
    ],
    [
      150,
      {
        "borrow": { "basis": "0.0", "value": "0.0" },
        "supply": { "basis": "25000.0", "value": "25000.0" }
      }
    ]
  ],
  "health": "healthy",
  "healthFactor": "2.277500659"
}
```

A wallet with no borrow/lend positions returns an empty `tokenToState` and a `null` `healthFactor`:

```json
{ "tokenToState": [], "health": "healthy", "healthFactor": null }
```

### Field descriptions

> **Note:** `value`, `basis` and `healthFactor` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `tokenToState` | `array` | One `[tokenIndex, state]` pair per token the user has a borrow/lend position in. Empty when the user has none. |
| `tokenToState.borrow` | `object` | The user's borrowed balance of this token.  __RESPONSE_ROW__value	string	Amount owed now, including accrued interest. __RESPONSE_ROW__tokenToState.basis	string	Cost basis of the borrowed amount. __RESPONSE_ROW__supply	object	The user's supplied (lent) balance of this token. __RESPONSE_ROW__supply.value	string	Amount held now, including accrued interest. __RESPONSE_ROW__supply.basis	string	Cost basis of the supplied amount.  |
| `health` | `string` | Account health: `"healthy"`, `"atRisk"` or `"liquidatable"`. |
| `healthFactor` | `string | null` | Account health factor as a decimal string, or `null` until the user borrows. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userBorrowLendInterest

fetch a user’s borrow/lend interest accrual history.

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### liquidatable

list accounts currently eligible for liquidation.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-11-05_

{/* generated:hl-footer-end */}

---

## builderFillsByTime | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "builderFillsByTime"` is used to fetch a builder’s attributed trade fills within a time window for revenue attribution and fee accounting.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native: No `POST api.hyperliquid.xyz/info` equivalent. Available only via `POST hypercore.goldrushdata.com/info`.
- Each response contains at most 2,000 fills; widen the window in chunks or page by advancing `startTime` if you need more.
- GoldRush serves this `type` from a dedicated HyperCore historical store, so windows can extend back to GoldRush’s full HyperCore coverage.
- Use [`builderFills`](https://goldrush.dev/docs/api-reference/hyperliquid-info/builder-fills) (no `Time` suffix) when you only need the most recent N fills without specifying a window.

Returns fills attributed to a builder address bounded by a `[startTime, endTime]` window in milliseconds. Use this for builder revenue reports, monthly fee reconciliation, or rebuilding historical builder order-flow.

Builder-keyed. GoldRush-native as there is no upstream Hyperliquid `/info` equivalent. Served from a dedicated HyperCore historical store, so windows can extend back to GoldRush’s full HyperCore coverage.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"builderFillsByTime"`. |
| `builder` | `string` | Yes | The builder address that orders were routed through. Must be a `0x`-prefixed 42-character hex address. |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound. Required unless `cursor` is supplied. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |
| `aggregateByTime` | `boolean` | No | When `true`, partial fills sharing the same timestamp are consolidated into one row. Default `false`. |
| `cursor` | `string` | No | Pagination cursor - a Unix timestamp in milliseconds encoded as a string. When set, returns fills strictly before this time and overrides `startTime`. Use the `time` value of the oldest fill in the previous page to fetch the next page. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "builderFillsByTime",
    "builder": "0x0000000000000000000000000000000000000000",
    "startTime": 1781000000000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "builderFillsByTime",
    builder: "0x0000000000000000000000000000000000000000",
    startTime: 1781000000000,
  }),
});

const fills = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "builderFillsByTime",
        "builder": "0x0000000000000000000000000000000000000000",
        "startTime": 1781000000000,
    },
)

fills = response.json()
```

## Response

An array of fill objects ordered by `time`. Each entry is a fill from an order that was routed through the builder address within the window.

```json
[
  {
    "user": "0x73f9c53a8b15e43056d5599f6488ac9a8730f85d",
    "coin": "HYPE",
    "px": "66.977",
    "sz": "0.69",
    "side": "B",
    "time": 1781518798259,
    "startPosition": "0",
    "dir": "Open Long",
    "closedPnl": "0",
    "hash": "0x2b7bd2df9499dfef2cf5043dc500b402068500c52f9cfec1cf447e32539db9d9",
    "oid": 469533808540,
    "crossed": true,
    "fee": "0.048524",
    "tid": 332575399132451,
    "feeToken": "USDC",
    "builderFee": "0.027728",
    "cloid": "0xff8ffaa775354e8faf1eaa18127d6b5e"
  }
]
```

### Field descriptions

> **Note:** All numeric fields (`px`, `sz`, `startPosition`, `closedPnl`, `fee`, `builderFee`) are returned as **decimal strings** with full upstream precision (up to 18 decimal places). Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | The trader's wallet address - the account that placed the order routed through the builder code. |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`); HIP-3 markets use the deployer-prefixed form. |
| `px` | `string` | Fill execution price. |
| `sz` | `string` | Fill size. |
| `side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `startPosition` | `string` | Signed position size the trader held on this coin immediately before this fill. |
| `dir` | `string` | Human-readable direction label - `"Open Long"`, `"Open Short"`, `"Close Long"`, `"Close Short"`, `"Buy"`, `"Sell"`, or position-flip labels `"Long > Short"` / `"Short > Long"`. |
| `closedPnl` | `string` | Realized PnL in USDC attributable to this fill for the trader (zero when the fill opens or extends a position). |
| `hash` | `string` | L1 transaction hash that included this fill. |
| `oid` | `int` | Parent order ID. |
| `tid` | `int` | Unique trade ID. |
| `crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fee` | `string` | Trading fee paid by the trader for this fill, denominated in `feeToken`. |
| `feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `builderFee` | `string` | Optional. Builder fee earned for this fill, denominated in `feeToken`. Omitted when no builder fee was charged. |
| `cloid` | `string` | Optional. Client order ID (`0x`-prefixed 32-character hex) if one was set at order placement. |
| `liquidation` | `object` | Optional. Present only when this fill closed a position as part of a liquidation event. |
| `liquidation.liquidatedUser` | `string` | The wallet whose position was liquidated. |
| `liquidation.markPx` | `string` | Mark price at the time of liquidation. |
| `liquidation.method` | `string` | Liquidation method - e.g. `"Market"`. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### builderFills

fetch a builder’s most recent attributed trade fills for revenue attribution and order-flow analytics.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### userTwapSliceFillsByTime

fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### userTwapSliceFills

fetch a user's most recent TWAP slice fills for execution-quality analytics on algorithmic orders.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## builderFills | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "builderFills"` is used to fetch a builder’s most recent attributed trade fills for revenue attribution and order-flow analytics.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native: No `POST api.hyperliquid.xyz/info` equivalent. Available only via `POST hypercore.goldrushdata.com/info`.
- Each response contains at most 2,000 fills, ordered most-recent first.
- For windowed queries for revenue reports and monthly reconciliation, use [`builderFillsByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/builder-fills-by-time).

Returns the 2,000 most recent fills attributed to a builder address. Use this when you operate a builder code and want to inspect the order flow routed through it without specifying a time window.

Builder-keyed. GoldRush-native so there is no upstream Hyperliquid `/info` equivalent.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"builderFills"`. |
| `builder` | `string` | Yes | The builder address that orders were routed through. Must be a `0x`-prefixed 42-character hex address. |
| `aggregateByTime` | `boolean` | No | When `true`, partial fills sharing the same timestamp are consolidated into one row. Default `false`. |
| `cursor` | `string` | No | Pagination cursor — a Unix timestamp in milliseconds encoded as a string. When set, returns fills strictly before this time. Use the `time` value of the oldest fill in the previous page to fetch the next page. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "builderFills",
    "builder": "0x0000000000000000000000000000000000000000"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "builderFills",
    builder: "0x0000000000000000000000000000000000000000",
  }),
});

const fills = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "builderFills",
        "builder": "0x0000000000000000000000000000000000000000",
    },
)

fills = response.json()
```

## Response

An array of fill objects ordered most-recent-first. Each entry is a fill from an order that was routed through the builder address.

```json
[
  {
    "user": "0x73f9c53a8b15e43056d5599f6488ac9a8730f85d",
    "coin": "HYPE",
    "px": "66.977",
    "sz": "0.69",
    "side": "B",
    "time": 1781518798259,
    "startPosition": "0",
    "dir": "Open Long",
    "closedPnl": "0",
    "hash": "0x2b7bd2df9499dfef2cf5043dc500b402068500c52f9cfec1cf447e32539db9d9",
    "oid": 469533808540,
    "crossed": true,
    "fee": "0.048524",
    "tid": 332575399132451,
    "feeToken": "USDC",
    "builderFee": "0.027728",
    "cloid": "0xff8ffaa775354e8faf1eaa18127d6b5e"
  }
]
```

### Field descriptions

> **Note:** All numeric fields (`px`, `sz`, `startPosition`, `closedPnl`, `fee`, `builderFee`) are returned as **decimal strings** with full upstream precision (up to 18 decimal places). Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | The trader's wallet address - the account that placed the order routed through the builder code. |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`); HIP-3 markets use the deployer-prefixed form. |
| `px` | `string` | Fill execution price. |
| `sz` | `string` | Fill size. |
| `side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `startPosition` | `string` | Signed position size the trader held on this coin immediately before this fill. |
| `dir` | `string` | Human-readable direction label - `"Open Long"`, `"Open Short"`, `"Close Long"`, `"Close Short"`, `"Buy"`, `"Sell"`, or position-flip labels `"Long > Short"` / `"Short > Long"`. |
| `closedPnl` | `string` | Realized PnL in USDC attributable to this fill for the trader (zero when the fill opens or extends a position). |
| `hash` | `string` | L1 transaction hash that included this fill. |
| `oid` | `int` | Parent order ID. |
| `tid` | `int` | Unique trade ID. |
| `crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fee` | `string` | Trading fee paid by the trader for this fill, denominated in `feeToken`. |
| `feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `builderFee` | `string` | Optional. Builder fee earned for this fill, denominated in `feeToken`. Omitted when no builder fee was charged. |
| `cloid` | `string` | Optional. Client order ID (`0x`-prefixed 32-character hex) if one was set at order placement. |
| `liquidation` | `object` | Optional. Present only when this fill closed a position as part of a liquidation event. |
| `liquidation.liquidatedUser` | `string` | The wallet whose position was liquidated. |
| `liquidation.markPx` | `string` | Mark price at the time of liquidation. |
| `liquidation.method` | `string` | Liquidation method - e.g. `"Market"`. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### builderFillsByTime

fetch a builder’s attributed trade fills within a time window for revenue attribution and fee accounting.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### userTwapSliceFills

fetch a user's most recent TWAP slice fills for execution-quality analytics on algorithmic orders.

### userTwapSliceFillsByTime

fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## candleSnapshot | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "candleSnapshot"` is used to fetch historical OHLCV candles for a coin and interval over a time window for charting and backtesting.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "candleSnapshot", "req": {...}}`. Note the nested `req` object.
- Each response contains at most 5,000 candles (per-response cap, not a retention limit); page by advancing `startTime` for longer ranges.
- GoldRush serves candles from a dedicated HyperCore historical store, so candles older than the upstream window can extend back to GoldRush’s full HyperCore coverage.

Returns an array of OHLCV candles for a single coin and interval, bounded by a `[startTime, endTime]` window. Each candle carries the open/close timestamps, the coin, the interval, open/high/low/close prices, base volume, and trade count. Use it for chart backfills, indicator computation, and backtests.

This is a global, non-user-keyed type. **NOT LIMITED TO THE MOST RECENT 5,000 CANDLES**. GoldRush serves it from a dedicated HyperCore historical store so candles older than the upstream window remain available; page through time by advancing `startTime`.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

The request parameters are nested inside a `req` object.

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"candleSnapshot"`. |
| `req` | `object` | Yes | The candle query parameters.   The asset symbol, e.g. `"BTC"`. HIP-3 markets use the deployer-prefixed form. |
| `interval` | `string` | Yes | Candle interval. One of `"1m"`, `"3m"`, `"5m"`, `"15m"`, `"30m"`, `"1h"`, `"2h"`, `"4h"`, `"8h"`, `"12h"`, `"1d"`, `"3d"`, `"1w"`, `"1M"`. |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound for the window. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |



### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "candleSnapshot",
    "req": {
      "coin": "BTC",
      "interval": "1h",
      "startTime": 1735689600000,
      "endTime": 1735776000000
    }
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "candleSnapshot",
    req: {
      coin: "BTC",
      interval: "1h",
      startTime: 1735689600000,
      endTime: 1735776000000,
    },
  }),
});

const candles = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "candleSnapshot",
        "req": {
            "coin": "BTC",
            "interval": "1h",
            "startTime": 1735689600000,
            "endTime": 1735776000000,
        },
    },
)

candles = response.json()
```

## Response

An array of candle objects, oldest first.

```json
[
  {
    "t": 1735689600000,
    "T": 1735693199999,
    "s": "BTC",
    "i": "1h",
    "o": "62739.0",
    "c": "62960.0",
    "h": "63118.0",
    "l": "62711.0",
    "v": "921.9829",
    "n": 16396
  }
]
```

### Field descriptions

> **Note:** The price and volume fields (`o`, `c`, `h`, `l`, `v`) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `t` | `int` | Candle open time, Unix milliseconds. |
| `T` | `int` | Candle close time, Unix milliseconds. |
| `s` | `string` | Coin symbol. |
| `i` | `string` | Candle interval - echoes the request `interval`. |
| `o` | `string` | Open price. |
| `c` | `string` | Close price. |
| `h` | `string` | High price. |
| `l` | `string` | Low price. |
| `v` | `string` | Base-asset volume over the candle. |
| `n` | `int` | Number of trades in the candle. |

## Paginating a large backfill

Each response returns at most **5,000 candles** - a per-response cap, not a limit on how far back history goes. To backfill a range wider than 5,000 candles, page forward through time: start at your window's `startTime`, then set the next request's `startTime` to the last candle's close time (`T`) plus one millisecond. Repeat until a response returns fewer than 5,000 candles.

Because `T` is the inclusive close of a candle and the next candle opens at `T + 1`, advancing to `T + 1` lands exactly on the following candle - no overlap to de-duplicate and no gaps.

```typescript TypeScript
async function backfillCandles(
  coin: string,
  interval: string,
  startTime: number,
  endTime: number,
) {
  const all: any[] = [];
  let cursor = startTime;

  while (cursor  **Tip:** Pick the coarsest `interval` that satisfies your use case - larger intervals cover more calendar time per 5,000-candle page, so a multi-year `1d` backfill is a single request while the same range at `1m` pages many times.

{/* generated:hl-linkhub-start */}

## Related endpoints


### l2BookDiffSnapshot

fetch a full-depth L2 order book snapshot for one coin, with height, epoch, and seq to bootstrap the l2BookDiff2 stream.

### allMids

fetch the current mid price for every actively traded asset in a single call.

### fundingHistory

fetch a coin’s historical funding rates and premiums over a time window for funding analytics and basis strategies.

### l2Book

fetch an aggregated Level-2 order book snapshot for a single coin - bids and asks as price, size, and order-count levels.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## clearinghouseState | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "clearinghouseState"` is used to fetch a single user's perpetuals account state by wallet address.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "clearinghouseState", "user": "..."}`.
- The optional `dex` field returns state on a HIP-3 deployer’s perp DEX. Pass `"*"` or `"ALL_DEXES"` to return state across the native dex and every HIP-3 dex in one call.
- Wildcard (`"*"` / `"ALL_DEXES"`) requests are billed at a flat `10 credits` vs. `1 credit` for a single-dex call.
- The `perpDexs` list used for wildcard fan-out is cached ~2 minutes, so a newly-deployed dex may take up to that long to appear in wildcard results.

**Note:** Wildcard (`"*"` / `"ALL_DEXES"`) requests are **billed at a flat 10 credits per call.**

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"clearinghouseState"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `dex` | `string` | No | HIP-3 builder DEX identifier. Empty string (default) returns canonical Hyperliquid perp state. Pass a builder code to query a HIP-3 deployer's perp DEX. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "clearinghouseState",
    "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    "dex": ""
  }'
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

const state = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "clearinghouseState",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "dex": "",
    },
)

state = response.json()
```

## Response

```json
{
  "marginSummary": {
    "accountValue": "12450.83",
    "totalNtlPos": "8500.00",
    "totalRawUsd": "5200.50",
    "totalMarginUsed": "1700.00"
  },
  "crossMarginSummary": {
    "accountValue": "12450.83",
    "totalNtlPos": "8500.00",
    "totalRawUsd": "5200.50",
    "totalMarginUsed": "1700.00"
  },
  "crossMaintenanceMarginUsed": "850.00",
  "withdrawable": "10750.83",
  "assetPositions": [
    {
      "type": "oneWay",
      "position": {
        "coin": "ETH",
        "szi": "2.5",
        "leverage": { "type": "cross", "value": 5 },
        "entryPx": "3400.0",
        "positionValue": "8500.00",
        "unrealizedPnl": "120.50",
        "returnOnEquity": "0.07",
        "liquidationPx": "2800.5",
        "marginUsed": "1700.00",
        "maxLeverage": 50,
        "cumFunding": {
          "allTime": "12.30",
          "sinceOpen": "1.50",
          "sinceChange": "0.50"
        }
      }
    }
  ],
  "time": 1735689600000
}
```

### Field descriptions

> **Note:** All numeric fields below (account value, position size, prices, funding amounts, etc.) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `marginSummary` | `object` | Top-level account margin and value summary. |
| `marginSummary.accountValue` | `string` | Total account value in USD. |
| `marginSummary.totalNtlPos` | `string` | Total notional position size. |
| `marginSummary.totalRawUsd` | `string` | Raw USDC balance excluding unrealized PnL. |
| `marginSummary.totalMarginUsed` | `string` | Margin currently committed to open positions. |
| `crossMarginSummary` | `object` | Cross-margin subset of the margin summary. Same fields. |
| `crossMaintenanceMarginUsed` | `string` | Maintenance margin currently used for cross positions. |
| `withdrawable` | `string` | Amount currently withdrawable, in USD. |
| `assetPositions` | `array` | Open positions, one entry per coin. |
| `assetPositions.type` | `string` | Position type - `"oneWay"` for the standard mode. |
| `assetPositions.position` | `object` |  __RESPONSE_ROW__coin	string	Asset symbol. __RESPONSE_ROW__assetPositions.szi	string	Signed position size (positive = long, negative = short). __RESPONSE_ROW__assetPositions.leverage	object	Two shapes: - Cross: `{ "type": "cross", "value": int }` - Isolated: `{ "type": "isolated", "value": int, "rawUsd": string }` `rawUsd` is **only present** for isolated leverage and may be negative. __RESPONSE_ROW__assetPositions.entryPx	string	Volume-weighted entry price. __RESPONSE_ROW__assetPositions.positionValue	string	Current notional value. __RESPONSE_ROW__assetPositions.unrealizedPnl	string	Unrealized PnL in USD. __RESPONSE_ROW__assetPositions.returnOnEquity	string	Unrealized return on margin used. __RESPONSE_ROW__assetPositions.liquidationPx	string \| null	Liquidation price. **May be literal JSON `null`** when no near-term liquidation applies (e.g. cross-margin with deep cushion). __RESPONSE_ROW__assetPositions.marginUsed	string	Margin committed to this position. __RESPONSE_ROW__assetPositions.maxLeverage	int	Maximum leverage for this asset. __RESPONSE_ROW__assetPositions.cumFunding	object	Cumulative funding paid: `allTime`, `sinceOpen`, `sinceChange`.  |
| `time` | `int` | Snapshot timestamp in milliseconds since Unix epoch. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### batchClearinghouseState

fetch perpetuals account state for up to 50 wallets in a single request.

### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

### borrowLendUserState

monitor a wallet’s current borrow/lend positions and liquidation risk (account health) in a single call.

### portfolioState

fetch a wallet's perp clearinghouse state, spot balances, and account-abstraction mode in a single request.

### liquidatable

list accounts currently eligible for liquidation.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## delegations | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "delegations"` is used to list a user's active HYPE staking delegations.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "delegations", "user": "..."}`.
- Returns an empty array when the user has no active delegations.
- For staking totals use [`delegatorSummary`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-summary); for the delegate / undelegate event history behind them, use [`delegatorHistory`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-history).

Returns a user's active HYPE staking delegations - one entry per validator - with the delegated amount and the timestamp until which each delegation is locked. Use delegatorSummary for aggregate totals and delegatorHistory for the underlying event sequence.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"delegations"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "delegations",
    "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "delegations",
    user: "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
  }),
});

const delegations = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "delegations",
        "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    },
)

delegations = response.json()
```

## Response

An array of delegation objects, one per validator. Empty when the user has no active delegations.

```json
[
  {
    "validator": "0x420a4ed7b6bb361da586868adec2f2bb9ab75e66",
    "amount": "305.27602401",
    "lockedUntilTimestamp": 1768061059908
  },
  {
    "validator": "0x497beec89958848126c2ea65934ce430e1410ad2",
    "amount": "217.26663138",
    "lockedUntilTimestamp": 1753148985995
  }
]
```

### Field descriptions

> **Note:** `amount` is returned as a **decimal string**, preserving upstream precision. Do not parse it as a float.

| Field | Type | Description |
| --- | --- | --- |
| `validator` | `string` | Validator address the stake is delegated to. |
| `amount` | `string` | Delegated HYPE amount. |
| `lockedUntilTimestamp` | `int` | Millisecond timestamp until which the delegation is locked (undelegation is subject to this lock). |

{/* generated:hl-linkhub-start */}

## Related endpoints


### delegatorHistory

reconstruct the sequence of HYPE staking events behind the totals shown in delegatorSummary.

### delegatorRewards

fetch a user’s current HYPE staking position.

### delegatorSummary

get a one-shot snapshot of a user's HYPE staking position for dashboards and portfolio overviews.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## delegatorHistory | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "delegatorHistory"` is used to reconstruct the sequence of HYPE staking events behind the totals shown in delegatorSummary.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "delegatorHistory", "user": "..."}`.
- For totals (delegated, undelegated, pending withdrawal sums), use [`delegatorSummary`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-summary).
- For accrued staking and commission rewards, use [`delegatorRewards`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-rewards).

Returns a user’s HYPE staking event history: every delegate, undelegate, staking-account deposit, and unstake withdrawal, ordered by `time`. Use this to reconstruct the sequence behind the totals shown in [delegatorSummary](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-summary).

User-keyed. Each entry carries a `delta` whose discriminator describes the event variant.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"delegatorHistory"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "delegatorHistory",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "delegatorHistory",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const events = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "delegatorHistory",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

events = response.json()
```

## Response

An array of staking event objects.

```json
[
  {
    "time": 1735689600000,
    "hash": "0x6b9c0a4a3d54b0d4d6b1a0c4d8c9e7f2b6e5d3c2a1f0e9d8c7b6a5f4e3d2c1b0a",
    "delta": {
      "delegate": {
        "validator": "0x5ac99df645f3414876c816caa18b2d234024b487",
        "amount": "1000.5",
        "isUndelegate": false
      }
    }
  }
]
```

### Field descriptions

> **Note:** `delta.delegate.amount` is returned as a **decimal string**, preserving upstream precision. Do not parse it as a float.

| Field | Type | Description |
| --- | --- | --- |
| `time` | `int` | Unix timestamp in milliseconds when the event was applied. |
| `hash` | `string` | L1 transaction hash that produced the event. |
| `delta` | `object` | Event-specific payload. The example above shows a `delegate` variant; other variants observed in the wild include `cDeposit` (staking-account deposit) and `withdrawal` (unstake withdrawal). The shape changes per variant. |
| `delta.delegate.validator` | `string` | Validator address the delegation targets. |
| `delta.delegate.amount` | `string` | HYPE amount delegated or undelegated. |
| `delta.delegate.isUndelegate` | `boolean` | `true` for an undelegate, `false` for a delegate. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### delegatorRewards

fetch a user’s current HYPE staking position.

### delegatorSummary

get a one-shot snapshot of a user's HYPE staking position for dashboards and portfolio overviews.

### delegations

list a user's active HYPE staking delegations.

### fundingHistory

fetch a coin’s historical funding rates and premiums over a time window for funding analytics and basis strategies.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## delegatorRewards | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "delegatorRewards"` is used to fetch a user’s current HYPE staking position.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "delegatorSummary", "user": "..."}`.
- For the sequence of delegation events behind these totals, use [`delegatorHistory`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-history).
- For accrued staking and commission rewards, use [`delegatorRewards`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-rewards).

Returns a single user’s accrued HYPE staking rewards: one entry per accrual, with the timestamp, the source (delegation reward versus validator commission), and the amount.

User-keyed. Use this for tax reports, reward attribution dashboards, and validator P&L; use [delegatorHistory](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-history) for the underlying delegate / undelegate events and [delegatorSummary](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-summary) for current totals.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"delegatorRewards"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "delegatorRewards",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "delegatorRewards",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const rewards = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "delegatorRewards",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

rewards = response.json()
```

## Response

An array of reward entries.

```json
[
  {
    "time": 1735689600000,
    "source": "delegation",
    "totalAmount": "1.5234"
  },
  {
    "time": 1735776000000,
    "source": "commission",
    "totalAmount": "0.8791"
  }
]
```

### Field descriptions

> **Note:** `totalAmount` is returned as a **decimal string**, preserving upstream precision. Do not parse it as a float.

| Field | Type | Description |
| --- | --- | --- |
| `time` | `int` | Unix timestamp in milliseconds when the reward accrued. |
| `source` | `string` | Reward source. `"delegation"` for rewards earned by delegating to a validator; `"commission"` for commission earned as a validator on others' delegations. |
| `totalAmount` | `string` | Reward amount in HYPE. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### delegatorHistory

reconstruct the sequence of HYPE staking events behind the totals shown in delegatorSummary.

### delegatorSummary

get a one-shot snapshot of a user's HYPE staking position for dashboards and portfolio overviews.

### delegations

list a user's active HYPE staking delegations.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## delegatorSummary | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "delegatorSummary"` is used to get a one-shot snapshot of a user's HYPE staking position for dashboards and portfolio overviews.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "delegatorSummary", "user": "..."}`.
- For the sequence of delegation events behind these totals, use [`delegatorHistory`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-history).
- For accrued staking and commission rewards, use [`delegatorRewards`](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-rewards).

Returns a single user’s HYPE staking summary: the amount currently delegated, the amount sitting undelegated in the staking account, the total of any pending withdrawals, and how many such withdrawals are pending.

User-keyed. Use this for a one-shot snapshot; for the underlying sequence of delegate / undelegate / deposit / withdrawal events, use [delegatorHistory](https://goldrush.dev/docs/api-reference/hyperliquid-info/delegator-history).

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"delegatorSummary"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "delegatorSummary",
    "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "delegatorSummary",
    user: "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
  }),
});

const summary = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "delegatorSummary",
        "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    },
)

summary = response.json()
```

## Response

```json
{
  "delegated": "1500.50",
  "undelegated": "250.00",
  "totalPendingWithdrawal": "100.00",
  "nPendingWithdrawals": 2
}
```

### Field descriptions

> **Note:** `delegated`, `undelegated`, and `totalPendingWithdrawal` are returned as **decimal strings**. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `delegated` | `string` | HYPE currently delegated to validators. |
| `undelegated` | `string` | HYPE in the staking account but not delegated. |
| `totalPendingWithdrawal` | `string` | Sum of HYPE in any in-flight unstake withdrawals. |
| `nPendingWithdrawals` | `int` | Count of in-flight unstake withdrawals. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### delegatorHistory

reconstruct the sequence of HYPE staking events behind the totals shown in delegatorSummary.

### delegatorRewards

fetch a user’s current HYPE staking position.

### delegations

list a user's active HYPE staking delegations.

### userPnlSummary

fetch one aggregate PnL summary for a wallet - realized PnL, win/loss rate, volume, fees, funding, active days, and traded pairs.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## exchangeStatus | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "exchangeStatus"` is used to fetch the current exchange operational status.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "exchangeStatus"}`.
- `specialStatuses` is `null` under normal operation and carries status flags only when the exchange is in a special state.
- This is a global, non-user-keyed type; `time` reflects the exchange's current clock.

Returns the current operational status of the exchange. Under normal operation specialStatuses is null; a non-null value signals that the exchange is in a special state. The time field is the exchange's current timestamp, useful for detecting clock skew or a stalled feed.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"exchangeStatus"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "exchangeStatus"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "exchangeStatus",
  }),
});

const status = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "exchangeStatus"},
)

status = response.json()
```

## Response

A single object describing the exchange status.

```json
{
  "specialStatuses": null,
  "time": 1784799315619
}
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `specialStatuses` | `object | null` | Special status flags. `null` under normal operation; a non-null object is present only when the exchange is in a special state. |
| `time` | `int` | Current exchange timestamp in milliseconds since Unix epoch. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### liquidatable

list accounts currently eligible for liquidation.

### marginTable

fetch the margin-tier (leverage-bracket) table for a given margin table id.

### maxBuilderFee

fetch the maximum builder fee a user has approved for a given builder.

### maxMarketOrderNtls

fetch the maximum market-order notional for each leverage bucket.

### validatorL1Votes

validatorL1Votes endpoint.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## extraAgents | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "extraAgents"` is used to list a user's approved API-agent wallets.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "extraAgents", "user": "..."}`.
- Returns an empty array when the user has approved no agent wallets.
- Each agent's `validUntil` is a millisecond timestamp after which the API wallet's approval expires.

Returns the extra API-agent wallets (also called API wallets) that a master account has approved. Agent wallets can sign actions on behalf of the master without holding funds themselves; each entry carries the agent's name, address, and approval expiry.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"extraAgents"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "extraAgents",
    "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "extraAgents",
    user: "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
  }),
});

const agents = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "extraAgents",
        "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    },
)

agents = response.json()
```

## Response

An array of agent-wallet objects. Empty when the user has approved no agents.

```json
[
  {
    "name": "Agent 1",
    "address": "0x77deafccbb9ddbc5da3e8f5d066624265bdb2a74",
    "validUntil": 1775216111330
  },
  {
    "name": "Agent 2",
    "address": "0xfff6471954ad1bbe70f18e2fea9928fd7aba31ad",
    "validUntil": 1782653334723
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `name` | `string` | Human-readable label assigned to the agent (API) wallet. |
| `address` | `string` | The agent wallet address (0x-prefixed hex). |
| `validUntil` | `int` | Millisecond timestamp after which the agent's approval expires. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### subAccounts

fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

### userAbstraction

fetch a user's account-abstraction mode.

### userFees

fetch a user's fee schedule and recent daily volume.

### userRateLimit

fetch a user's API rate-limit usage and cap.

### userRole

fetch a user's account role.

### userToMultiSigSigners

fetch the authorized signers for a multi-sig user.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## frontendOpenOrders | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "frontendOpenOrders"` is used to fetch a user's currently open orders enriched with frontend metadata.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "frontendOpenOrders", "user": "..."}`.
- Use `frontendOpenOrders` instead of `openOrders` when you need the trigger metadata and human-readable order type - exactly what the Hyperliquid web UI displays.

Returns a single user’s currently open orders, enriched with the **frontend-only metadata** the Hyperliquid web UI uses: TP/SL trigger info, whether the order is a position-level TP/SL, reduce-only flag, and the human-readable order type.

User-keyed. Updated on every order placement, cancellation, or fill.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"frontendOpenOrders"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `dex` | `string` | No | HIP-3 builder DEX identifier. Empty string returns orders on the canonical Hyperliquid perp DEX. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "frontendOpenOrders",
    "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    "dex": ""
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "frontendOpenOrders",
    user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    dex: "",
  }),
});

const orders = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "frontendOpenOrders",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "dex": "",
    },
)

orders = response.json()
```

## Response

An array of open orders. Each order object includes the standard `openOrders` fields plus the `frontend*` enrichment fields.

```json
[
  {
    "coin": "ETH",
    "side": "B",
    "limitPx": "3300.0",
    "sz": "0.5",
    "oid": 95012345,
    "timestamp": 1735689600000,
    "triggerCondition": "N/A",
    "isTrigger": false,
    "triggerPx": "0.0",
    "children": [],
    "isPositionTpsl": false,
    "reduceOnly": false,
    "orderType": "Limit",
    "origSz": "0.5",
    "tif": "Gtc",
    "cloid": null
  },
  {
    "coin": "ETH",
    "side": "A",
    "limitPx": "3800.0",
    "sz": "2.5",
    "oid": 95012346,
    "timestamp": 1735689700000,
    "triggerCondition": "Mark price >= 3800.0",
    "isTrigger": true,
    "triggerPx": "3800.0",
    "children": [],
    "isPositionTpsl": true,
    "reduceOnly": true,
    "orderType": "Take Profit Market",
    "origSz": "2.5",
    "tif": null,
    "cloid": null
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | Asset symbol. |
| `side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `limitPx` | `string` | Limit price. |
| `sz` | `string` | Remaining order size. |
| `oid` | `int` | Numeric order ID. |
| `timestamp` | `int` | Order placement time in milliseconds since Unix epoch. |
| `triggerCondition` | `string` | Human-readable trigger condition. `"N/A"` for non-trigger orders. |
| `isTrigger` | `boolean` | `true` for stop-loss, take-profit, and other conditional orders. |
| `triggerPx` | `string` | Trigger price for conditional orders. `"0.0"` for limits. |
| `children` | `array` | Child orders attached to this parent (e.g. bracket orders). |
| `isPositionTpsl` | `boolean` | `true` if this is a position-level TP/SL (closes the entire position when triggered). |
| `reduceOnly` | `boolean` | `true` if this order can only reduce, not increase, position size. |
| `orderType` | `string` | Human-readable order type - `"Limit"`, `"Take Profit Market"`, `"Stop Limit"`, etc. |
| `origSz` | `string` | Original order size before any partial fills. |
| `tif` | `string` | Time-in-force - `"Gtc"`, `"Ioc"`, `"Alo"`, or `null` for trigger orders. |
| `cloid` | `string` | Client order ID (null if not provided at placement). |

{/* generated:hl-linkhub-start */}

## Related endpoints


### openOrders

list a user's resting open orders.

### historicalOrders

fetch a user's recent orders - both open and finalized - each with its current status and status timestamp.

### orderStatus

look up the status of a single order for a user, by order id (oid) or client order id (cloid).

### perpsAtOpenInterestCap

list the perp assets currently at their open-interest cap.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## fundingHistory | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "fundingHistory"` is used to fetch a coin’s historical funding rates and premiums over a time window for funding analytics and basis strategies.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "fundingHistory", "coin": "..."}`.
- Each response contains at most 500 entries per call.
- This is market-wide funding history for a coin. For a single wallet’s actual funding payments, use [userFunding](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-funding) instead.
- Hyperliquid retains funding history natively back to launch.
- For the current funding rate alongside live market context, use [metaAndAssetCtxs](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta-and-asset-ctxs).

Returns the sequence of applied funding intervals for a single coin within a `[startTime, endTime]` window. Each entry carries the funding rate that was applied and the mark-vs-oracle premium at that time. Use it for funding-rate charts, basis/carry analytics, and historical funding P&L modeling.

This is a global, non-user-keyed type. Page through time by advancing `startTime`.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"fundingHistory"`. |
| `coin` | `string` | Yes | The asset symbol, e.g. `"BTC"`. HIP-3 markets use the deployer-prefixed form. |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound for the window. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "fundingHistory",
    "coin": "BTC",
    "startTime": 1735689600000,
    "endTime": 1735776000000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "fundingHistory",
    coin: "BTC",
    startTime: 1735689600000,
    endTime: 1735776000000,
  }),
});

const history = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "fundingHistory",
        "coin": "BTC",
        "startTime": 1735689600000,
        "endTime": 1735776000000,
    },
)

history = response.json()
```

## Response

An array of funding-interval objects, oldest first.

```json
[
  {
    "coin": "BTC",
    "fundingRate": "0.0000054021",
    "premium": "-0.0004567829",
    "time": 1735693200000
  }
]
```

### Field descriptions

> **Note:** `fundingRate` and `premium` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | The asset the funding interval is for - echoes the request `coin`. |
| `fundingRate` | `string` | The funding rate applied for this interval (decimal string, e.g. `"0.0000125"`). |
| `premium` | `string` | Mark-vs-oracle premium at the time the funding was computed (decimal string). |
| `time` | `int` | Unix timestamp in milliseconds when the funding interval was applied. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### allMids

fetch the current mid price for every actively traded asset in a single call.

### candleSnapshot

fetch historical OHLCV candles for a coin and interval over a time window for charting and backtesting.

### l2Book

fetch an aggregated Level-2 order book snapshot for a single coin - bids and asks as price, size, and order-count levels.

### l2BookDiffSnapshot

fetch a full-depth L2 order book snapshot for one coin, with height, epoch, and seq to bootstrap the l2BookDiff2 stream.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## historicalOrders | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "historicalOrders"` is used to fetch a user's recent orders - both open and finalized - each with its current status and status timestamp.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "historicalOrders", "user": "0x..."}`.
- Returns the user's most recent orders across every coin, open and finalized (filled, canceled, and other terminal states). For only the currently-resting orders, use `openOrders` or `frontendOpenOrders`.
- `limit` caps the number returned; the default and maximum is 2000.

Returns an array of the user's recent orders, newest-relevant first, each wrapped with the order's terminal-or-current status and the millisecond timestamp that status was set. Use it to reconstruct recent order history, audit fills/cancels, or drive an activity view.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"historicalOrders"`. |
| `user` | `string` | Yes | The account address in 42-character hex format, e.g. `"0x0000000000000000000000000000000000000000"`. |
| `limit` | `int` | No | Maximum number of orders to return. Defaults to `2000`; values above `2000` are capped at `2000`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "historicalOrders",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "limit": 100
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "historicalOrders",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    limit: 100,
  }),
});

const orders = await response.json();
for (const { order, status, statusTimestamp } of orders) {
  console.log(order.coin, order.side, order.oid, status, statusTimestamp);
}
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "historicalOrders", "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b", "limit": 100},
)

for entry in response.json():
    o = entry["order"]
    print(o["coin"], o["side"], o["oid"], entry["status"], entry["statusTimestamp"])
```

## Response

An array of order entries. Each element pairs the `order` with its `status` and the millisecond timestamp that status took effect.

```json
[
  {
    "order": {
      "coin": "POPCAT",
      "side": "A",
      "limitPx": "0.043668",
      "sz": "16812.0",
      "oid": 513957677284,
      "timestamp": 1786384269962,
      "triggerCondition": "N/A",
      "isTrigger": false,
      "triggerPx": "0.0",
      "children": [],
      "isPositionTpsl": false,
      "reduceOnly": false,
      "orderType": "Limit",
      "origSz": "16812.0",
      "tif": "Alo",
      "cloid": null
    },
    "status": "canceled",
    "statusTimestamp": 1786384274789
  }
]
```

### Field descriptions

> **Note:** `limitPx`, `sz`, `origSz`, and `triggerPx` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `[]` | `array` | One entry per order. |
| `[].order` | `object` | The order.  __RESPONSE_ROW__coin	string	Asset symbol, e.g. `"BTC"`, `"POPCAT"`, or `"@107"` for spot. __RESPONSE_ROW__[].side	string	`"B"` = bid (buy), `"A"` = ask (sell). __RESPONSE_ROW__[].limitPx	string	Limit price (decimal string). __RESPONSE_ROW__[].sz	string	Remaining size (decimal string). __RESPONSE_ROW__[].origSz	string	Original order size (decimal string). __RESPONSE_ROW__[].oid	int	Order id. __RESPONSE_ROW__[].cloid	string \| null	Client order id (hex) if one was supplied, else `null`. __RESPONSE_ROW__[].timestamp	int	Order creation time (ms since epoch). __RESPONSE_ROW__[].orderType	string	e.g. `"Limit"`, `"Stop Market"`, `"Stop Limit"`. __RESPONSE_ROW__[].tif	string \| null	Time-in-force, e.g. `"Alo"`, `"Gtc"`, `"Ioc"`. __RESPONSE_ROW__[].reduceOnly	bool	Whether the order is reduce-only. __RESPONSE_ROW__[].isTrigger	bool	Whether it is a trigger (stop/take-profit) order. __RESPONSE_ROW__[].triggerCondition	string	Human-readable trigger condition, or `"N/A"`. __RESPONSE_ROW__[].triggerPx	string	Trigger price (decimal string). __RESPONSE_ROW__[].isPositionTpsl	bool	Whether it is a position-level TP/SL. __RESPONSE_ROW__[].children	array	Child orders (e.g. TP/SL legs) attached to this order. The order's current or terminal status. Hyperliquid defines many values; observed examples include `"open"`, `"filled"`, `"canceled"`, `"selfTradeCanceled"`, and `"iocCancelRejected"`. |
| `statusTimestamp` | `int` | Millisecond timestamp when the status took effect. |



{/* generated:hl-linkhub-start */}

## Related endpoints


### frontendOpenOrders

fetch a user's currently open orders enriched with frontend metadata.

### openOrders

list a user's resting open orders.

### orderStatus

look up the status of a single order for a user, by order id (oid) or client order id (cloid).

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## l2BookDiffSnapshot | Hyperliquid Info API

**Processing:** Realtime

The Hyperliquid info endpoint with `type: "l2BookDiffSnapshot"` is used to fetch a full-depth L2 order book snapshot for one coin, carrying the `height`, `epoch`, and per-coin `seq` needed to bootstrap and align the **`l2BookDiff2`** diff stream.

> **Note:** - GoldRush-native. `l2BookDiffSnapshot` is not a `POST api.hyperliquid.xyz/info` method - it is served only by the GoldRush endpoint.
- **Bootstrap for **`l2BookDiff2`**.** That WebSocket stream is diff-only; this endpoint provides the initial book to seed from, plus the `height`/`epoch`/`seq` to align the diffs onto it.
- **Full depth.** Unlike the 20-level **`l2Book`** snapshot, this returns the complete resting book for the coin so your reconstruction starts from a complete state.
- The snapshot already reflects every diff **up to and including** its own `height` (it is taken after that block is applied), so discard any diff at or below it.

Returns a point-in-time, full-depth aggregated order book for one `coin` - two arrays of price levels (bids first, then asks), each carrying price, resting size, and order count - together with the `height`, `epoch`, and per-coin `seq` that tie the snapshot to the `l2BookDiff2` stream.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"l2BookDiffSnapshot"`. |
| `coin` | `string` | Yes | The asset symbol, e.g. `"BTC"`. For HIP-3 markets use the deployer-prefixed form; for spot use the pair symbol or `@`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "l2BookDiffSnapshot",
    "coin": "HYPE"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "l2BookDiffSnapshot",
    coin: "HYPE",
  }),
});

const snap = await response.json();
const { height, epoch, seq } = snap;
const [bids, asks] = snap.levels;
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "l2BookDiffSnapshot", "coin": "HYPE"},
)

snap = response.json()
height, epoch, seq = snap["height"], snap["epoch"], snap["seq"]
bids, asks = snap["levels"]
```

## Response

A single JSON object. `levels` is a two-element array: element 0 is the bid side (descending price), element 1 is the ask side (ascending price). Each level is a `{px, sz, n}` object.

```json
{
  "coin": "HYPE",
  "time": 1786379674524,
  "height": 1105178185,
  "epoch": "466bf60f-bb7a-4591-89a3-a2660234fef5",
  "seq": 3669031,
  "levels": [
    [
      { "px": "54.208", "sz": "153.23", "n": 6 },
      { "px": "54.204", "sz": "48.81", "n": 1 }
    ],
    [
      { "px": "54.214", "sz": "12.34", "n": 2 },
      { "px": "54.216", "sz": "80.71", "n": 3 }
    ]
  ]
}
```

### Field descriptions

> **Note:** `px` and `sz` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | The asset the book is for - echoes the request `coin`. |
| `time` | `int` | Snapshot timestamp in milliseconds since Unix epoch. |
| `height` | `int` | HyperCore block height the snapshot was taken at. Discard any `l2BookDiff2` batch whose `block_height` is ≤ this value. |
| `epoch` | `string` | Server generation (UUID). Must match the `epoch` on the `l2BookDiff2` batches you apply; a different `epoch` means the stream reset and you should re-fetch. |
| `seq` | `int` | The per-coin sequence this snapshot is aligned to. The first `l2BookDiff2` diff you apply for this coin should have `prev_seq == seq`. |
| `levels` | `array>` | Two-element array: `levels[0]` are bids (highest price first), `levels[1]` are asks (lowest price first). Full depth. |
| `levels.px` | `string` | Price of the level. |
| `levels.sz` | `string` | Total resting size at this price. |
| `levels.n` | `int` | Number of individual orders aggregated into this level. |

## Bootstrapping the l2BookDiff2 stream

Use this snapshot to seed a local book, then keep it current with the **`l2BookDiff2`** WebSocket stream:

1. Subscribe to `l2BookDiff2` for your coin(s) and start buffering `Updates`.
2. Fetch this snapshot; note `height`, `epoch`, and `seq`.
3. Drop any buffered batch whose `block_height` ≤ `height`.
4. Confirm each remaining batch's `epoch` equals this snapshot's `epoch` (else re-fetch).
5. Apply diffs in order - the first for the coin has `prev_seq == seq`.
6. Keep checking per-coin `prev_seq` continuity; on a gap or `epoch` change, re-fetch and re-bootstrap.

{/* generated:hl-linkhub-start */}

## Related endpoints


### l2Book

fetch an aggregated Level-2 order book snapshot for a single coin - bids and asks as price, size, and order-count levels.

### candleSnapshot

fetch historical OHLCV candles for a coin and interval over a time window for charting and backtesting.

### allMids

fetch the current mid price for every actively traded asset in a single call.

### fundingHistory

fetch a coin’s historical funding rates and premiums over a time window for funding analytics and basis strategies.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

---

## l2Book | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "l2Book"` is used to fetch an aggregated Level-2 order book snapshot for a single coin - bids and asks as price, size, and order-count levels.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "l2Book", "coin": "..."}`.
- Returns at most 20 levels per side.
- For a continuous push stream instead of polling snapshots, subscribe to the [WebSocket API `l2Book`](https://goldrush.dev/docs/api-reference/hyperliquid-websocket/l2-book) channel (optional wildcard `coin`) or the GoldRush-native [`l2BookDiff`](https://goldrush.dev/docs/api-reference/hyperliquid-websocket/l2-book-diff) for incremental updates.

Returns a point-in-time aggregated order book for one `coin`: two arrays of price levels (bids first, then asks), each level carrying the price, the total resting size at that price, and the number of orders comprising it. Use it for a one-shot depth snapshot, spread checks, or seeding a book before switching to a diff stream.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"l2Book"`. |
| `coin` | `string` | Yes | The asset symbol, e.g. `"BTC"`. For HIP-3 markets use the deployer-prefixed form (e.g. `"xyz:GOLD"`); for spot use the pair symbol or `@`. |
| `nSigFigs` | `int` | No | Number of significant figures to aggregate price levels to (`2`-`5`). Omit or pass `null` for full precision. |
| `mantissa` | `int` | No | Optional mantissa for price-level bucketing. Only valid when `nSigFigs` is `5`. Omit or pass `null` for the default. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "l2Book",
    "coin": "BTC"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "l2Book",
    coin: "BTC",
  }),
});

const book = await response.json();
const [bids, asks] = book.levels;
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "l2Book", "coin": "BTC"},
)

book = response.json()
bids, asks = book["levels"]
```

## Response

A single JSON object. `levels` is a two-element array: element 0 is the bid side (descending price), element 1 is the ask side (ascending price). Each level is a `{px, sz, n}` object.

```json
{
  "coin": "BTC",
  "time": 1780940795265,
  "levels": [
    [
      { "px": "63405.0", "sz": "4.43382", "n": 36 },
      { "px": "63404.0", "sz": "3.38588", "n": 44 }
    ],
    [
      { "px": "63406.0", "sz": "0.00347", "n": 3 },
      { "px": "63407.0", "sz": "0.00017", "n": 1 }
    ]
  ]
}
```

### Field descriptions

> **Note:** `px` and `sz` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | The asset the book is for - echoes the request `coin`. |
| `time` | `int` | Snapshot timestamp in milliseconds since Unix epoch. |
| `levels` | `array>` | Two-element array: `levels[0]` are bids (sorted highest price first), `levels[1]` are asks (sorted lowest price first). Each side defaults to up to 20 aggregated levels. |
| `levels.px` | `string` | Price of the level. |
| `levels.sz` | `string` | Total resting size at this price. |
| `levels.n` | `int` | Number of individual orders aggregated into this level. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### l2BookDiffSnapshot

fetch a full-depth L2 order book snapshot for one coin, with height, epoch, and seq to bootstrap the l2BookDiff2 stream.

### allMids

fetch the current mid price for every actively traded asset in a single call.

### candleSnapshot

fetch historical OHLCV candles for a coin and interval over a time window for charting and backtesting.

### fundingHistory

fetch a coin’s historical funding rates and premiums over a time window for funding analytics and basis strategies.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-06-16_

{/* generated:hl-footer-end */}

---

## l4BookSnapshot | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "l4BookSnapshot"` is used to fetch a full **order-level (L4)** order book snapshot for one coin - every resting order, not aggregated price levels - carrying the `height`, `epoch`, and per-coin `seq` needed to bootstrap and align the **`l4BookUpdates`** diff stream.

> **Note:** - GoldRush-native. `l4BookSnapshot` is not a `POST api.hyperliquid.xyz/info` method - it is served only by the GoldRush endpoint.
- **Bootstrap for **`l4BookUpdates`**.** That WebSocket stream is diff-only; this endpoint provides the initial order-level book to seed from, plus the `height`/`epoch`/`seq` to align the diffs onto it.
- **Order-level.** Unlike the aggregated **`l2BookDiffSnapshot`**, each entry is an **individual order** (`user`, `oid`, `side`, `sz`, `tif`, trigger metadata), enabling queue-position reconstruction and per-trader flow attribution.
- **Perps only.** No spot or prediction-market assets.
- The snapshot already reflects every diff **up to and including** its own `height` (it is taken after that block is applied), so discard any diff at or below it.

Returns a point-in-time, full order-level book for one `coin` - two arrays of individual orders (bids first, then asks, each in queue order at its price) - together with the `height`, `epoch`, and per-coin `seq` that tie the snapshot to the `l4BookUpdates` stream.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"l4BookSnapshot"`. |
| `coin` | `string` | Yes | The perp asset symbol, e.g. `"BTC"`. For HIP-3 markets use the deployer-prefixed form. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "l4BookSnapshot",
    "coin": "BTC"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "l4BookSnapshot",
    coin: "BTC",
  }),
});

const snap = await response.json();
const { height, epoch, seq } = snap;
const [bids, asks] = snap.levels;
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "l4BookSnapshot", "coin": "BTC"},
)

snap = response.json()
height, epoch, seq = snap["height"], snap["epoch"], snap["seq"]
bids, asks = snap["levels"]
```

## Response

A single JSON object. `levels` is a two-element array: element 0 is the bid side, element 1 is the ask side. Each entry is an **individual order** (not an aggregated level), in queue order at its price.

```json
{
  "coin": "BTC",
  "time": 1778865761968,
  "height": 997719816,
  "epoch": "466bf60f-bb7a-4591-89a3-a2660234fef5",
  "seq": 4229977,
  "levels": [
    [
      {
        "user": "0xa62b923a112d50d03e1e096bbd53422490dac104",
        "coin": "BTC",
        "side": "B",
        "limitPx": "79242",
        "sz": "0.74831",
        "oid": 427632406005,
        "timestamp": 1778865761305,
        "triggerCondition": "N/A",
        "isTrigger": false,
        "triggerPx": "0.0",
        "isPositionTpsl": false,
        "reduceOnly": false,
        "orderType": "Limit",
        "tif": "Alo",
        "cloid": "0x00000000000000000000019e2c8b7d66"
      }
    ],
    [
      {
        "user": "0xfcf104006bfff47695c1dc21dad3e9de1e72098e",
        "coin": "BTC",
        "side": "A",
        "limitPx": "79250",
        "sz": "0.2961",
        "oid": 427632406032,
        "timestamp": 1778865761305,
        "triggerCondition": "N/A",
        "isTrigger": false,
        "triggerPx": "0.0",
        "isPositionTpsl": false,
        "reduceOnly": false,
        "orderType": "Limit",
        "tif": "Gtc",
        "cloid": null
      }
    ]
  ]
}
```

### Field descriptions

> **Note:** `limitPx`, `sz`, and `triggerPx` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | The asset the book is for - echoes the request `coin`. |
| `time` | `int` | Snapshot timestamp in milliseconds since Unix epoch. |
| `height` | `int` | HyperCore block height the snapshot was taken at. Discard any `l4BookUpdates` batch whose `block_height` is ≤ this value. |
| `epoch` | `string` | Server generation (UUID). Must match the `epoch` on the `l4BookUpdates` batches you apply; a different `epoch` means the stream reset and you should re-fetch. |
| `seq` | `int` | The per-coin sequence this snapshot is aligned to. The first `l4BookUpdates` entry you apply for this coin should have `prev_seq == seq`. |
| `levels` | `array>` | Two-element array: `levels[0]` are bids, `levels[1]` are asks. Each side is an array of individual **Order** objects (see below), in queue order at their respective price. |

### Order object

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | Wallet address that owns the order. |
| `coin` | `string` | Asset symbol. |
| `side` | `string` | `"B"` for bid, `"A"` for ask. |
| `limitPx` | `string` | Limit price (decimal string). |
| `sz` | `string` | Resting size (decimal string, base units). |
| `oid` | `int` | Hyperliquid order id - stable for the lifetime of the order. |
| `timestamp` | `int` | Order-placement timestamp in HyperCore milliseconds. |
| `triggerCondition` | `string` | Trigger condition string (e.g. `"N/A"` for plain limit orders). |
| `isTrigger` | `boolean` | True if this is a stop / take-profit trigger order. |
| `triggerPx` | `string` | Trigger price (decimal string, `"0.0"` for non-trigger orders). |
| `isPositionTpsl` | `boolean` | True if this is a position-level TP/SL. |
| `reduceOnly` | `boolean` | True if the order is flagged reduce-only. |
| `orderType` | `string` | Hyperliquid order type (e.g. `"Limit"`). |
| `tif` | `string` | Time-in-force (e.g. `"Alo"`, `"Gtc"`, `"Ioc"`). |
| `cloid` | `string | null` | Client-supplied order id (hex string), or `null` if none was provided. |

## Bootstrapping the l4BookUpdates stream

Use this snapshot to seed a local order-level book, then keep it current with the **`l4BookUpdates`** WebSocket stream:

1. Subscribe to `l4BookUpdates` for your coin(s) and start buffering `Updates`.
2. Fetch this snapshot; note `height`, `epoch`, and `seq`.
3. Drop any buffered batch whose `block_height` ≤ `height`.
4. Confirm each remaining batch's `epoch` equals this snapshot's `epoch` (else re-fetch).
5. Apply diffs in order - the first for the coin has `prev_seq == seq`. Insert (`new`), resize (`update`), or delete (`remove`) each order by `oid`.
6. Keep checking per-coin `prev_seq` continuity; on a gap or `epoch` change, re-fetch and re-bootstrap.

{/* generated:hl-linkhub-start */}

## Related endpoints


### l2BookDiffSnapshot

fetch a full-depth L2 order book snapshot for one coin, with height, epoch, and seq to bootstrap the l2BookDiff2 stream.

### candleSnapshot

fetch historical OHLCV candles for a coin and interval over a time window for charting and backtesting.

### l2Book

fetch an aggregated Level-2 order book snapshot for a single coin - bids and asks as price, size, and order-count levels.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

---

## leadingVaults | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "leadingVaults"` is used to list the vaults a user leads.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "leadingVaults", "user": "..."}`.
- Returns one entry per vault the user leads (manages); the array is empty when the user leads none.
- Each entry gives the vault's address and name; use [vaultDetails](https://goldrush.dev/docs/api-reference/hyperliquid-info/vault-details) for the full breakdown.
- User-keyed by the leader address.

Returns the vaults that a user leads (manages), as an array of {vaultAddress, name} entries. The array is empty when the user does not lead any vault.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"leadingVaults"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "leadingVaults",
    "user": "0x677d831aef5328190852e24f13c46cac05f984e7"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "leadingVaults",
    user: "0x677d831aef5328190852e24f13c46cac05f984e7",
  }),
});

const vaults = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "leadingVaults",
        "user": "0x677d831aef5328190852e24f13c46cac05f984e7",
    },
)

vaults = response.json()
```

## Response

An array of vaults the user leads. Empty when the user leads none.

```json
[
  {
    "vaultAddress": "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303",
    "name": "Hyperliquidity Provider (HLP)"
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `[n]` | `object` | A vault the user leads. |
| `[n].vaultAddress` | `string` | Vault contract address (0x-prefixed hex). |
| `[n].name` | `string` | Vault name. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userVaultEquities

fetch a user's locked vault equity positions across all vaults they have deposited into.

### vaultDetails

fetch detailed information for a specific vault.

### vaultSummaries

list summary information for every vault on the platform.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## liquidatable | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "liquidatable"` is used to list accounts currently eligible for liquidation.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "liquidatable"}`.
- Global, non-user-keyed: it takes no `user` field and returns the accounts that are liquidatable at the instant of the call.
- The array is frequently empty - eligible accounts are typically liquidated the moment they cross the threshold, so a point-in-time snapshot rarely catches an open candidate.

Returns the set of accounts currently eligible for liquidation across HyperCore. This is a global, non-user-keyed type: a single snapshot shared across all callers. Because eligible accounts are liquidated almost immediately, the result is usually an empty array.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"liquidatable"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "liquidatable"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "liquidatable",
  }),
});

const liquidatable = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "liquidatable"},
)

liquidatable = response.json()
```

## Response

An array of liquidatable-account entries. The array is empty when no account is currently eligible for liquidation, which is the common case.

```json
[]
```

### Field descriptions

> **Note:** Upstream Hyperliquid does not publish a stable, fully-specified per-entry schema for `liquidatable`, and the result is empty in the vast majority of calls. When the array is non-empty, each entry identifies an at-risk account by its wallet address; treat any additional per-entry fields defensively.

| Field | Type | Description |
| --- | --- | --- |
| `[n].user` | `string` | Wallet address (0x-prefixed hex) of an account currently eligible for liquidation. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### borrowLendUserState

monitor a wallet’s current borrow/lend positions and liquidation risk (account health) in a single call.

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

### exchangeStatus

fetch the current exchange operational status.

### marginTable

fetch the margin-tier (leverage-bracket) table for a given margin table id.

### maxBuilderFee

fetch the maximum builder fee a user has approved for a given builder.

### maxMarketOrderNtls

fetch the maximum market-order notional for each leverage bucket.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## marginTable | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Batch

The Hyperliquid info endpoint with `type: "marginTable"` is used to fetch the margin-tier (leverage-bracket) table for a given margin table id.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "marginTable", "id": ...}`.
- `id` is the `marginTableId` referenced by a [meta](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta) universe entry (`universe[].marginTableId`), also listed inline in `meta.marginTables`.
- `marginTiers` describes how the maximum leverage steps down as a position's notional grows.

Returns a single margin-tier table by id. Each tier gives the lower notional bound at which it applies and the maximum leverage allowed within that tier, so maximum leverage decreases as a position's notional grows. This is the standalone lookup for the same tables embedded in meta.marginTables.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"marginTable"`. |
| `id` | `int` | Yes | The margin table id - the `marginTableId` from a `meta` universe entry (or an id listed in `meta.marginTables`). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "marginTable",
    "id": 56
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "marginTable",
    id: 56,
  }),
});

const marginTable = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "marginTable", "id": 56},
)

margin_table = response.json()
```

## Response

A single object describing the table's description and its ordered leverage tiers.

```json
{
  "description": "tiered 40x",
  "marginTiers": [
    { "lowerBound": "0.0", "maxLeverage": 40 },
    { "lowerBound": "150000000.0", "maxLeverage": 20 }
  ]
}
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `description` | `string` | Human-readable label for the table (for example `"tiered 40x"`). May be an empty string. |
| `marginTiers` | `array` | Ordered leverage tiers. Each tier applies once a position's notional reaches its `lowerBound`; the highest applicable tier's `maxLeverage` caps leverage for the position. |
| `marginTiers.lowerBound` | `string` | Lower bound of position notional (USD) at which this tier begins, as a decimal string. |
| `marginTiers.maxLeverage` | `int` | Maximum leverage allowed while the position's notional is within this tier. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### exchangeStatus

fetch the current exchange operational status.

### liquidatable

list accounts currently eligible for liquidation.

### maxBuilderFee

fetch the maximum builder fee a user has approved for a given builder.

### maxMarketOrderNtls

fetch the maximum market-order notional for each leverage bucket.

### validatorL1Votes

validatorL1Votes endpoint.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## maxBuilderFee | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "maxBuilderFee"` is used to fetch the maximum builder fee a user has approved for a given builder.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "maxBuilderFee", "user": "...", "builder": "..."}`.
- The response is a bare integer in tenths of a basis point (e.g. `10` = 1 basis point = 0.01%).
- Returns `0` when the user has not approved any builder fee for that builder.

Returns the maximum builder fee that a user has authorized a specific builder to charge, expressed as an integer in tenths of a basis point. Builders route order flow on behalf of users and may attach a fee up to this approved ceiling; 0 means no approval is in place for that builder.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"maxBuilderFee"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `builder` | `string` | Yes | The builder address the approval is scoped to (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "maxBuilderFee",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "builder": "0x1924b8561eef20e70d8f8f8f6a9c0e7f3c2f9c11"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "maxBuilderFee",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    builder: "0x1924b8561eef20e70d8f8f8f6a9c0e7f3c2f9c11",
  }),
});

const maxFee = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "maxBuilderFee",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "builder": "0x1924b8561eef20e70d8f8f8f6a9c0e7f3c2f9c11",
    },
)

max_fee = response.json()
```

## Response

The body is a **bare integer** - the approved ceiling in tenths of a basis point.

```json
0
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `(response body)` | `int` | Maximum approved builder fee, in tenths of a basis point (e.g. `10` = 1 bp = 0.01%). `0` when no builder fee is approved for this builder. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### maxMarketOrderNtls

fetch the maximum market-order notional for each leverage bucket.

### exchangeStatus

fetch the current exchange operational status.

### liquidatable

list accounts currently eligible for liquidation.

### marginTable

fetch the margin-tier (leverage-bracket) table for a given margin table id.

### validatorL1Votes

validatorL1Votes endpoint.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## maxMarketOrderNtls | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "maxMarketOrderNtls"` is used to fetch the maximum market-order notional for each leverage bucket.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "maxMarketOrderNtls"}`.
- Each entry is a `[leverage, maxNotionalUsd]` tuple; the notional is a decimal string.
- This is a global, non-user-keyed type. Buckets are ordered from highest leverage to lowest.

Returns the maximum market-order notional permitted at each leverage bucket. Each element is a [maxLeverage, maxNotional] tuple: a position running at up to maxLeverage may place a single market order of at most maxNotional USD. The cap tightens as leverage rises, bounding slippage on aggressive market orders.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"maxMarketOrderNtls"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "maxMarketOrderNtls"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "maxMarketOrderNtls",
  }),
});

const maxNtls = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "maxMarketOrderNtls"},
)

max_ntls = response.json()
```

## Response

An array of `[maxLeverage, maxNotional]` tuples, ordered from highest leverage to lowest.

```json
[
  [25, "30000000.0"],
  [20, "5000000.0"],
  [10, "2000000.0"],
  [1, "500000.0"]
]
```

### Field descriptions

> **Note:** The notional value in each tuple is returned as a **decimal string**, preserving upstream precision. Do not parse it as a float - keep it as a string or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `[n]` | `[int, string]` | A `[maxLeverage, maxNotional]` tuple. Index `0` is the maximum leverage (int) that the bucket applies to; index `1` is the maximum market-order notional in USD for that bucket, as a decimal string. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### maxBuilderFee

fetch the maximum builder fee a user has approved for a given builder.

### exchangeStatus

fetch the current exchange operational status.

### liquidatable

list accounts currently eligible for liquidation.

### marginTable

fetch the margin-tier (leverage-bracket) table for a given margin table id.

### validatorL1Votes

validatorL1Votes endpoint.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## metaAndAssetCtxs | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "metaAndAssetCtxs"` is used to fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "metaAndAssetCtxs"}`.

Returns a tuple `[meta, assetCtxs[]]` covering the entire Hyperliquid perpetuals universe - every coin’s metadata plus a live snapshot of mark price, funding rate, open interest, and 24-hour volume.

This is a global, non-user-keyed type. A single cache entry is shared across all callers and is refreshed continuously from upstream Hyperliquid.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"metaAndAssetCtxs"`. |
| `dex` | `string` | No | HIP-3 builder DEX identifier. Empty string (default) returns the canonical Hyperliquid perp universe. Pass a builder code (e.g. `"xyz"`) to query a HIP-3 deployer's universe. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "metaAndAssetCtxs",
    "dex": ""
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "metaAndAssetCtxs",
    dex: "",
  }),
});

const [meta, assetCtxs] = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "metaAndAssetCtxs", "dex": ""},
)

meta, asset_ctxs = response.json()
```

## Response

A two-element JSON array. Element 0 is the universe metadata; element 1 is an array of per-asset contexts indexed identically to the `universe` array.

```json
[
  {
    "universe": [
      { "name": "BTC", "szDecimals": 5, "maxLeverage": 50 },
      { "name": "ETH", "szDecimals": 4, "maxLeverage": 50 },
      { "name": "SOL", "szDecimals": 2, "maxLeverage": 20 }
    ]
  },
  [
    {
      "funding": "0.0000125",
      "openInterest": "12345.67",
      "prevDayPx": "67500.0",
      "dayNtlVlm": "894500000.0",
      "premium": "0.00001",
      "oraclePx": "68210.5",
      "markPx": "68215.0",
      "midPx": "68214.0",
      "impactPxs": ["68210.0", "68220.0"],
      "dayBaseVlm": "13130.45"
    },
    { "funding": "0.0000050", "openInterest": "9876.54", "...": "..." },
    { "funding": "0.0000200", "openInterest": "543210.98", "...": "..." }
  ]
]
```

### Element 0: `meta`

| Field | Type | Description |
| --- | --- | --- |
| `universe` | `array` | Array of perp asset metadata, indexed identically to element 1's `assetCtxs`. |
| `universe.name` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"`. For HIP-3 markets, includes the deployer prefix. |
| `universe.szDecimals` | `int` | Number of decimals for size precision. |
| `universe.maxLeverage` | `int` | Maximum leverage for this asset. |
| `universe.onlyIsolated` | `boolean` | If true, the asset only supports isolated margin. |

### Element 1: `assetCtxs[]`

Array of per-asset live context, indexed identically to `universe`.

| Field | Type | Description |
| --- | --- | --- |
| `funding` | `string` | Current funding rate (decimal string). |
| `openInterest` | `string` | Open interest in base units. |
| `prevDayPx` | `string` | Mark price 24 hours ago. |
| `dayNtlVlm` | `string` | 24-hour notional volume in USD. |
| `premium` | `string` | Mark vs oracle premium. |
| `oraclePx` | `string` | Current oracle price. |
| `markPx` | `string` | Current mark price. |
| `midPx` | `string` | Current orderbook mid price. |
| `impactPxs` | `array` | Bid/ask impact prices `[bidImpact, askImpact]`. |
| `dayBaseVlm` | `string` | 24-hour volume in base units. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### outcomeMeta

enumerate all active HIP-4 binary outcome markets on HyperCore.

### meta

fetch the perpetuals universe metadata without live market context.

### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

### settledOutcome

retrieve resolution details for a settled HIP-4 binary outcome market on HyperCore.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## meta | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "meta"` is used to fetch the perpetuals universe metadata without live market context.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "meta"}`.
- Use [metaAndAssetCtxs](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta-and-asset-ctxs) when you also need live per-asset mark price, funding, open interest, and day volume.
- The optional `dex` field takes a perp DEX name. It defaults to the empty string which represents the first perp DEX.
- For the spot equivalent, use [spotMeta](https://goldrush.dev/docs/api-reference/hyperliquid-info/spot-meta).

Returns the static metadata for the entire Hyperliquid perpetuals universe: every coin’s symbol, size-decimal precision, maximum leverage, and the margin-tier table it references. Unlike `metaAndAssetCtxs`, this payload carries no live market data, so it is cheap to cache and changes only when listings or margin parameters change.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"meta"`. |
| `dex` | `string` | No | HIP-3 builder DEX identifier. Empty string (default) returns the canonical Hyperliquid perp universe. Pass a builder code (e.g. `"xyz"`) to query a HIP-3 deployer's universe. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "meta",
    "dex": ""
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "meta",
    dex: "",
  }),
});

const meta = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "meta", "dex": ""},
)

meta = response.json()
```

## Response

A single JSON object describing the perp universe, the margin-tier tables it references, and the collateral token.

```json
{
  "universe": [
    { "name": "BTC", "szDecimals": 5, "maxLeverage": 40, "marginTableId": 56 },
    { "name": "ETH", "szDecimals": 4, "maxLeverage": 25, "marginTableId": 55 },
    { "name": "MATIC", "szDecimals": 1, "maxLeverage": 20, "marginTableId": 20, "isDelisted": true }
  ],
  "marginTables": [
    [
      50,
      {
        "description": "",
        "marginTiers": [
          { "lowerBound": "0.0", "maxLeverage": 50 }
        ]
      }
    ]
  ],
  "collateralToken": 0
}
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `universe` | `array` | Array of perp asset metadata. |
| `universe.name` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"`. For HIP-3 markets, includes the deployer prefix. |
| `universe.szDecimals` | `int` | Number of decimals for size precision. |
| `universe.maxLeverage` | `int` | Maximum leverage for this asset. |
| `universe.marginTableId` | `int` | Identifier of the margin-tier table in `marginTables` that governs this asset. |
| `universe.onlyIsolated` | `boolean` | If true, the asset only supports isolated margin. Omitted when false. |
| `universe.isDelisted` | `boolean` | If true, the asset has been delisted and is no longer tradeable. Omitted when false. |
| `marginTables` | `array` | Margin-tier tables, each a `[id, table]` tuple. `id` matches a `universe[].marginTableId`; `table` holds a `description` and a `marginTiers` array of `{lowerBound, maxLeverage}` steps describing how max leverage decreases as position notional grows. |
| `collateralToken` | `int` | Token index of the collateral asset backing the perp universe (USDC is `0`). |

{/* generated:hl-linkhub-start */}

## Related endpoints


### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

### outcomeMeta

enumerate all active HIP-4 binary outcome markets on HyperCore.

### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-13_

{/* generated:hl-footer-end */}

---

## openOrders | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "openOrders"` is used to list a user's resting open orders.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "openOrders", "user": "..."}`.
- For orders enriched with trigger metadata, TP/SL flags, and the human-readable order type shown in the Hyperliquid web UI, use [`frontendOpenOrders`](https://goldrush.dev/docs/api-reference/hyperliquid-info/frontend-open-orders) instead.
- The optional `dex` field scopes the query to a HIP-3 builder DEX; the empty string (default) returns orders on the canonical Hyperliquid perp DEX.
- For a real-time stream of order placement and cancellation events, subscribe to [`walletTxs`](https://goldrush.dev/docs/goldrush-hyperliquid/streaming/wallet-firehose).

Returns a single user's currently resting open orders as compact rows: coin, side, limit price, remaining size, order id, placement timestamp, original size, and client order id. This is the lightweight variant - reach for frontendOpenOrders when you also need trigger conditions, reduce-only / position-TP-SL flags, and the human-readable order type.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"openOrders"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `dex` | `string` | No | HIP-3 builder DEX identifier. Empty string (default) returns orders on the canonical Hyperliquid perp DEX. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "openOrders",
    "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "openOrders",
    user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
  }),
});

const orders = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "openOrders",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    },
)

orders = response.json()
```

## Response

An array of open-order objects. Empty when the user has no resting orders.

```json
[
  {
    "coin": "UNI",
    "side": "B",
    "limitPx": "3.8558",
    "sz": "104.2",
    "oid": 501169923808,
    "timestamp": 1784799315550,
    "origSz": "104.2",
    "cloid": "0x00000000000000000000019f8ad9b4b4"
  }
]
```

### Field descriptions

> **Note:** `limitPx`, `sz`, and `origSz` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"UNI"` for perps; spot pairs use the `@N` form. |
| `side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `limitPx` | `string` | Limit price. |
| `sz` | `string` | Remaining (unfilled) order size. |
| `oid` | `int` | Numeric order ID. |
| `timestamp` | `int` | Order placement time in milliseconds since Unix epoch. |
| `origSz` | `string` | Original order size before any partial fills. |
| `cloid` | `string | null` | Client order ID set at placement, or `null` when none was provided. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### frontendOpenOrders

fetch a user's currently open orders enriched with frontend metadata.

### historicalOrders

fetch a user's recent orders - both open and finalized - each with its current status and status timestamp.

### orderStatus

look up the status of a single order for a user, by order id (oid) or client order id (cloid).

### perpsAtOpenInterestCap

list the perp assets currently at their open-interest cap.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## orderStatus | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "orderStatus"` is used to look up the status of a single order for a user, by order id (oid) or client order id (cloid).

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "orderStatus", "user": "0x...", "oid": ...}`.
- `oid` accepts either a numeric order id or a client order id (`cloid`, a hex string).
- If the order is not found for that user, the response is `{"status": "unknownOid"}` (no `order` field).
- To fetch many orders at once, use `historicalOrders` instead.

Returns the status of one order together with the order itself. Use it to poll a specific order you placed - by its exchange oid or the cloid you supplied - without pulling the user's whole order history.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"orderStatus"`. |
| `user` | `string` | Yes | The account address in 42-character hex format, e.g. `"0x0000000000000000000000000000000000000000"`. |
| `oid` | `int | string` | Yes | The order identifier. Pass the numeric **order id** (e.g. `513957677284`) or a **client order id** (`cloid`) as a hex string (e.g. `"0x..."`). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "orderStatus",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "oid": 513957677284
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "orderStatus",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    oid: 513957677284,
  }),
});

const result = await response.json();
if (result.status === "order") {
  console.log(result.order.status, result.order.order.coin, result.order.order.oid);
} else {
  console.log("not found:", result.status); // "unknownOid"
}
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "orderStatus", "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b", "oid": 513957677284},
)

result = response.json()
if result["status"] == "order":
    print(result["order"]["status"], result["order"]["order"]["coin"])
else:
    print("not found:", result["status"])
```

## Response

When the order is found, `status` is `"order"` and `order` contains the order plus its status. When it is not, `status` is `"unknownOid"` and there is no `order`.

```json
{
  "status": "order",
  "order": {
    "order": {
      "coin": "POPCAT",
      "side": "A",
      "limitPx": "0.043668",
      "sz": "16812.0",
      "oid": 513957677284,
      "timestamp": 1786384269962,
      "triggerCondition": "N/A",
      "isTrigger": false,
      "triggerPx": "0.0",
      "children": [],
      "isPositionTpsl": false,
      "reduceOnly": false,
      "orderType": "Limit",
      "origSz": "16812.0",
      "tif": "Alo",
      "cloid": null
    },
    "status": "canceled",
    "statusTimestamp": 1786384274789
  }
}
```

Not found:

```json
{ "status": "unknownOid" }
```

### Field descriptions

> **Note:** `limitPx`, `sz`, `origSz`, and `triggerPx` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `status` | `string` | `"order"` when the order is found, `"unknownOid"` when there is no such order for this user. |
| `order` | `object` | Present only when `status` is `"order"`. |
| `order.order` | `object` | The order itself.  __RESPONSE_ROW__coin	string	Asset symbol. __RESPONSE_ROW__order.side	string	`"B"` = bid (buy), `"A"` = ask (sell). __RESPONSE_ROW__order.limitPx	string	Limit price (decimal string). __RESPONSE_ROW__order.sz	string	Remaining size (decimal string). __RESPONSE_ROW__order.origSz	string	Original size (decimal string). __RESPONSE_ROW__order.oid	int	Order id. __RESPONSE_ROW__order.cloid	string \| null	Client order id (hex) if supplied, else `null`. __RESPONSE_ROW__order.timestamp	int	Order creation time (ms since epoch). __RESPONSE_ROW__order.orderType	string	e.g. `"Limit"`, `"Stop Market"`. __RESPONSE_ROW__order.tif	string \| null	Time-in-force, e.g. `"Alo"`, `"Gtc"`, `"Ioc"`. __RESPONSE_ROW__order.reduceOnly	bool	Whether the order is reduce-only. __RESPONSE_ROW__order.isTrigger	bool	Whether it is a trigger order. __RESPONSE_ROW__order.triggerCondition	string	Trigger condition, or `"N/A"`. __RESPONSE_ROW__order.triggerPx	string	Trigger price (decimal string). __RESPONSE_ROW__order.isPositionTpsl	bool	Whether it is a position-level TP/SL. __RESPONSE_ROW__order.children	array	Child orders attached to this order. The order's current or terminal status. Hyperliquid defines many values; observed examples include `"open"`, `"filled"`, `"canceled"`, `"selfTradeCanceled"`, and `"iocCancelRejected"`. |
| `statusTimestamp` | `int` | Millisecond timestamp when the status took effect. |



{/* generated:hl-linkhub-start */}

## Related endpoints


### frontendOpenOrders

fetch a user's currently open orders enriched with frontend metadata.

### historicalOrders

fetch a user's recent orders - both open and finalized - each with its current status and status timestamp.

### openOrders

list a user's resting open orders.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## outcomeMeta | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "outcomeMeta"` is used to enumerate all active HIP-4 binary outcome markets on HyperCore.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "outcomeMeta"}`.
- HIP-4 launched on Hyperliquid mainnet on May 2, 2026. Read the canonical spec: [HIP-4: Outcome markets](https://hyperliquid.gitbook.io/hyperliquid-docs/hyperliquid-improvement-proposals-hips/hip-4-outcome-markets).

Returns the live HIP-4 outcome universe: every active binary outcome market on HyperCore with its integer `outcome` ID, human-readable `name`, structured `description`, and `sideSpecs` (Yes / No).

This is a global, non-user-keyed type. A single cache entry is shared across all callers and is refreshed continuously from upstream Hyperliquid.

`outcomeMeta` is HIP-4’s dedicated metadata type - separate from `metaAndAssetCtxs`, which covers perps and spot. Use it to discover live outcome IDs and compute per-side market encodings (`encoding = 10 * outcome + side`) before subscribing to OHLCV or fills.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"outcomeMeta"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "outcomeMeta"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "outcomeMeta",
  }),
});

const { outcomes } = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "outcomeMeta"},
)

outcomes = response.json()["outcomes"]
```

## Response

```json
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

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `outcomes` | `array` | Array of active outcome markets. |
| `outcomes.outcome` | `int` | Integer outcome ID. Combine with a side index to compute the tradeable market encoding: `encoding = 10 * outcome + side`. An outcome with `Yes` (side 0) and `No` (side 1) yields two encodings (e.g. `1230` and `1231`). |
| `outcomes.name` | `string` | Human-readable label for the market - for example, `"Recurring"` for repeating daily/weekly markets. |
| `outcomes.description` | `string` | Pipe-delimited spec describing the market. Parse it once to extract the full definition: \| Field \| Example \| Meaning \| \|---\|---\|---\| \| `class` \| `priceBinary` \| Market class (binary outcome on a price threshold). \| \| `underlying` \| `HYPE` \| Asset the outcome resolves against. \| \| `expiry` \| `20260310-1100` \| Resolution timestamp, `YYYYMMDD-HHMM` UTC. \| \| `targetPrice` \| `34.5` \| Threshold the underlying is compared against at expiry. \| \| `period` \| `3m` \| Recurrence cadence for repeating markets. \| |
| `outcomes.sideSpecs` | `array` | Tradeable sides of the outcome, ordered by side index. For binary outcomes, index 0 is `Yes` and index 1 is `No`.  __RESPONSE_ROW__name	string	Side label - typically `"Yes"` or `"No"` for binary outcomes.  |

{/* generated:hl-linkhub-start */}

## Related endpoints


### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### meta

fetch the perpetuals universe metadata without live market context.

### settledOutcome

retrieve resolution details for a settled HIP-4 binary outcome market on HyperCore.

### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## perpDeployAuctionStatus | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "perpDeployAuctionStatus"` is used to fetch the current perp-deploy Dutch-auction status.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "perpDeployAuctionStatus"}`.
- Describes the current perp-deploy (HIP-3) Dutch auction: the gas price decays over `durationSeconds` from `startGas`, and `currentGas` is the live price a deployer would pay now.
- `currentGas` is `null` once the auction has ended; `endGas` is `null` while the auction is still active.
- Gas prices are decimal strings. This is a global, non-user-keyed type.

Returns the status of the current perp-deploy Dutch auction. To deploy a new HIP-3 perp DEX, a deployer pays the auction's gas price, which decays over time from startGas. currentGas is the live price; it becomes null after the auction ends, at which point endGas records the final price.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"perpDeployAuctionStatus"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "perpDeployAuctionStatus"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "perpDeployAuctionStatus",
  }),
});

const auction = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "perpDeployAuctionStatus"},
)

auction = response.json()
```

## Response

A single object describing the current perp-deploy gas auction.

```json
{
  "startTimeSeconds": 1784707200,
  "durationSeconds": 111600,
  "startGas": "1079.90632916",
  "currentGas": "601.24549785",
  "endGas": null
}
```

### Field descriptions

> **Note:** Gas prices are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `startTimeSeconds` | `int` | Auction start time (Unix seconds). |
| `durationSeconds` | `int` | Auction duration, in seconds. |
| `startGas` | `string` | Starting gas price, as a decimal string. |
| `currentGas` | `string | null` | Current gas price, as a decimal string; `null` when the auction has ended. |
| `endGas` | `string | null` | Ending gas price, as a decimal string; `null` while the auction is still active. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### perpDexLimits

fetch the open-interest, position-size, and transfer limits for a HIP-3 perp DEX.

### perpDexs

enumerate every HIP-3 builder-deployed perpetual DEX on HyperCore.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

### perpsAtOpenInterestCap

list the perp assets currently at their open-interest cap.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## perpDexLimits | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Batch

The Hyperliquid info endpoint with `type: "perpDexLimits"` is used to fetch the open-interest, position-size, and transfer limits for a HIP-3 perp DEX.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "perpDexLimits", "dex": "..."}`.
- The `dex` field names the HIP-3 builder-deployed perp DEX to inspect. Enumerate deployed DEX names with [perpDexs](https://goldrush.dev/docs/api-reference/hyperliquid-info/perp-dexs).
- Returns `null` for a DEX that has no configured limits (including the empty-string native perp DEX).
- `coinToOiCap` is an array of `[coin, cap]` tuples; all limit values are decimal strings.

Returns the risk limits configured for a HIP-3 builder-deployed perpetual DEX: the total open-interest cap, the per-perp open-interest size cap, the maximum transfer notional, and the per-asset open-interest caps.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"perpDexLimits"`. |
| `dex` | `string` | Yes | The HIP-3 builder DEX name (e.g. `"xyz"`). Enumerate deployed DEX names with `perpDexs`. An empty string selects the native Hyperliquid perp DEX, which has no configured limits and returns `null`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "perpDexLimits",
    "dex": "xyz"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "perpDexLimits",
    dex: "xyz",
  }),
});

const limits = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "perpDexLimits", "dex": "xyz"},
)

limits = response.json()
```

## Response

A single object describing the DEX's limits, or `null` when the DEX has no configured limits.

```json
{
  "totalOiCap": "10000000000.0",
  "oiSzCapPerPerp": "20000000000.0",
  "maxTransferNtl": "3000000000.0",
  "coinToOiCap": [
    ["xyz:AAPL", "100000000.0"],
    ["xyz:AMD", "100000000.0"]
  ]
}
```

### Field descriptions

> **Note:** All limit values are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `totalOiCap` | `string` | Total open-interest cap across the DEX, in USD notional. |
| `oiSzCapPerPerp` | `string` | Open-interest size cap applied per perp on this DEX. |
| `maxTransferNtl` | `string` | Maximum transfer notional allowed on this DEX. |
| `coinToOiCap` | `array` | Per-asset open-interest caps, encoded as `[coin, cap]` tuples. Values are decimal strings. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### perpDeployAuctionStatus

fetch the current perp-deploy Dutch-auction status.

### perpDexs

enumerate every HIP-3 builder-deployed perpetual DEX on HyperCore.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

### perpsAtOpenInterestCap

list the perp assets currently at their open-interest cap.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## perpDexs | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "perpDexs"` is used to enumerate every HIP-3 builder-deployed perpetual DEX on HyperCore.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "perpDexs"}`.
- The `null` at index `0` represents the canonical Hyperliquid perp DEX; use [meta](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta) or [metaAndAssetCtxs](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta-and-asset-ctxs) with the default `dex: ""` to query its universe.
- Pass a builder DEX `name` from this list as the `dex` field on [meta](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta) or [metaAndAssetCtxs](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta-and-asset-ctxs) to fetch a specific HIP-3 perp universe.
- `assetToStreamingOiCap` and `assetToFundingMultiplier` are `[coin, value]` tuple arrays scoped to that DEX.

Returns the full list of perpetual DEXes on HyperCore. Index `0` is `null` and represents the canonical Hyperliquid perp universe; each subsequent entry is a HIP-3 builder-deployed perp DEX, exposing its short name, full name, deployer address, oracle updater, fee recipient, per-asset streaming open-interest caps, and per-asset funding-rate multipliers.

This is a global, non-user-keyed type. A single cache entry is shared across all callers and is refreshed as new HIP-3 DEXes are deployed or their parameters change.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"perpDexs"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "perpDexs"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "perpDexs",
  }),
});

const perpDexs = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "perpDexs"},
)

perp_dexs = response.json()
```

## Response

An array of perpetual DEX entries. Index `0` is `null` and represents the canonical Hyperliquid perp universe (query it via `meta` / `metaAndAssetCtxs` with the default empty `dex` field). Each subsequent element is a HIP-3 builder-deployed perp DEX.

```json
[
  null,
  {
    "name": "test",
    "fullName": "test dex",
    "deployer": "0x5e89b26d8d66da9888c835c9bfcc2aa51813e152",
    "oracleUpdater": null,
    "feeRecipient": null,
    "assetToStreamingOiCap": [["COIN1", "100000.0"], ["COIN2", "200000.0"]],
    "assetToFundingMultiplier": [["COIN1", "1.0"], ["COIN2", "2.0"]]
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `[0]` | `null` | The canonical Hyperliquid perp DEX is always represented by `null` at index 0. Use `meta` or `metaAndAssetCtxs` with the default `dex: ""` to query its universe. |
| `[1..]` | `object` | HIP-3 builder-deployed perpetual DEX. |
| `[1..].name` | `string` | Short identifier for the perp DEX. Pass this value as the `dex` field to `meta` or `metaAndAssetCtxs` to query this DEX's universe. |
| `[1..].fullName` | `string` | Human-readable name for the perp DEX. |
| `[1..].deployer` | `string` | Address of the builder that deployed the HIP-3 perp DEX. |
| `[1..].oracleUpdater` | `string | null` | Address authorized to push oracle updates for this DEX. `null` when the DEX does not delegate oracle updates. |
| `[1..].feeRecipient` | `string | null` | Address that collects fees generated by this DEX. `null` when unset. |
| `[1..].assetToStreamingOiCap` | `array` | Per-asset streaming open-interest caps, encoded as `[coin, cap]` tuples. Values are decimal strings. |
| `[1..].assetToFundingMultiplier` | `array` | Per-asset funding-rate multipliers, encoded as `[coin, multiplier]` tuples. Values are decimal strings. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### perpDeployAuctionStatus

fetch the current perp-deploy Dutch-auction status.

### perpDexLimits

fetch the open-interest, position-size, and transfer limits for a HIP-3 perp DEX.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

### perpsAtOpenInterestCap

list the perp assets currently at their open-interest cap.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-07_

{/* generated:hl-footer-end */}

---

## perpsAtOpenInterestCap | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "perpsAtOpenInterestCap"` is used to list the perp assets currently at their open-interest cap.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "perpsAtOpenInterestCap"}`.
- While an asset is in this list it has reached its open-interest cap; orders that would increase aggregate open interest are rejected (see the `openInterestCap*` order-rejection reasons) until open interest falls back below the cap.
- This is a global, non-user-keyed type refreshed continuously from upstream Hyperliquid.

Returns the list of perpetual assets that are currently at their open-interest cap, as an array of coin symbol strings. Use it to detect which markets are constrained before placing orders that would add open interest.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"perpsAtOpenInterestCap"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "perpsAtOpenInterestCap"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "perpsAtOpenInterestCap",
  }),
});

const cappedPerps = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "perpsAtOpenInterestCap"},
)

capped_perps = response.json()
```

## Response

An array of coin symbol strings for the perp assets currently at their open-interest cap. Empty when no market is capped.

```json
["CANTO", "FTM", "JELLY", "LOOM", "RLB", "ZEREBRO"]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `[n]` | `string` | Coin symbol of a perp asset currently at its open-interest cap. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

### perpDeployAuctionStatus

fetch the current perp-deploy Dutch-auction status.

### perpDexLimits

fetch the open-interest, position-size, and transfer limits for a HIP-3 perp DEX.

### perpDexs

enumerate every HIP-3 builder-deployed perpetual DEX on HyperCore.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## portfolioState | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "portfolioState"` is used to fetch a wallet's perp clearinghouse state, spot balances, and account-abstraction mode in a single request.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native composite — not part of the original Hyperliquid API. It bundles three upstream calls into one round-trip: [clearinghouseState](https://goldrush.dev/docs/api-reference/hyperliquid-info/clearinghouse-state), [spotClearinghouseState](https://goldrush.dev/docs/api-reference/hyperliquid-info/spot-clearinghouse-state), and `userAbstraction`.
- Pass `dex` to scope the perp `clearinghouseState` to a single HIP-3 DEX. Pass `dex: "ALL_DEXES"` to return the perp state across the native DEX plus every HIP-3 DEX in one call, keyed by DEX name.
- `spotClearinghouseState` and `userAbstraction` are DEX-independent and always returned once.

Returns a single object bundling a wallet's perp account state (clearinghouseState), spot balances (spotClearinghouseState), and account-abstraction mode (userAbstraction) — the three calls a portfolio view typically needs, in one round-trip.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"portfolioState"`. |
| `user` | `string` | Yes | Ethereum address (0x-prefixed, 42 characters). |
| `dex` | `string` | No | Perp DEX name. Omit for the native DEX (default). Use `"ALL_DEXES"` to fetch the perp `clearinghouseState` across the native DEX plus every HIP-3 DEX in one call. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "portfolioState",
    "user": "0x0000000000000000000000000000000000000000"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "portfolioState",
    user: "0x0000000000000000000000000000000000000000",
  }),
});

const portfolio = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "portfolioState",
        "user": "0x0000000000000000000000000000000000000000",
    },
)

portfolio = response.json()
```

## Response

An object with three keys — the perp clearinghouse state, spot clearinghouse state, and the account-abstraction mode.

```json
{
  "clearinghouseState": {
    "marginSummary": { "accountValue": "…", "totalNtlPos": "…", "totalRawUsd": "…", "totalMarginUsed": "…" },
    "crossMarginSummary": { "…": "…" },
    "assetPositions": [],
    "time": 1234567890123
  },
  "spotClearinghouseState": {
    "balances": [
      { "coin": "USDC", "token": 0, "total": "0.02221591", "hold": "0.0", "entryNtl": "0.0" }
    ]
  },
  "userAbstraction": "unifiedAccount"
}
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `clearinghouseState` | `object` | The wallet's perp account state — identical to the standalone `clearinghouseState` response (`marginSummary`, `crossMarginSummary`, `assetPositions`, `time`). Scoped to `dex` when supplied; a per-DEX object when `dex: "ALL_DEXES"` (see below). |
| `spotClearinghouseState` | `object` | The wallet's spot balances. |
| `spotClearinghouseState.balances` | `array` | One entry per held spot token.  __RESPONSE_ROW__coin	string	Coin symbol. __RESPONSE_ROW__spotClearinghouseState.token	int	Token index. __RESPONSE_ROW__spotClearinghouseState.total	string	Total balance (decimal string). __RESPONSE_ROW__spotClearinghouseState.hold	string	Amount on hold (decimal string). __RESPONSE_ROW__spotClearinghouseState.entryNtl	string	Entry notional (decimal string).  |
| `userAbstraction` | `string` | The wallet's account-abstraction mode. One of: |
| `userAbstraction.unifiedAccount` | `string` | Single balance per asset across all DEXes; all cross-margin positions share collateral. |
| `userAbstraction.portfolioMargin` | `string` | Portfolio margin — a single portfolio unifying eligible assets with borrowing / LTV. |
| `userAbstraction.disabled` | `string` | Abstraction disabled — separate perp and spot balances. |
| `userAbstraction.default` | `string` | Default mode. |
| `userAbstraction.dexAbstraction` | `string` | DEX abstraction mode (legacy, being discontinued). |

### `ALL_DEXES` response

When `dex: "ALL_DEXES"` is passed, `clearinghouseState` becomes an object keyed by DEX name — the native DEX under `"native"` plus one key per HIP-3 DEX. `spotClearinghouseState` and `userAbstraction` are unchanged.

```json
{
  "clearinghouseState": {
    "native": { "marginSummary": {}, "crossMarginSummary": {}, "assetPositions": [], "time": 1234567890123 },
    "xyz": { "marginSummary": {}, "crossMarginSummary": {}, "assetPositions": [], "time": 1234567890123 }
  },
  "spotClearinghouseState": { "balances": [] },
  "userAbstraction": "unifiedAccount"
}
```

{/* generated:hl-linkhub-start */}

## Related endpoints


### batchClearinghouseState

fetch perpetuals account state for up to 50 wallets in a single request.

### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## settledOutcome | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "settledOutcome"` is used to retrieve resolution details for a settled HIP-4 binary outcome market on HyperCore.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "settledOutcome", "outcome": }`.

Returns the on-chain settlement data for a single settled HIP-4 outcome: the integer outcome ID, the resolved side, the resolution price, and the settlement timestamp.

Use this once an outcome has resolved to confirm which side paid out and reconcile against your own books.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"settledOutcome"`. |
| `outcome` | `int` | Yes | Integer outcome ID for the settled HIP-4 market. Outcome IDs are stable across the market's lifecycle - the same ID returned by `outcomeMeta` while live is queried here once the outcome has resolved. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "settledOutcome",
    "outcome": 1
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "settledOutcome",
    outcome: 1,
  }),
});

const settlement = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "settledOutcome",
        "outcome": 1,
    },
)

settlement = response.json()
```

## Response

```json
{
  "spec": {
    "outcome": 1,
    "name": "Recurring",
    "description": "class:priceBinary|underlying:BTC|expiry:20260504-0600|targetPrice:78213|period:1d",
    "sideSpecs": [
      { "name": "Yes" },
      { "name": "No" }
    ],
    "quoteToken": "USDH"
  },
  "settleFraction": "1.0",
  "details": "price:79980"
}
```

For question-class outcomes (free-form markets resolved by an oracle question), the response also includes a `question` object:

```json
{
  "spec": {
    "outcome": 100,
    "name": "Fallback",
    "description": "",
    "sideSpecs": [{ "name": "Yes" }, { "name": "No" }],
    "quoteToken": "USDC"
  },
  "settleFraction": "0.0",
  "details": "",
  "question": {
    "question": {
      "settled": 19,
      "name": "May CPI year-over-year",
      "description": "The question resolves by assigning Yes to exactly one of …"
    }
  }
}
```

### Field descriptions

> **Note:** `settleFraction` is returned as a **decimal string** with full upstream precision. Do not parse it as a float - keep it as a string or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `spec` | `object` | Original market specification for the outcome - the same shape `outcomeMeta` returns while the market is live. |
| `spec.outcome` | `int` | Integer outcome ID. Echoes the request parameter. |
| `spec.name` | `string` | Human-readable label for the market - for example, `"Recurring"` for repeating price-binary markets. |
| `spec.description` | `string` | For `priceBinary` markets, a pipe-delimited spec (`class:…\|underlying:…\|expiry:…\|targetPrice:…\|period:…`). Empty string for `question`-class outcomes. |
| `spec.sideSpecs` | `array` | Tradeable sides of the outcome. For binary outcomes, index 0 is `Yes` and index 1 is `No`.  __RESPONSE_ROW__name	string	Side label - typically `"Yes"` or `"No"`. Symbol of the token the market quotes against - typically `"USDC"` or `"USDH"`. |



| Field | Type | Description |
| --- | --- | --- |
| `settleFraction` | `string` | The fraction the `Yes` side (index 0) paid out at resolution, as a decimal string. `"1.0"` means `Yes` won outright, `"0.0"` means `No` won, fractional values indicate a partial settlement. |
| `details` | `string` | Free-form resolution detail. For `priceBinary` markets, contains the resolved underlying value (e.g. `"price:79980"`). Empty string when settlement detail is carried in the `question` object instead. |
| `question` | `object` | Optional. Present only for question-class outcomes. Wraps the structured oracle question that produced the resolution. |
| `question.question` | `object` |  __RESPONSE_ROW__settled	int	Encoded settlement side (`19` is observed for `No`-resolved questions in current data). __RESPONSE_ROW__question.name	string	Short label for the question. __RESPONSE_ROW__question.description	string	Full question description, including resolution criteria and fallback rules.  |

{/* generated:hl-linkhub-start */}

## Related endpoints


### outcomeMeta

enumerate all active HIP-4 binary outcome markets on HyperCore.

### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-19_

{/* generated:hl-footer-end */}

---

## spotClearinghouseState | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "spotClearinghouseState"` is used to fetch a single user's spot account balances by wallet address.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "spotClearinghouseState", "user": "..."}`.
- USDC balance is returned as `token: 0`.

Returns a single user’s spot account state - token-by-token balances and the total USD value.

User-keyed. Cached and kept fresh by a per-user WebSocket subscription, so updates are sub-second after any user event.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"spotClearinghouseState"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `dex` | `string` | No | Reserved for future HIP-3 spot DEX support. Pass empty string. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "spotClearinghouseState",
    "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    "dex": ""
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "spotClearinghouseState",
    user: "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
    dex: "",
  }),
});

const state = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "spotClearinghouseState",
        "user": "0xecb63caa47c7c4e77f60f1ce858cf28dc2b82b00",
        "dex": "",
    },
)

state = response.json()
```

## Response

```json
{
  "balances": [
    {
      "coin": "USDC",
      "token": 0,
      "hold": "0.0",
      "total": "5000.00",
      "entryNtl": "5000.00"
    },
    {
      "coin": "HYPE",
      "token": 150,
      "hold": "0.0",
      "total": "320.45",
      "entryNtl": "1530.00"
    },
    {
      "coin": "PURR",
      "token": 1,
      "hold": "0.0",
      "total": "12500.0",
      "entryNtl": "375.00"
    }
  ],
  "tokenToAvailableAfterMaintenance": [[0, "5000.00"]]
}
```

### Field descriptions

> **Note:** All numeric balance fields (`total`, `hold`, `entryNtl`) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `balances` | `array` | One entry per token the wallet has interacted with on Hyperliquid spot. May be empty (`[]`) for wallets with no spot history. |
| `balances.coin` | `string` | Token ticker symbol (e.g. `"USDC"`, `"PURR"`, `"HYPE"`). |
| `balances.token` | `int` | Numeric token index assigned by Hyperliquid. The pair `(coin, token)` together identifies the asset. |
| `balances.hold` | `string` | Portion of `total` currently locked in open spot orders. Withdrawable balance is `total - hold`. |
| `balances.total` | `string` | Total balance (held + free). |
| `balances.entryNtl` | `string` | Entry notional value at acquisition, in USD. |
| `tokenToAvailableAfterMaintenance` | `array` | **Optional.** Present only when at least one token has a non-zero margin-deduction-aware balance. Each tuple is `[tokenId, availableAmountString]` where `tokenId` references `balances[].token`. Wallets without this field can ignore it; absence is normal for empty or inactive wallets. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

### spotDeployState

fetch the spot-token deployment state and gas auction for a deployer.

### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### batchClearinghouseState

fetch perpetuals account state for up to 50 wallets in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## spotDeployState | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "spotDeployState"` is used to fetch the spot-token deployment state and gas auction for a deployer.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "spotDeployState", "user": "..."}`.
- `states` lists the deployer's in-progress spot-token deployments; it is empty for a `user` with no active deployment.
- `gasAuction` describes the current spot-deploy Dutch gas auction, with gas prices returned as decimal strings.
- User-keyed by the deployer address.

Returns the spot-token deployment state for a deployer: any in-progress token deployments (states) plus the current spot-deploy gas auction (gasAuction). Use it to track a deployer's genesis configuration and the live gas price required to deploy a spot token.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"spotDeployState"`. |
| `user` | `string` | Yes | The deployer wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "spotDeployState",
    "user": "0x5e89b26d8d66da9888c835c9bfcc2aa51813e152"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "spotDeployState",
    user: "0x5e89b26d8d66da9888c835c9bfcc2aa51813e152",
  }),
});

const deployState = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "spotDeployState",
        "user": "0x5e89b26d8d66da9888c835c9bfcc2aa51813e152",
    },
)

deploy_state = response.json()
```

## Response

A single object with the deployer's in-progress deployments and the current gas auction. `states` is empty when the deployer has no active spot deployment.

```json
{
  "states": [],
  "gasAuction": {
    "startTimeSeconds": 1784707200,
    "durationSeconds": 111600,
    "startGas": "1009.8417473",
    "currentGas": "589.01327066",
    "endGas": null
  }
}
```

### Field descriptions

> **Note:** Gas prices and genesis balances are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `states` | `array` | In-progress spot-token deployments for this deployer. Empty when the deployer has no active deployment. |
| `states.token` | `int` | Token index. |
| `states.spec` | `object` | Token specification.  __RESPONSE_ROW__name	string	Token name. __RESPONSE_ROW__states.szDecimals	int	Number of decimals for size precision. __RESPONSE_ROW__states.weiDecimals	int	Number of decimals for the wei-denominated amount. Full (human-readable) token name. |
| `spots` | `array` | Spot pair indices the token participates in. |
| `maxSupply` | `int` | Maximum token supply. |
| `hyperliquidityGenesisBalance` | `string` | Hyperliquidity genesis balance allocated at deployment. |
| `totalGenesisBalanceWei` | `string` | Total genesis balance, in wei. |
| `userGenesisBalances` | `array` | `[address, balance]` pairs for genesis balances allocated to users. |
| `existingTokenGenesisBalances` | `array` | `[tokenIndex, balance]` pairs for genesis balances denominated in existing tokens. |



| Field | Type | Description |
| --- | --- | --- |
| `gasAuction` | `object` | Current spot-deploy gas auction. |
| `gasAuction.startTimeSeconds` | `int` | Auction start time (Unix seconds). |
| `gasAuction.durationSeconds` | `int` | Auction duration, in seconds. |
| `gasAuction.startGas` | `string` | Starting gas price, as a decimal string. |
| `gasAuction.currentGas` | `string | null` | Current gas price, as a decimal string; `null` when the auction has ended. |
| `gasAuction.endGas` | `string | null` | Ending gas price, as a decimal string; `null` while the auction is still active. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## spotMetaAndAssetCtxs | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "spotMetaAndAssetCtxs"` is used to fetch the spot universe metadata, token configuration, and live market data in a single call.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "spotMetaAndAssetCtxs"}`.
- For perp universe + live contexts, use [`metaAndAssetCtxs`](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta-and-asset-ctxs) instead.

Returns a tuple `[spotMeta, assetCtxs[]]` covering the entire Hyperliquid spot universe - every pair’s universe entry, every token’s metadata, and a live snapshot of mark price, mid price, prior-day price, and 24-hour notional volume per pair.

This is the spot counterpart of `metaAndAssetCtxs`. Global, non-user-keyed; a single cache entry is shared across all callers and refreshed continuously from upstream Hyperliquid.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"spotMetaAndAssetCtxs"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "spotMetaAndAssetCtxs"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "spotMetaAndAssetCtxs",
  }),
});

const [spotMeta, assetCtxs] = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "spotMetaAndAssetCtxs"},
)

spot_meta, asset_ctxs = response.json()
```

## Response

A two-element JSON array. Element 0 is the spot universe and token metadata; element 1 is an array of per-pair live contexts indexed identically to element 0's `universe`.

```json
[
  {
    "universe": [
      {
        "name": "PURR/USDC",
        "tokens": [1, 0],
        "index": 0,
        "isCanonical": true
      }
    ],
    "tokens": [
      {
        "name": "USDC",
        "szDecimals": 8,
        "weiDecimals": 8,
        "index": 0,
        "tokenId": "0x6d1e7cde53ba9467b783cb7c530ce054",
        "isCanonical": true,
        "evmContract": null,
        "fullName": null
      },
      {
        "name": "PURR",
        "szDecimals": 0,
        "weiDecimals": 5,
        "index": 1,
        "tokenId": "0xc1fb593aeffbeb02f85e0308e9956a90",
        "isCanonical": true,
        "evmContract": null,
        "fullName": null
      }
    ]
  },
  [
    {
      "coin": "PURR/USDC",
      "markPx": "0.5250",
      "midPx": "0.5245",
      "prevDayPx": "0.4800",
      "dayNtlVlm": "1250000.0",
      "dayBaseVlm": "2380952.38",
      "circulatingSupply": "1000000000.0"
    }
  ]
]
```

### Element 0: `spotMeta`

| Field | Type | Description |
| --- | --- | --- |
| `universe` | `array` | Array of spot pairs, indexed identically to element 1's `assetCtxs`. |
| `universe.name` | `string` | Pair label - e.g. `"PURR/USDC"`. |
| `universe.tokens` | `array` | Two-element array of token indices `[base, quote]` referencing entries in `tokens[].index`. |
| `universe.index` | `int` | Numeric pair index. The spot encoding for trading subscriptions is `10000 + index`. |
| `universe.isCanonical` | `boolean` | `true` for pairs in the canonical Hyperliquid spot universe. |
| `tokens` | `array` | Token configuration referenced by `universe[].tokens`. |
| `tokens.name` | `string` | Token symbol - e.g. `"USDC"`, `"PURR"`. |
| `tokens.szDecimals` | `int` | Number of decimals used for size precision. |
| `tokens.weiDecimals` | `int` | Number of decimals used for the on-chain wei representation. |
| `tokens.index` | `int` | Token index. `(coin, index)` together identifies the asset. |
| `tokens.tokenId` | `string` | Hyperliquid token identifier (hex). |
| `tokens.isCanonical` | `boolean` | `true` for tokens deployed in the canonical Hyperliquid spot universe. |
| `tokens.evmContract` | `object | null` | EVM contract address if the token has an HyperEVM mapping; `null` otherwise. |
| `tokens.fullName` | `string | null` | Optional full token name. |

### Element 1: `assetCtxs[]`

Array of per-pair live context, indexed identically to `universe`.

> **Note:** All numeric fields below are returned as **decimal strings**. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | Pair symbol - matches `universe[].name`. |
| `markPx` | `string` | Current mark price. |
| `midPx` | `string` | Current orderbook mid price. |
| `prevDayPx` | `string` | Mark price 24 hours ago. |
| `dayNtlVlm` | `string` | 24-hour notional volume in USDC. |
| `dayBaseVlm` | `string` | 24-hour volume in base units. |
| `circulatingSupply` | `string` | Circulating supply of the base token. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### spotMeta

fetch the spot universe metadata and full token configuration without live market context.

### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

### outcomeMeta

enumerate all active HIP-4 binary outcome markets on HyperCore.

### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### spotDeployState

fetch the spot-token deployment state and gas auction for a deployer.

### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## spotMeta | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "spotMeta"` is used to fetch the spot universe metadata and full token configuration without live market context.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "spotMeta"}`.
- Use [spotMetaAndAssetCtxs](https://goldrush.dev/docs/api-reference/hyperliquid-info/spot-meta-and-asset-ctxs) when you also need live per-pair mark price, mid, and day volume.
- For the perpetuals equivalent, use [meta](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta).

Returns the static metadata for the entire Hyperliquid spot market: the list of trading pairs (`universe`) and the full token registry (`tokens`) with each token’s decimals, on-chain identifier, and linked HyperEVM contract. Carries no live market data, so it is cheap to cache and changes only when new tokens or pairs are listed.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"spotMeta"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "spotMeta"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "spotMeta",
  }),
});

const spotMeta = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "spotMeta"},
)

spot_meta = response.json()
```

## Response

A single JSON object with two arrays: `tokens` (the token registry) and `universe` (the tradeable pairs that reference those tokens by index).

```json
{
  "tokens": [
    {
      "name": "USDC",
      "szDecimals": 8,
      "weiDecimals": 8,
      "index": 0,
      "tokenId": "0x6d1e7cde53ba9467b783cb7c530ce054",
      "isCanonical": true,
      "evmContract": {
        "address": "0x6b9e773128f453f5c2c60935ee2de2cbc5390a24",
        "evm_extra_wei_decimals": -2
      },
      "fullName": null,
      "deployerTradingFeeShare": "0.0"
    },
    {
      "name": "PURR",
      "szDecimals": 0,
      "weiDecimals": 5,
      "index": 1,
      "tokenId": "0xc1fb593aeffbeb02f85e0308e9956a90",
      "isCanonical": true,
      "evmContract": null,
      "fullName": null,
      "deployerTradingFeeShare": "0.0"
    }
  ],
  "universe": [
    { "tokens": [1, 0], "name": "PURR/USDC", "index": 0, "isCanonical": true }
  ]
}
```

### `tokens[]`

| Field | Type | Description |
| --- | --- | --- |
| `name` | `string` | Token symbol - e.g. `"USDC"`, `"PURR"`. |
| `szDecimals` | `int` | Number of decimals used for order size precision. |
| `weiDecimals` | `int` | Number of decimals in the token's native wei representation. |
| `index` | `int` | Token index. `universe[].tokens` references tokens by this value. |
| `tokenId` | `string` | Hyperliquid on-chain token identifier. |
| `isCanonical` | `boolean` | Whether the token is a canonical (core) Hyperliquid token. |
| `evmContract` | `object | null` | Linked HyperEVM contract, or `null` if the token is not bridged. Carries `address` and `evm_extra_wei_decimals` (the wei-decimal offset between the spot token and its EVM representation). |
| `fullName` | `string | null` | Human-readable token name, or `null` when not set. |
| `deployerTradingFeeShare` | `string` | Share of trading fees routed to the token deployer (decimal string). |

### `universe[]`

| Field | Type | Description |
| --- | --- | --- |
| `name` | `string` | Pair symbol - e.g. `"PURR/USDC"`. Non-canonical pairs use the `@` form (e.g. `"@1"`). |
| `tokens` | `array` | Two-element `[base, quote]` array of token indices into `tokens`. |
| `index` | `int` | Pair index. Used as the spot asset identifier in other endpoints and streams. |
| `isCanonical` | `boolean` | Whether the pair is a canonical Hyperliquid market. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### spotMetaAndAssetCtxs

fetch the spot universe metadata, token configuration, and live market data in a single call.

### spotClearinghouseState

fetch a single user's spot account balances by wallet address.

### spotDeployState

fetch the spot-token deployment state and gas auction for a deployer.

### batchSpotClearinghouseState

fetch spot account balances for up to 50 wallets in a single request.

### meta

fetch the perpetuals universe metadata without live market context.

### metaAndAssetCtxs

fetch the full Hyperliquid perpetuals market universe with live per-asset trading context.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-13_

{/* generated:hl-footer-end */}

---

## subAccounts | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "subAccounts"` is used to fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "subAccounts", "user": "..."}`.
- For multi-wallet polling without traversing master/sub-account hierarchy, see [`batchClearinghouseState`](https://goldrush.dev/docs/api-reference/hyperliquid-info/batch-clearinghouse-state) and [`batchSpotClearinghouseState`](https://goldrush.dev/docs/api-reference/hyperliquid-info/batch-spot-clearinghouse-state).

Returns the sub-accounts owned by a master wallet, with each sub-account’s perp [clearinghouseState](https://goldrush.dev/docs/api-reference/hyperliquid-info/clearinghouse-state) and spot [spotClearinghouseState](https://goldrush.dev/docs/api-reference/hyperliquid-info/spot-clearinghouse-state) inlined per slot - so a single call returns the full balance picture across the master plus its sub-accounts.

User-keyed. The result is `null` for wallets that aren’t master accounts.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"subAccounts"`. |
| `user` | `string` | Yes | The master wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "subAccounts",
    "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "subAccounts",
    user: "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
  }),
});

const subAccounts = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "subAccounts",
        "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    },
)

sub_accounts = response.json()
```

## Response

An array of sub-account objects, or `null` if the queried wallet is not a master account.

```json
[
  {
    "name": "trading-bot-1",
    "subAccountUser": "0x2b804617c6f63c040377e95bb276811747006f4b",
    "master": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    "clearinghouseState": {
      "marginSummary": {
        "accountValue": "5000.00",
        "totalNtlPos": "0.0",
        "totalRawUsd": "5000.00",
        "totalMarginUsed": "0.0"
      },
      "crossMarginSummary": {
        "accountValue": "5000.00",
        "totalNtlPos": "0.0",
        "totalRawUsd": "5000.00",
        "totalMarginUsed": "0.0"
      },
      "crossMaintenanceMarginUsed": "0.0",
      "withdrawable": "5000.00",
      "assetPositions": [],
      "time": 1735689600000
    },
    "spotState": {
      "balances": [
        { "coin": "USDC", "token": 0, "hold": "0.0", "total": "1000.00", "entryNtl": "1000.00" }
      ]
    }
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `name` | `string` | Optional human-readable label assigned to the sub-account. |
| `subAccountUser` | `string` | The sub-account's wallet address (0x-prefixed hex). |
| `master` | `string` | The master wallet address that owns this sub-account. |
| `clearinghouseState` | `object` | Perp account state for this sub-account. Identical shape to the single-wallet **`clearinghouseState`** response - margin summaries, asset positions, withdrawable balance, snapshot timestamp. |
| `spotState` | `object` | Spot account state for this sub-account. Identical shape to the single-wallet **`spotClearinghouseState`** response - per-token balances and the optional `tokenToAvailableAfterMaintenance` array. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### extraAgents

list a user's approved API-agent wallets.

### userAbstraction

fetch a user's account-abstraction mode.

### userFees

fetch a user's fee schedule and recent daily volume.

### userRateLimit

fetch a user's API rate-limit usage and cap.

### userRole

fetch a user's account role.

### userToMultiSigSigners

fetch the authorized signers for a multi-sig user.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## userAbstraction | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userAbstraction"` is used to fetch a user's account-abstraction mode.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userAbstraction", "user": "..."}`.
- The response body is a bare JSON string (for example `"disabled"`), not an object - parse it as a scalar.
- Values seen in production are `disabled` and `unifiedAccount`; the wider native enum also includes `portfolioMargin`, `default`, and the legacy `dexAbstraction`.

Returns the account-abstraction mode configured for a wallet. The response is a single JSON string rather than an object: disabled means the account keeps separate perp and spot balances, while unifiedAccount means a single balance per asset is shared across all DEXes with cross-margin positions sharing collateral.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userAbstraction"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userAbstraction",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userAbstraction",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const mode = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userAbstraction",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

mode = response.json()
```

## Response

The body is a **bare JSON string** - not an object - naming the account-abstraction mode.

```json
"unifiedAccount"
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `(response body)` | `string` | Account-abstraction mode. One of: - `disabled` - abstraction disabled; separate perp and spot balances. - `unifiedAccount` - single balance per asset across all DEXes; cross-margin positions share collateral. - `portfolioMargin` - single portfolio unifying eligible assets with borrowing / LTV. - `default` - default mode. - `dexAbstraction` - DEX abstraction mode (legacy, being discontinued). |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userFees

fetch a user's fee schedule and recent daily volume.

### userRateLimit

fetch a user's API rate-limit usage and cap.

### userRole

fetch a user's account role.

### userToMultiSigSigners

fetch the authorized signers for a multi-sig user.

### extraAgents

list a user's approved API-agent wallets.

### subAccounts

fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userBorrowLendInterest | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userBorrowLendInterest"` is used to fetch a user's borrow/lend interest accrual history.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userBorrowLendInterest", "user": "...", "startTime": ...}`.
- Bounded by a `**startTime, endTime)` window in milliseconds; `endTime` defaults to the current server time when omitted.
- Amounts are decimal strings, one row per token per accrual point.

Returns a user's borrow/lend interest accrual over a time window - the interest charged on borrowed balances and earned on supplied (lent) balances, per token. Use it for P&L attribution and accounting on Hyperliquid borrow/lend positions.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userBorrowLendInterest"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound for the window. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userBorrowLendInterest",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "startTime": 1735689600000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userBorrowLendInterest",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    startTime: 1735689600000,
  }),
});

const interest = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userBorrowLendInterest",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "startTime": 1735689600000,
    },
)

interest = response.json()
```

## Response

An array of per-token interest accrual points within the window. Empty when the user accrued no borrow/lend interest over the range.

```json
[
  {
    "time": 1735689600000,
    "token": "USDC",
    "borrow": "0.0",
    "supply": "1.2345"
  }
]
```

### Field descriptions

> **Note:** `borrow` and `supply` are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats.

| Field | Type | Description |
| --- | --- | --- |
| `time` | `int` | Millisecond timestamp of the accrual point. |
| `token` | `string` | Token symbol the interest applies to - e.g. `"USDC"`. |
| `borrow` | `string` | Borrow interest charged on the borrowed balance of this token. |
| `supply` | `string` | Supply (lend) interest earned on the supplied balance of this token. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### borrowLendUserState

monitor a wallet’s current borrow/lend positions and liquidation risk (account health) in a single call.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### userFunding

fetch a user's per-coin funding payment history within a time window for funding-only P&L attribution.

### userNonFundingLedgerUpdates

fetch a user's non-funding USDC ledger history (deposits, withdrawals, transfers, vault flows) within a time…

### clearinghouseState

fetch a single user's perpetuals account state by wallet address.

See all Hyperliquid endpoints: [Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userCompletedTradesByTime | Hyperliquid Info API

**Credit Cost:** 10 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userCompletedTradesByTime"` is used to fetch a wallet's fully-closed round-trip trades within a close-time window, oldest-first, with a keyset cursor for forward paging.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush custom analytics product. **Not available on the public Hyperliquid node** - there is no `POST api.hyperliquid.xyz/info` equivalent. Served only from `POST hypercore.goldrushdata.com/info`.
- Each record is one **fully-closed round-trip position** (opened, then brought fully flat), reconstructed from the wallet's fills, windowed on `close_time` and returned **oldest-first**.
- Page forward with the keyset `cursor`: pass `"{close_time}_{tx_index}"` built from the **last row** of the previous page to fetch the next page. Repeat until fewer than `limit` records return.
- `startTime` is required unless a `cursor` is supplied. Returns up to `limit` records per page (default `100`, max `500`).
- For the latest N trades without a window, use [`userCompletedTrades`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-completed-trades). For one aggregate roll-up, use [`userPnlSummary`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-pnl-summary).

Returns a wallet's fully-closed round-trip trades whose `close_time` falls in a `[startTime, endTime]` window, ordered **oldest-first**. Each record has the same shape as **`userCompletedTrades`** plus a `tx_index` ordinal. Use this to walk a wallet's full trade history forward in time - PnL recaps, tax-lot reconstruction, or backfills - paging with the keyset `cursor` rather than the latest N records.

User-keyed. GoldRush-native, so there is no upstream Hyperliquid `/info` equivalent.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userCompletedTradesByTime"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound on `close_time`. Required unless a `cursor` is supplied. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound on `close_time`. Defaults to current server time when omitted. |
| `cursor` | `string` | No | Pagination cursor in the form `"{close_time}_{tx_index}"`. When set, returns records strictly after this keyset (still oldest-first). Build it from the `close_time` and `tx_index` of the **last row** in the previous page. |
| `builder` | `string` | No | Optional filter. When set, returns only trades whose closing fill was routed through this builder address (`0x`-prefixed 42-character hex). |
| `dex` | `string` | No | Optional perp-DEX scope. `main_dex` for the canonical Hyperliquid perp DEX, or a HIP-3 DEX identifier. Omit to include trades across every DEX. |
| `limit` | `int` | No | Maximum number of records per page. Default `100`, maximum `500`. Values above the maximum are clamped. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userCompletedTradesByTime",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "startTime": 1735689600000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userCompletedTradesByTime",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    startTime: 1735689600000,
  }),
});

const trades = await response.json();

// Page forward: build the next cursor from the last row.
const last = trades[trades.length - 1];
const cursor = `${last.close_time}_${last.tx_index}`;
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userCompletedTradesByTime",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "startTime": 1735689600000,
    },
)

trades = response.json()

# Page forward: build the next cursor from the last row.
last = trades[-1]
cursor = f"{last['close_time']}_{last['tx_index']}"
```

## Response

An array of completed-trade objects, oldest-first by `(close_time, tx_index)`.

```json
[
  {
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "coin": "BTC",
    "position_type": "Long",
    "gross_pnl": "505.25",
    "net_pnl": "498.11",
    "funding_pnl": "0.98",
    "entry_px": "63642.5",
    "exit_px": "64150.75",
    "position_closed_size": "1.0171",
    "fees": "8.12",
    "fills": 12,
    "open_time": 1735689600000,
    "close_time": 1735776000000,
    "duration_ms": 86400000,
    "max_position_size": "1.0171",
    "maker_fills": 4,
    "builder": null,
    "tx_index": 0
  }
]
```

### Field descriptions

> **Note:** The PnL, price, size, and fee fields (`gross_pnl`, `net_pnl`, `funding_pnl`, `entry_px`, `exit_px`, `position_closed_size`, `fees`, `max_position_size`) are returned as **decimal strings**, preserving full precision. Counts (`fills`, `maker_fills`, `tx_index`) and timestamps (`open_time`, `close_time`, `duration_ms`) are JSON numbers. Do not parse the decimal strings as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | The wallet address the trades belong to (lowercase 0x-prefixed hex), echoing the request. |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; HIP-3 markets use the `dex:SYM` form (e.g. `"xyz:GOLD"`). |
| `position_type` | `string` | Direction of the round-trip position - `"Long"` or `"Short"`. |
| `gross_pnl` | `string` | Realized trading PnL for the round-trip in USDC, before fees and funding. |
| `net_pnl` | `string` | Net realized PnL in USDC - `gross_pnl` minus `fees` plus `funding_pnl`. |
| `funding_pnl` | `string` | Funding component of the round-trip in USDC (negative = paid, positive = received). |
| `entry_px` | `string` | Volume-weighted average entry price across the opening fills (carried at 10 decimal places, then trimmed of trailing zeros). |
| `exit_px` | `string` | Volume-weighted average exit price across the closing fills (carried at 10 decimal places, then trimmed of trailing zeros). |
| `position_closed_size` | `string` | Peak absolute position size reached during the round-trip - the same value as `max_position_size`. |
| `fees` | `string` | Total trading fees paid across all fills in the round-trip, in USDC. |
| `fills` | `int` | Total number of fills that make up the round-trip (opening and closing). |
| `open_time` | `int` | Unix timestamp in milliseconds of the first opening fill. |
| `close_time` | `int` | Unix timestamp in milliseconds of the closing fill that brought the position flat. |
| `duration_ms` | `int` | Round-trip duration in milliseconds - `close_time` minus `open_time`. |
| `max_position_size` | `string` | Peak absolute position size reached during the round-trip. |
| `maker_fills` | `int` | Number of fills in the round-trip that were on the maker side. |
| `builder` | `string | null` | Builder address routed through by the closing fill (`0x`-prefixed hex), or `null` when the closing fill carried no builder code. |
| `tx_index` | `int` | Per-`(user, close_time)` ordinal (0-based) that disambiguates trades sharing a `close_time`. Combine with `close_time` as `"{close_time}_{tx_index}"` to build the next-page `cursor`. This is a GoldRush paging ordinal, not Hyperliquid's block transaction index. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userCompletedTrades

fetch a wallet's most recent fully-closed round-trip trades, newest-first, each with realized PnL, funding, fees, and volume-weighted entry/exit prices.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### userTwapSliceFillsByTime

fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

### userAbstraction

fetch a user's account-abstraction mode.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userCompletedTrades | Hyperliquid Info API

**Credit Cost:** 10 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userCompletedTrades"` is used to fetch a wallet's most recent fully-closed round-trip trades, newest-first, each with realized PnL, funding, fees, and volume-weighted entry/exit prices.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush custom analytics product. **Not available on the public Hyperliquid node** - there is no `POST api.hyperliquid.xyz/info` equivalent. Served only from `POST hypercore.goldrushdata.com/info`.
- Each record is one **fully-closed round-trip position** (opened, then brought fully flat), reconstructed from the wallet's fills. Positions that are still open are not included.
- Returns up to `limit` records, newest-first (default `100`, max `500`).
- For a `close_time` window with forward paging, use [`userCompletedTradesByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-completed-trades-by-time). For one aggregate roll-up across all a wallet's trades, use [`userPnlSummary`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-pnl-summary).

Returns the latest `limit` fully-closed round-trip trades for a wallet, ordered newest-first by close time. Each row rolls up every fill that opened and then fully closed a position on one coin into a single record - realized gross and net PnL, the funding component, volume-weighted entry and exit prices, fees, fill counts, and the open/close timestamps. Use this when you want a wallet's recent trading outcomes without stepping through raw fills.

User-keyed. GoldRush-native, so there is no upstream Hyperliquid `/info` equivalent.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userCompletedTrades"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `builder` | `string` | No | Optional filter. When set, returns only trades whose closing fill was routed through this builder address (`0x`-prefixed 42-character hex). |
| `dex` | `string` | No | Optional perp-DEX scope. `main_dex` for the canonical Hyperliquid perp DEX, or a HIP-3 DEX identifier. Omit to include trades across every DEX. |
| `limit` | `int` | No | Maximum number of records to return. Default `100`, maximum `500`. Values above the maximum are clamped. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userCompletedTrades",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "limit": 100
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userCompletedTrades",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    limit: 100,
  }),
});

const trades = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userCompletedTrades",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "limit": 100,
    },
)

trades = response.json()
```

## Response

An array of completed-trade objects, newest-first by `close_time`.

```json
[
  {
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "coin": "BTC",
    "position_type": "Long",
    "gross_pnl": "505.25",
    "net_pnl": "498.11",
    "funding_pnl": "0.98",
    "entry_px": "63642.5",
    "exit_px": "64150.75",
    "position_closed_size": "1.0171",
    "fees": "8.12",
    "fills": 12,
    "open_time": 1735689600000,
    "close_time": 1735776000000,
    "duration_ms": 86400000,
    "max_position_size": "1.0171",
    "maker_fills": 4,
    "builder": null
  }
]
```

### Field descriptions

> **Note:** The PnL, price, size, and fee fields (`gross_pnl`, `net_pnl`, `funding_pnl`, `entry_px`, `exit_px`, `position_closed_size`, `fees`, `max_position_size`) are returned as **decimal strings**, preserving full precision. Counts (`fills`, `maker_fills`) and timestamps (`open_time`, `close_time`, `duration_ms`) are JSON numbers. Do not parse the decimal strings as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | The wallet address the trades belong to (lowercase 0x-prefixed hex), echoing the request. |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; HIP-3 markets use the `dex:SYM` form (e.g. `"xyz:GOLD"`). |
| `position_type` | `string` | Direction of the round-trip position - `"Long"` or `"Short"`. |
| `gross_pnl` | `string` | Realized trading PnL for the round-trip in USDC, before fees and funding. |
| `net_pnl` | `string` | Net realized PnL in USDC - `gross_pnl` minus `fees` plus `funding_pnl`. |
| `funding_pnl` | `string` | Funding component of the round-trip in USDC (negative = paid, positive = received). |
| `entry_px` | `string` | Volume-weighted average entry price across the opening fills (carried at 10 decimal places, then trimmed of trailing zeros). |
| `exit_px` | `string` | Volume-weighted average exit price across the closing fills (carried at 10 decimal places, then trimmed of trailing zeros). |
| `position_closed_size` | `string` | Peak absolute position size reached during the round-trip - the same value as `max_position_size`. |
| `fees` | `string` | Total trading fees paid across all fills in the round-trip, in USDC. |
| `fills` | `int` | Total number of fills that make up the round-trip (opening and closing). |
| `open_time` | `int` | Unix timestamp in milliseconds of the first opening fill. |
| `close_time` | `int` | Unix timestamp in milliseconds of the closing fill that brought the position flat. |
| `duration_ms` | `int` | Round-trip duration in milliseconds - `close_time` minus `open_time`. |
| `max_position_size` | `string` | Peak absolute position size reached during the round-trip. |
| `maker_fills` | `int` | Number of fills in the round-trip that were on the maker side. |
| `builder` | `string | null` | Builder address routed through by the closing fill (`0x`-prefixed hex), or `null` when the closing fill carried no builder code. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userCompletedTradesByTime

fetch a wallet's fully-closed round-trip trades within a close-time window, oldest-first, with a keyset cursor for forward paging.

### userAbstraction

fetch a user's account-abstraction mode.

### userBorrowLendInterest

fetch a user's borrow/lend interest accrual history.

### userFees

fetch a user's fee schedule and recent daily volume.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userFees | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userFees"` is used to fetch a user's fee schedule and recent daily volume.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userFees", "user": "..."}`.
- `feeSchedule` is the exchange-wide tier table; `userCrossRate` / `userAddRate` are the effective rates this user pays after VIP-tier, referral, and staking discounts.
- All rate and volume fields are decimal strings; a rate of `"0.00045"` means 4.5 basis points.

Returns a user's effective trading fees together with the exchange-wide fee schedule and the user's recent per-day traded volume. Use it to display the taker (cross) and maker (add) rates a wallet actually pays, and to reconstruct the tier table and discounts that produce them.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userFees"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userFees",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userFees",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const fees = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userFees",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

fees = response.json()
```

## Response

A single object with the user's recent daily volume, the exchange-wide `feeSchedule`, the user's effective rates, and any active discounts / trial state.

```json
{
  "dailyUserVlm": [
    {
      "date": "2026-07-09",
      "userCross": "587333.02",
      "userAdd": "1041946.77",
      "exchange": "3832824759.19"
    }
  ],
  "feeSchedule": {
    "cross": "0.00045",
    "add": "0.00015",
    "spotCross": "0.0007",
    "spotAdd": "0.0004",
    "referralDiscount": "0.04",
    "tiers": {
      "vip": [
        {
          "ntlCutoff": "5000000",
          "cross": "0.0004",
          "add": "0.00012",
          "spotCross": "0.0006",
          "spotAdd": "0.0003"
        }
      ],
      "mm": [
        {
          "makerFractionCutoff": "0.005",
          "add": "-0.00001"
        }
      ]
    },
    "stakingDiscountTiers": [
      { "bpsOfMaxSupply": "0.0", "discount": "0.0" },
      { "bpsOfMaxSupply": "0.1", "discount": "0.05" }
    ]
  },
  "userCrossRate": "0.000405",
  "userAddRate": "0.00015",
  "activeReferralDiscount": "0.0",
  "trial": null,
  "feeTrialReward": "0.0",
  "nextTrialAvailableTimestamp": null
}
```

### Field descriptions

> **Note:** All rate and volume fields (`userCross`, `userAdd`, `exchange`, `cross`, `add`, `userCrossRate`, `userAddRate`, and the tier / discount values) are returned as **decimal strings**. Do not parse them as floats. Rates are expressed as fractions of notional - `"0.00045"` = 4.5 bps.

| Field | Type | Description |
| --- | --- | --- |
| `dailyUserVlm` | `array` | Recent per-day traded volume, one entry per day. |
| `dailyUserVlm.date` | `string` | Calendar day in `YYYY-MM-DD` (UTC). |
| `dailyUserVlm.userCross` | `string` | The user's taker (cross) volume that day, in USDC. |
| `dailyUserVlm.userAdd` | `string` | The user's maker (add) volume that day, in USDC. |
| `dailyUserVlm.exchange` | `string` | Total exchange-wide volume that day, in USDC. |
| `feeSchedule` | `object` | Exchange-wide fee schedule - the base rates and the tier tables that discounts are applied against. |
| `feeSchedule.cross` | `string` | Base taker (cross) fee rate for perps. |
| `feeSchedule.add` | `string` | Base maker (add) fee rate for perps. |
| `feeSchedule.spotCross` | `string` | Base taker fee rate for spot. |
| `feeSchedule.spotAdd` | `string` | Base maker fee rate for spot. |
| `feeSchedule.referralDiscount` | `string` | Base referral discount, as a fraction of fees. |
| `feeSchedule.tiers` | `object` | Volume- and maker-based tier tables.  __RESPONSE_ROW__vip	array	VIP tiers keyed by notional-volume cutoff. Each entry: `ntlCutoff` (volume threshold) plus the `cross`, `add`, `spotCross`, and `spotAdd` rates at that tier. __RESPONSE_ROW__feeSchedule.mm	array	Market-maker tiers. Each entry: `makerFractionCutoff` (share-of-maker-volume threshold) and the reduced `add` (maker) rate at that tier. ">Staking-based discount tiers. Each entry: `bpsOfMaxSupply` (staked HYPE as basis points of max supply) and the `discount` (fraction of fees) at that tier. |



| Field | Type | Description |
| --- | --- | --- |
| `userCrossRate` | `string` | Effective taker (cross) rate this user pays, after all applicable discounts. |
| `userAddRate` | `string` | Effective maker (add) rate this user pays, after all applicable discounts. |
| `activeReferralDiscount` | `string` | Referral discount currently applied to the user, as a fraction of fees. |
| `trial` | `object | null` | Active fee-trial details, or `null` when the user has no active trial. |
| `feeTrialReward` | `string` | Reward accrued from the user's fee trial. |
| `nextTrialAvailableTimestamp` | `int | null` | Millisecond timestamp when the next fee trial becomes available, or `null` when not applicable. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userAbstraction

fetch a user's account-abstraction mode.

### userRateLimit

fetch a user's API rate-limit usage and cap.

### userRole

fetch a user's account role.

### userToMultiSigSigners

fetch the authorized signers for a multi-sig user.

### extraAgents

list a user's approved API-agent wallets.

### subAccounts

fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userFillsByTime | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userFillsByTime"` is used to fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userFillsByTime", "user": "...", "startTime": ...}`.
- Each response contains at most 2,000 fills; widen the window in chunks or page by advancing `startTime` if you need more.
- GoldRush serves this `type` from a dedicated HyperCore historical store, so windows older than upstream Hyperliquid’s 10,000-fill retention are still fulfilled.
- Use [`userFills`](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint/perpetuals) (no `Time` suffix) when you only need the most recent N fills without specifying a window.

Returns a single user’s fills bounded by a `**startTime, endTime)` window in milliseconds. Use this when you want fills since a specific moment - daily P&L recaps, post-deploy backfills, or rebuilding a tax ledger - rather than the most recent N fills.

User-keyed. The upstream Hyperliquid API caps each response at **2,000 fills**; page by advancing `startTime`. **NOT LIMITED TO THE 10,000 MOST RECENT FILLS.** GoldRush serves this `type` from a dedicated HyperCore historical store so windows extending past the upstream retention limit are fulfilled from GoldRush data rather than truncated.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userFillsByTime"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |
| `aggregateByTime` | `boolean` | No | When `true`, partial fills sharing the same timestamp are consolidated into one row. Default `false`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userFillsByTime",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "startTime": 1735689600000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userFillsByTime",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    startTime: 1735689600000,
  }),
});

const fills = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userFillsByTime",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "startTime": 1735689600000,
    },
)

fills = response.json()
```

## Response

An array of fill objects ordered by `time`.

```json
[
  {
    "coin": "BTC",
    "px": "43250.5",
    "sz": "0.1",
    "side": "B",
    "time": 1735689600000,
    "startPosition": "0",
    "dir": "Open Long",
    "closedPnl": "0",
    "hash": "0x6b9c0a4a3d54b0d4d6b1a0c4d8c9e7f2b6e5d3c2a1f0e9d8c7b6a5f4e3d2c1b0a",
    "oid": 95012345,
    "tid": 678900012345,
    "crossed": true,
    "fee": "2.16",
    "feeToken": "USDC"
  }
]
```

### Field descriptions

> **Note:** All numeric fields (`px`, `sz`, `startPosition`, `closedPnl`, `fee`, `builderFee`) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `px` | `string` | Fill execution price. |
| `sz` | `string` | Fill size. |
| `side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `startPosition` | `string` | Signed position size on the same coin immediately before this fill. |
| `dir` | `string` | Human-readable direction label - e.g. `"Open Long"`, `"Close Short"`, `"Buy"`, `"Sell"`. |
| `closedPnl` | `string` | Realized PnL in USDC attributable to this fill (zero when the fill opens or extends a position). |
| `hash` | `string` | L1 transaction hash that included this fill. |
| `oid` | `int` | Parent order ID. |
| `tid` | `int` | Unique trade ID. |
| `crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fee` | `string` | Trading fee paid for this fill, denominated in `feeToken`. |
| `feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `builderFee` | `string` | Optional. Builder fee paid for this fill if the order routed through a builder code. |
| `twapId` | `int | null` | Optional TWAP order ID if this fill is a slice of a TWAP order. |
| `cloid` | `string | null` | Optional client order ID if one was set at order placement. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userFills

fetch a user's most recent trade fills without specifying a time window.

### userTwapSliceFillsByTime

fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

### userTwapSliceFills

fetch a user's most recent TWAP slice fills for execution-quality analytics on algorithmic orders.

### userBorrowLendInterest

fetch a user's borrow/lend interest accrual history.

### userFunding

fetch a user's per-coin funding payment history within a time window for funding-only P&L attribution.

### userNonFundingLedgerUpdates

fetch a user's non-funding USDC ledger history (deposits, withdrawals, transfers, vault flows) within a time…

See all Hyperliquid endpoints: [Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## userFills | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userFills"` is used to fetch a user's most recent trade fills without specifying a time window.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userFills", "user": "..."}`.
- Each response contains at most 2,000 fills.

Returns the most recent fills for a user, up to 2,000. Use this when you need the latest trade activity without specifying a time window.

User-keyed. The upstream Hyperliquid API caps each response at **2,000 fills** per wallet.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userFills"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `aggregateByTime` | `boolean` | No | When `true`, partial fills sharing the same timestamp are consolidated into one row. Default `false`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userFills",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userFills",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const fills = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userFills",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

fills = response.json()
```

## Response

An array of fill objects ordered most-recent-first.

```json
[
  {
    "coin": "BTC",
    "px": "43250.5",
    "sz": "0.1",
    "side": "B",
    "time": 1735689600000,
    "startPosition": "0",
    "dir": "Open Long",
    "closedPnl": "0",
    "hash": "0x6b9c0a4a3d54b0d4d6b1a0c4d8c9e7f2b6e5d3c2a1f0e9d8c7b6a5f4e3d2c1b0a",
    "oid": 95012345,
    "tid": 678900012345,
    "crossed": true,
    "fee": "2.16",
    "feeToken": "USDC"
  }
]
```

### Field descriptions

> **Note:** All numeric fields (`px`, `sz`, `startPosition`, `closedPnl`, `fee`, `builderFee`) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `px` | `string` | Fill execution price. |
| `sz` | `string` | Fill size. |
| `side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `startPosition` | `string` | Signed position size on the same coin immediately before this fill. |
| `dir` | `string` | Human-readable direction label - e.g. `"Open Long"`, `"Close Short"`, `"Buy"`, `"Sell"`. |
| `closedPnl` | `string` | Realized PnL in USDC attributable to this fill (zero when the fill opens or extends a position). |
| `hash` | `string` | L1 transaction hash that included this fill. |
| `oid` | `int` | Parent order ID. |
| `tid` | `int` | Unique trade ID. |
| `crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fee` | `string` | Trading fee paid for this fill, denominated in `feeToken`. |
| `feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `builderFee` | `string` | Optional. Builder fee paid for this fill if the order routed through a builder code. |
| `twapId` | `int | null` | Optional TWAP order ID if this fill is a slice of a TWAP order. |
| `cloid` | `string | null` | Optional client order ID if one was set at order placement. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### userTwapSliceFills

fetch a user's most recent TWAP slice fills for execution-quality analytics on algorithmic orders.

### userTwapSliceFillsByTime

fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

### userBorrowLendInterest

fetch a user's borrow/lend interest accrual history.

### userFunding

fetch a user's per-coin funding payment history within a time window for funding-only P&L attribution.

### userNonFundingLedgerUpdates

fetch a user's non-funding USDC ledger history (deposits, withdrawals, transfers, vault flows) within a time…

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## userFunding | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userFunding"` is used to fetch a user's per-coin funding payment history within a time window for funding-only P&L attribution.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userFunding", "user": "..."}`.
- Use [`userNonFundingLedgerUpdates`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-non-funding-ledger-updates) for deposits, withdrawals, transfers, vault flows, liquidations, and other balance-moving events.

Returns a single user’s funding payment history within a `[startTime, endTime)` window. Each entry is one funding application: a coin, the rate that was applied, the position size at the time, and the resulting USDC delta (negative = paid, positive = received).

User-keyed. Use this for funding-only P&L attribution; use [userNonFundingLedgerUpdates](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-non-funding-ledger-updates) for everything else.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userFunding"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | No | Unix timestamp in milliseconds. Inclusive lower bound for the window. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userFunding",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "startTime": 1735689600000,
    "endTime": 1735776000000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userFunding",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    startTime: 1735689600000,
    endTime: 1735776000000,
  }),
});

const events = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userFunding",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "startTime": 1735689600000,
        "endTime": 1735776000000,
    },
)

events = response.json()
```

## Response

An array of funding event objects, one per applied funding interval and coin.

```json
[
  {
    "time": 1735689600000,
    "hash": "0x6b9c0a4a3d54b0d4d6b1a0c4d8c9e7f2b6e5d3c2a1f0e9d8c7b6a5f4e3d2c1b0a",
    "delta": {
      "type": "funding",
      "coin": "BTC",
      "usdc": "-50.25",
      "szi": "1.5",
      "fundingRate": "0.0001",
      "nSamples": null
    }
  }
]
```

### Field descriptions

> **Note:** All numeric `delta` fields are returned as **decimal strings**. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `time` | `int` | Unix timestamp in milliseconds when the funding payment was applied. |
| `hash` | `string` | L1 transaction hash that included the funding application. |
| `delta` | `object` | Funding-event payload. |
| `delta.type` | `string` | Always `"funding"` for entries returned by this endpoint. |
| `delta.coin` | `string` | Asset symbol the funding rate applied to. |
| `delta.usdc` | `string` | USDC delta credited to or debited from the account. Negative values are paid, positive values are received. |
| `delta.szi` | `string` | Signed position size at the time of application (positive = long, negative = short). |
| `delta.fundingRate` | `string` | The funding rate applied (decimal string, e.g. `"0.0001"` for 1 bp). |
| `delta.nSamples` | `int | null` | Optional - number of samples used by the upstream funding calculation. May be `null`. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userNonFundingLedgerUpdates

fetch a user's non-funding USDC ledger history (deposits, withdrawals, transfers, vault flows) within a time…

### userBorrowLendInterest

fetch a user's borrow/lend interest accrual history.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## userNonFundingLedgerUpdates | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userNonFundingLedgerUpdates"` is used to fetch a user's non-funding USDC ledger history (deposits, withdrawals, transfers, vault flows) within a time window.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userNonFundingLedgerUpdates", "user": "..."}`.
- Funding payments are not included here - use [`userFunding`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-funding).

Returns a single user’s USDC and account ledger history within a [startTime, endTime) window, excluding funding payments. Funding events are intentionally separated into their own type, userFunding, so applications can render fee accruals separately from balance-moving events.

User-keyed. Each entry carries a `delta` whose `type` discriminates the event variant - deposits, withdrawals, internal transfers, sub-account transfers, vault flows, liquidations, rewards claims, and similar.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userNonFundingLedgerUpdates"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | No | Unix timestamp in milliseconds. Inclusive lower bound for the window. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Inclusive upper bound. Defaults to current server time when omitted. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userNonFundingLedgerUpdates",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "startTime": 1735689600000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userNonFundingLedgerUpdates",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    startTime: 1735689600000,
  }),
});

const events = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userNonFundingLedgerUpdates",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "startTime": 1735689600000,
    },
)

events = response.json()
```

## Response

An array of ledger event objects. Each entry has `time`, `hash`, and a `delta` discriminated by `delta.type`.

```json
[
  {
    "time": 1735689600000,
    "hash": "0x6b9c0a4a3d54b0d4d6b1a0c4d8c9e7f2b6e5d3c2a1f0e9d8c7b6a5f4e3d2c1b0a",
    "delta": {
      "type": "vaultWithdraw",
      "vault": "0x1962905b0a2d0ce8907a92ed5f7a17fef3e1b53e",
      "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
      "requestedUsd": "1000.50",
      "commission": "10.00",
      "closingCost": "5.25",
      "basis": "950.00",
      "netWithdrawnUsd": "985.25"
    }
  }
]
```

### Field descriptions

> **Note:** All numeric `delta` fields are returned as **decimal strings**. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `time` | `int` | Unix timestamp in milliseconds when the event was applied. |
| `hash` | `string` | L1 transaction hash that produced the event. |
| `delta` | `object` | Event-specific payload. The shape depends on `delta.type`. The example above shows a `vaultWithdraw`; common discriminators include `deposit`, `withdraw`, `accountClassTransfer`, `internalTransfer`, `subAccountTransfer`, `spotTransfer`, `vaultDeposit`, `vaultWithdraw`, `vaultDistribution`, `vaultLeaderCommission`, `liquidation`, `rewardsClaim`, and others. See the [Hyperliquid `nonFundingLedgerUpdates` reference](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/info-endpoint) for the full discriminator table. |
| `delta.type` | `string` | Discriminator. Always present on every variant. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userFunding

fetch a user's per-coin funding payment history within a time window for funding-only P&L attribution.

### userBorrowLendInterest

fetch a user's borrow/lend interest accrual history.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-20_

{/* generated:hl-footer-end */}

---

## userPnlSummary | Hyperliquid Info API

**Credit Cost:** 10 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userPnlSummary"` is used to fetch one aggregate PnL summary for a wallet - realized PnL, win/loss rate, volume, fees, funding, active days, and traded pairs.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush custom analytics product. **Not available on the public Hyperliquid node** - there is no `POST api.hyperliquid.xyz/info` equivalent. Served only from `POST hypercore.goldrushdata.com/info`.
- Returns a **single aggregate object** for one wallet (not an array), rolled up from the wallet's fully-closed round-trip trades and trading activity.
- `startTime` / `endTime` are optional. When supplied they window the realized metrics; `accountAgeDays` and `tradedPairs` are always lifetime.
- `dex` scopes the trade aggregates and `tradedPairs`; `volumeTraded`, `daysActive`, and `accountAgeDays` are computed across all DEXes.
- For the underlying per-trade rows behind these totals, use [`userCompletedTrades`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-completed-trades) or [`userCompletedTradesByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-completed-trades-by-time).

Returns a single aggregate object summarizing a wallet's realized trading performance - net PnL, win and loss rates, trade count, notional volume, fees, funding, active-day count, account age, and the list of coins it has traded. Use this for leaderboard tiles, wallet profile headers, or a one-call PnL read instead of paging through completed trades.

User-keyed. GoldRush-native, so there is no upstream Hyperliquid `/info` equivalent.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userPnlSummary"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | No | Optional. Unix timestamp in milliseconds. Inclusive lower bound on `close_time` for the realized metrics. Omit for a lifetime summary. |
| `endTime` | `int` | No | Optional. Unix timestamp in milliseconds. Inclusive upper bound on `close_time` for the realized metrics. Defaults to current server time when a window is otherwise in play. |
| `dex` | `string` | No | Optional perp-DEX scope for the trade aggregates and `tradedPairs`. `main_dex` for the canonical Hyperliquid perp DEX, or a HIP-3 DEX identifier. Omit to aggregate across every DEX. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userPnlSummary",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userPnlSummary",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const summary = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userPnlSummary",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

summary = response.json()
```

## Response

A single aggregate object for the wallet.

```json
{
  "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  "totalPnl": "1245.67",
  "winRate": 0.6143,
  "lossRate": 0.3857,
  "totalTrades": 140,
  "volumeTraded": "1095452.80",
  "totalFees": "812.44",
  "totalFunding": "15.09",
  "daysActive": 42,
  "accountAgeDays": 88,
  "tradedPairs": ["BTC", "ETH", "HYPE"]
}
```

### Field descriptions

> **Note:** `totalPnl`, `totalFees`, and `totalFunding` are **decimal strings** (full precision); `volumeTraded` is a **fixed 2-decimal string**. `winRate` and `lossRate` are JSON **floats** (4 decimals). `totalTrades`, `daysActive`, and `accountAgeDays` are JSON numbers. Do not parse the decimal strings as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | The wallet address the summary belongs to (lowercase 0x-prefixed hex), echoing the request. |
| `totalPnl` | `string` | Net realized PnL in USDC across the completed trades in scope - trading PnL minus fees plus funding (the sum of per-trade `net_pnl`). |
| `winRate` | `number` | Fraction of completed trades with positive net PnL (`net_pnl > 0`), rounded to 4 decimals. `0.0` when the wallet has no completed trades. |
| `lossRate` | `number` | Fraction of completed trades with non-positive net PnL (`net_pnl <= 0`), rounded to 4 decimals. Equal to `1 - winRate`; break-even trades count as losses. |
| `totalTrades` | `int` | Number of fully-closed round-trip trades in scope. |
| `volumeTraded` | `string` | Total notional traded in USDC as a fixed 2-decimal string (e.g. `"1095452.80"`). Computed across all DEXes. |
| `totalFees` | `string` | Total trading fees paid in USDC across the completed trades in scope. |
| `totalFunding` | `string` | Total funding in USDC across the completed trades in scope (negative = net paid, positive = net received). |
| `daysActive` | `int` | Number of distinct UTC calendar days on which the wallet traded, within the window. Computed across all DEXes. |
| `accountAgeDays` | `int | null` | Whole days since the wallet's first-ever fill, counted inclusively (first day = 1). Lifetime and all-DEX - never windowed. `null` when the wallet has no recorded fills. A wallet whose first fill predates GoldRush's HyperCore coverage reads younger than its true age. |
| `tradedPairs` | `string[]` | Coin symbols the wallet has traded, in chronological order of first fill. Scoped to `dex` when supplied, otherwise all DEXes. Lifetime (not windowed). |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userAbstraction

fetch a user's account-abstraction mode.

### userBorrowLendInterest

fetch a user's borrow/lend interest accrual history.

### userCompletedTrades

fetch a wallet's most recent fully-closed round-trip trades, newest-first, each with realized PnL, funding, fees, and volume-weighted entry/exit prices.

### userCompletedTradesByTime

fetch a wallet's fully-closed round-trip trades within a close-time window, oldest-first, with a keyset cursor for forward paging.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userRateLimit | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userRateLimit"` is used to fetch a user's API rate-limit usage and cap.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userRateLimit", "user": "..."}`.
- This reports Hyperliquid's own address-based L1 request allowance; it is unrelated to your GoldRush credit budget.
- The request cap (`nRequestsCap`) is a function of the account's cumulative traded volume (`cumVlm`), so higher-volume accounts are granted more requests.

Returns the address-based API rate-limit accounting Hyperliquid maintains for a wallet: cumulative traded volume, how many requests have been used, the current cap, and any surplus beyond it. Use it to monitor how much of an account's request allowance remains.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userRateLimit"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userRateLimit",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userRateLimit",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const rateLimit = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userRateLimit",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

rate_limit = response.json()
```

## Response

```json
{
  "cumVlm": "471728188.87",
  "nRequestsUsed": 370317503,
  "nRequestsCap": 471738188,
  "nRequestsSurplus": 0
}
```

### Field descriptions

> **Note:** `cumVlm` is returned as a **decimal string**. Do not parse it as a float.

| Field | Type | Description |
| --- | --- | --- |
| `cumVlm` | `string` | Cumulative traded volume for the account, in USDC. |
| `nRequestsUsed` | `int` | Number of requests consumed so far against the address allowance. |
| `nRequestsCap` | `int` | Current maximum number of requests allowed for the account. |
| `nRequestsSurplus` | `int` | Requests made beyond the cap; `0` when the account is within its limit. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userAbstraction

fetch a user's account-abstraction mode.

### userFees

fetch a user's fee schedule and recent daily volume.

### userRole

fetch a user's account role.

### userToMultiSigSigners

fetch the authorized signers for a multi-sig user.

### extraAgents

list a user's approved API-agent wallets.

### subAccounts

fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userRole | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userRole"` is used to fetch a user's account role.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userRole", "user": "..."}`.
- The `role` value is one of `missing`, `user`, `agent`, `vault`, or `subAccount`.
- The `subAccount` and `agent` roles additionally carry a `data` object identifying the controlling master account.

Returns the role a wallet plays on HyperCore. Most trading wallets are plain user accounts; this type also distinguishes API agent wallets, vault addresses, and subAccounts. For a subAccount (and for an agent), a nested data object carries the master account address that controls the wallet.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userRole"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userRole",
    "user": "0x2b804617c6f63c040377e95bb276811747006f4b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userRole",
    user: "0x2b804617c6f63c040377e95bb276811747006f4b",
  }),
});

const role = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userRole",
        "user": "0x2b804617c6f63c040377e95bb276811747006f4b",
    },
)

role = response.json()
```

## Response

A single object with a `role` discriminator. A plain trading wallet returns `{"role": "user"}`; a sub-account additionally returns its controlling master under `data`.

```json
{
  "role": "subAccount",
  "data": {
    "master": "0x399965e15d4e61ec3529cc98b7f7ebb93b733336"
  }
}
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `role` | `string` | Account role. One of: - `missing` - the address has never interacted with HyperCore. - `user` - an ordinary trading account. - `agent` - an API agent (API wallet) that signs on behalf of a master. - `vault` - a vault address. - `subAccount` - a sub-account owned by a master account. |
| `data` | `object` | Present only for the `subAccount` and `agent` roles. |
| `data.master` | `string` | Address of the master account that controls this sub-account / agent. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userAbstraction

fetch a user's account-abstraction mode.

### userFees

fetch a user's fee schedule and recent daily volume.

### userRateLimit

fetch a user's API rate-limit usage and cap.

### userToMultiSigSigners

fetch the authorized signers for a multi-sig user.

### extraAgents

list a user's approved API-agent wallets.

### subAccounts

fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userToMultiSigSigners | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userToMultiSigSigners"` is used to fetch the authorized signers for a multi-sig user.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userToMultiSigSigners", "user": "..."}`.
- Returns `null` when the queried wallet is not a multi-sig account.
- A multi-sig account has at most 10 authorized signers; `threshold` is the minimum number that must sign to authorize an action.

Returns the authorized-signer configuration for a wallet that has been converted to a multi-sig account: the set of addresses allowed to sign for it, and the minimum number of signatures (threshold) required to authorize an action. Returns null for ordinary (non-multi-sig) wallets.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userToMultiSigSigners"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userToMultiSigSigners",
    "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userToMultiSigSigners",
    user: "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
  }),
});

const signers = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userToMultiSigSigners",
        "user": "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    },
)

signers = response.json()
```

## Response

An object describing the multi-sig signer set, or `null` when the queried wallet is not a multi-sig account.

```json
{
  "authorizedUsers": [
    "0x2ba553d9f990a3b66b03b2dc0d030dfc1c061036",
    "0x399965e15d4e61ec3529cc98b7f7ebb93b733336"
  ],
  "threshold": 2
}
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `authorizedUsers` | `array` | Addresses authorized to sign for the multi-sig account. |
| `threshold` | `int` | Minimum number of authorized signatures required to execute an action. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userAbstraction

fetch a user's account-abstraction mode.

### userFees

fetch a user's fee schedule and recent daily volume.

### userRateLimit

fetch a user's API rate-limit usage and cap.

### userRole

fetch a user's account role.

### extraAgents

list a user's approved API-agent wallets.

### subAccounts

fetch a master wallet's sub-accounts along with their full perp and spot state in a single call.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## userTwapSliceFillsByTime | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userTwapSliceFillsByTime"` is used to fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userTwapSliceFillsByTime", "user": "...", "startTime": ...}`.
- Each response contains at most 2,000 slice fills; widen the window in chunks or page by advancing `startTime` if you need more.
- GoldRush serves this `type` from a dedicated HyperCore historical store, so windows older than upstream Hyperliquid’s 10,000-fill retention are still fulfilled.
- TWAP slice fills have a `hash` of all zeros - use that, or the presence of `twapId`, to distinguish them from regular fills.
- Use [`userTwapSliceFills`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-twap-slice-fills) (no `ByTime` suffix) when you only need the most recent N slice fills without specifying a window.

Returns a single user's TWAP slice fills bounded by a `**startTime, endTime)` window in milliseconds. Each entry is a `{fill, twapId}` pair, where `twapId` ties the slice back to its parent TWAP order. Use this when you want execution-quality data for TWAP orders within a specific window - daily slice recaps, post-deploy backfills, or reconciling realized TWAP execution against benchmarks.

User-keyed. The upstream Hyperliquid API caps each response at **2,000 slice fills**; page by advancing `startTime`. **NOT LIMITED TO THE 10,000 MOST RECENT FILLS.** GoldRush serves this `type` from a dedicated HyperCore historical store so windows extending past the upstream retention limit are fulfilled from GoldRush data rather than truncated.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userTwapSliceFillsByTime"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |
| `startTime` | `int` | Yes | Unix timestamp in milliseconds. Inclusive lower bound. |
| `endTime` | `int` | No | Unix timestamp in milliseconds. Exclusive upper bound. Defaults to current server time when omitted. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userTwapSliceFillsByTime",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "startTime": 1735689600000
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userTwapSliceFillsByTime",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    startTime: 1735689600000,
  }),
});

const slices = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userTwapSliceFillsByTime",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
        "startTime": 1735689600000,
    },
)

slices = response.json()
```

## Response

An array of TWAP slice fill objects ordered by `time`.

```json
[
  {
    "fill": {
      "closedPnl": "0.0",
      "coin": "AVAX",
      "crossed": true,
      "dir": "Open Long",
      "hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
      "oid": 90542681,
      "px": "18.435",
      "side": "B",
      "startPosition": "26.86",
      "sz": "93.53",
      "time": 1681222254710,
      "fee": "0.01",
      "feeToken": "USDC",
      "tid": 118906512037719
    },
    "twapId": 3156
  }
]
```

### Field descriptions

> **Note:** All numeric `fill` fields (`px`, `sz`, `startPosition`, `closedPnl`, `fee`) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `fill` | `object` | The slice's fill payload - the same shape as one entry from [`userFillsByTime`**. |
| `fill.coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `fill.px` | `string` | Fill execution price for this slice. |
| `fill.sz` | `string` | Slice fill size. |
| `fill.side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `fill.time` | `int` | Unix timestamp in milliseconds when the slice executed. |
| `fill.startPosition` | `string` | Signed position size on the same coin immediately before this slice. |
| `fill.dir` | `string` | Human-readable direction label - e.g. `"Open Long"`, `"Close Short"`, `"Buy"`, `"Sell"`. |
| `fill.closedPnl` | `string` | Realized PnL in USDC attributable to this slice (zero when the slice opens or extends a position). |
| `fill.hash` | `string` | All-zero (`0x000…000`) for TWAP slice fills - the distinguishing marker versus regular fills, which carry an L1 transaction hash. |
| `fill.oid` | `int` | Order ID for the slice. |
| `fill.tid` | `int` | Unique trade ID for the slice. |
| `fill.crossed` | `boolean` | `true` when the slice came from the taker side, `false` when it was the maker side. |
| `fill.fee` | `string` | Trading fee paid for this slice, denominated in `feeToken`. |
| `fill.feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `twapId` | `int` | Identifier of the parent TWAP order. Multiple slice fills from the same TWAP share this value - group by `twapId` to reconstruct per-TWAP execution. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userTwapSliceFills

fetch a user's most recent TWAP slice fills for execution-quality analytics on algorithmic orders.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### builderFillsByTime

fetch a builder’s attributed trade fills within a time window for revenue attribution and fee accounting.

### builderFills

fetch a builder’s most recent attributed trade fills for revenue attribution and order-flow analytics.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-19_

{/* generated:hl-footer-end */}

---

## userTwapSliceFills | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userTwapSliceFills"` is used to fetch a user's most recent TWAP slice fills for execution-quality analytics on algorithmic orders.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userTwapSliceFills", "user": "..."}`.
- Each response contains at most 2,000 most recent TWAP slice fills. Older slices beyond that window are not retrievable from this endpoint.
- TWAP slice fills have a `hash` of all zeros - use that, or the presence of `twapId`, to distinguish them from regular fills.
- Use [`userFillsByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-fills-by-time) when you want all fills (regular + TWAP slices) for a wallet within a time window; each TWAP slice there carries the same `twapId` field.

Returns a single user’s most recent TWAP slice fills - each individual slice executed as part of a larger TWAP (Time-Weighted Average Price) order. Every entry is a `{fill, twapId}` pair, where `twapId` ties the slice back to its parent TWAP order. Multiple slices from the same TWAP share the same `twapId`.

User-keyed. Use this when you want execution-quality data for TWAP orders specifically - slippage per slice, fills-per-TWAP, realized average price - rather than the unified fills feed from [userFillsByTime](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-fills-by-time).

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userTwapSliceFills"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userTwapSliceFills",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userTwapSliceFills",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const slices = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userTwapSliceFills",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

slices = response.json()
```

## Response

An array of TWAP slice fill objects, most recent first.

```json
[
  {
    "fill": {
      "closedPnl": "0.0",
      "coin": "AVAX",
      "crossed": true,
      "dir": "Open Long",
      "hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
      "oid": 90542681,
      "px": "18.435",
      "side": "B",
      "startPosition": "26.86",
      "sz": "93.53",
      "time": 1681222254710,
      "fee": "0.01",
      "feeToken": "USDC",
      "tid": 118906512037719
    },
    "twapId": 3156
  }
]
```

### Field descriptions

> **Note:** All numeric `fill` fields (`px`, `sz`, `startPosition`, `closedPnl`, `fee`) are returned as **decimal strings**, preserving upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `fill` | `object` | The slice's fill payload - the same shape as one entry from **`userFillsByTime`**. |
| `fill.coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `fill.px` | `string` | Fill execution price for this slice. |
| `fill.sz` | `string` | Slice fill size. |
| `fill.side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `fill.time` | `int` | Unix timestamp in milliseconds when the slice executed. |
| `fill.startPosition` | `string` | Signed position size on the same coin immediately before this slice. |
| `fill.dir` | `string` | Human-readable direction label - e.g. `"Open Long"`, `"Close Short"`, `"Buy"`, `"Sell"`. |
| `fill.closedPnl` | `string` | Realized PnL in USDC attributable to this slice (zero when the slice opens or extends a position). |
| `fill.hash` | `string` | All-zero (`0x000…000`) for TWAP slice fills - the distinguishing marker versus regular fills, which carry an L1 transaction hash. |
| `fill.oid` | `int` | Order ID for the slice. |
| `fill.tid` | `int` | Unique trade ID for the slice. |
| `fill.crossed` | `boolean` | `true` when the slice came from the taker side, `false` when it was the maker side. |
| `fill.fee` | `string` | Trading fee paid for this slice, denominated in `feeToken`. |
| `fill.feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `twapId` | `int` | Identifier of the parent TWAP order. Multiple slice fills from the same TWAP share this value - group by `twapId` to reconstruct per-TWAP execution. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userTwapSliceFillsByTime

fetch a user's TWAP slice fills within a time window for execution-quality reconciliation on algorithmic orders.

### userFills

fetch a user's most recent trade fills without specifying a time window.

### userFillsByTime

fetch a user’s trade fills within a time window for P&L recaps and tax ledger reconstruction.

### builderFills

fetch a builder’s most recent attributed trade fills for revenue attribution and order-flow analytics.

### builderFillsByTime

fetch a builder’s attributed trade fills within a time window for revenue attribution and fee accounting.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-13_

{/* generated:hl-footer-end */}

---

## userVaultEquities | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "userVaultEquities"` is used to fetch a user's locked vault equity positions across all vaults they have deposited into.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "userVaultEquities", "user": "..."}`.

Returns the wallet’s per-vault equity: one entry per vault the user has deposited into, with the locked amount and the timestamp at which that equity becomes unlockable.

User-keyed. The result is `[]` for wallets that haven’t deposited into any vault.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"userVaultEquities"`. |
| `user` | `string` | Yes | The wallet address (lowercase 0x-prefixed hex). |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "userVaultEquities",
    "user": "0x2b804617c6f63c040377e95bb276811747006f4b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "userVaultEquities",
    user: "0x2b804617c6f63c040377e95bb276811747006f4b",
  }),
});

const equities = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "userVaultEquities",
        "user": "0x2b804617c6f63c040377e95bb276811747006f4b",
    },
)

equities = response.json()
```

## Response

An array of vault equity entries.

```json
[
  {
    "vaultAddress": "0x1962905b0a2d0ce8907a92ed5f7a17fef3e1b53e",
    "equity": "5000.50",
    "lockedUntilTimestamp": 1741132800000
  }
]
```

### Field descriptions

> **Note:** `equity` is returned as a **decimal string**, preserving upstream precision. Do not parse it as a float - keep it as a string or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `vaultAddress` | `string` | Vault contract address (0x-prefixed hex). |
| `equity` | `string` | User's equity in this vault, in USD. |
| `lockedUntilTimestamp` | `int` | Unix timestamp in milliseconds at which this equity becomes unlockable. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### vaultDetails

fetch detailed information for a specific vault.

### vaultSummaries

list summary information for every vault on the platform.

### leadingVaults

list the vaults a user leads.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-23_

{/* generated:hl-footer-end */}

---

## validatorL1Votes | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "validatorL1Votes"}`.
- Each entry is an L1 governance action currently awaiting validator votes, with an `expireTime` (ms) after which the pending vote lapses.
- The `action` object is a tagged variant; its inner shape depends on the specific L1 action being voted on (the example below shows a `settleOutcome` action).
- This is a global, non-user-keyed type.

Returns the pending validator L1 governance votes - the L1 actions currently awaiting validator approval. Each entry pairs an expireTime with the action under vote.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"validatorL1Votes"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "validatorL1Votes"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "validatorL1Votes",
  }),
});

const votes = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "validatorL1Votes"},
)

votes = response.json()
```

## Response

An array of pending L1 action votes. Empty when no L1 action is awaiting votes.

```json
[
  {
    "expireTime": 1785021897017,
    "action": {
      "O": {
        "settleOutcome": {
          "outcome": 855,
          "settleFraction": "0",
          "details": "...",
          "nameAndDescription": ["...", "..."]
        }
      }
    }
  }
]
```

### Field descriptions

| Field | Type | Description |
| --- | --- | --- |
| `[n]` | `object` | A pending L1 governance action awaiting validator votes. |
| `[n].expireTime` | `int` | Unix timestamp in milliseconds at which this pending vote expires. |
| `[n].action` | `object` | The L1 governance action under vote. A tagged variant whose inner shape depends on the action type - treat it as an opaque object unless you are decoding a known action. The example shows a `settleOutcome` action carrying the target `outcome` id, a `settleFraction`, and descriptive metadata. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### exchangeStatus

fetch the current exchange operational status.

### liquidatable

list accounts currently eligible for liquidation.

### marginTable

fetch the margin-tier (leverage-bracket) table for a given margin table id.

### maxBuilderFee

fetch the maximum builder fee a user has approved for a given builder.

### maxMarketOrderNtls

fetch the maximum market-order notional for each leverage bucket.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## vaultDetails | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "vaultDetails"` is used to fetch detailed information for a specific vault.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "vaultDetails", "vaultAddress": "..."}`.
- `vaultAddress` is required; the optional `user` field populates `followerState` with that wallet's position in the vault.
- `portfolio` is an array of `[period, series]` pairs bucketed by `day`, `week`, `month`, `allTime`, and their `perp*` variants.
- Aggregate stats (`apr`, `leaderFraction`, `leaderCommission`, `maxDistributable`, `maxWithdrawable`) are JSON numbers, while position, equity, and history values are decimal strings.
- For a lightweight list across all vaults, use [vaultSummaries](https://goldrush.dev/docs/api-reference/hyperliquid-info/vault-summaries).

Returns the full detail for a single vault: identity (name, address, leader, description), time-bucketed performance history (portfolio), headline stats (apr, distributable and withdrawable amounts), the follower roster, and the vault's relationship to any parent or child vaults.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"vaultDetails"`. |
| `vaultAddress` | `string` | Yes | The vault contract address (lowercase 0x-prefixed hex). |
| `user` | `string` | No | Optional wallet address (lowercase 0x-prefixed hex). When supplied, `followerState` is populated with that wallet's position in the vault. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "vaultDetails",
    "vaultAddress": "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "vaultDetails",
    vaultAddress: "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303",
  }),
});

const vault = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "vaultDetails",
        "vaultAddress": "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303",
    },
)

vault = response.json()
```

## Response

A single object describing the vault.

```json
{
  "name": "Hyperliquidity Provider (HLP)",
  "vaultAddress": "0xdfc24b077bc1425ad1dea75bcb6f8158e10df303",
  "leader": "0x677d831aef5328190852e24f13c46cac05f984e7",
  "description": "This community-owned vault provides liquidity to Hyperliquid through multiple market making strategies, performs liquidations, and accrues platform fees.",
  "portfolio": [
    [
      "day",
      {
        "accountValueHistory": [[1784713601558, "248732255.46"]],
        "pnlHistory": [[1784713601558, "0.0"]],
        "vlm": "0.0"
      }
    ],
    ["week", { "accountValueHistory": [], "pnlHistory": [], "vlm": "0.0" }],
    ["allTime", { "accountValueHistory": [], "pnlHistory": [], "vlm": "0.0" }]
  ],
  "apr": 0.36387129259090006,
  "followerState": null,
  "leaderFraction": 0.0007904828725729887,
  "leaderCommission": 0,
  "followers": [
    {
      "user": "0x005844b2ffb2e122cf4244be7dbcb4f84924907c",
      "vaultEquity": "714491.71026243",
      "pnl": "3203.43026143",
      "allTimePnl": "79843.74476743",
      "daysFollowing": 388,
      "vaultEntryTime": 1700926145201,
      "lockupUntil": 1734824439201
    }
  ],
  "maxDistributable": 94856870.164485,
  "maxWithdrawable": 742557.680863,
  "isClosed": false,
  "relationship": {
    "type": "parent",
    "data": {
      "childAddresses": [
        "0x010461c14e146ac35fe42271bdc1134ee31c703a",
        "0x2e3d94f0562703b25c83308a05046ddaf9a8dd14"
      ]
    }
  },
  "allowDeposits": true,
  "alwaysCloseOnWithdraw": false
}
```

### Field descriptions

> **Note:** Position, equity, and history values (`portfolio` account-value/PnL samples, `vlm`, and follower `vaultEquity`/`pnl`/`allTimePnl`) are returned as **decimal strings**. The aggregate stats `apr`, `leaderFraction`, `leaderCommission`, `maxDistributable`, and `maxWithdrawable` are returned as JSON **numbers**.

| Field | Type | Description |
| --- | --- | --- |
| `name` | `string` | Vault name. |
| `vaultAddress` | `string` | Vault contract address (0x-prefixed hex). |
| `leader` | `string` | Vault leader (manager) address. |
| `description` | `string` | Free-text description of the vault's strategy. |
| `portfolio` | `array` | Time-bucketed performance history. Each element is a `[period, series]` pair, where `period` is one of `day`, `week`, `month`, `allTime`, `perpDay`, `perpWeek`, `perpMonth`, or `perpAllTime`, and `series` holds the account-value and PnL time series for that period. |
| `portfolio.accountValueHistory` | `array` | `[timestampMs, accountValue]` samples. Account value is a decimal string. |
| `portfolio.pnlHistory` | `array` | `[timestampMs, pnl]` samples. PnL is a decimal string. |
| `portfolio.vlm` | `string` | Traded volume over the period, as a decimal string. |
| `apr` | `number` | Annualized return as a raw fraction (e.g. `0.3639` = 36.39%). |
| `followerState` | `object | null` | The requesting `user`'s follower state in this vault when the optional `user` field is supplied; `null` otherwise. |
| `leaderFraction` | `number` | Fraction of the vault's equity held by the leader. |
| `leaderCommission` | `number` | Leader's commission rate (fraction of follower profits). |
| `followers` | `array` | Per-follower positions in the vault. |
| `followers.user` | `string` | Follower wallet address (0x-prefixed hex). |
| `followers.vaultEquity` | `string` | Follower's current equity in the vault, in USD (decimal string). |
| `followers.pnl` | `string` | Follower's current-period PnL (decimal string). |
| `followers.allTimePnl` | `string` | Follower's all-time PnL in the vault (decimal string). |
| `followers.daysFollowing` | `int` | Number of days the follower has been in the vault. |
| `followers.vaultEntryTime` | `int` | Unix timestamp (ms) at which the follower entered the vault. |
| `followers.lockupUntil` | `int` | Unix timestamp (ms) until which the follower's equity is locked. |
| `maxDistributable` | `number` | Maximum amount currently distributable from the vault, in USD. |
| `maxWithdrawable` | `number` | Maximum amount the leader can currently withdraw, in USD. |
| `isClosed` | `boolean` | Whether the vault is closed. |
| `relationship` | `object` | Relationship metadata for the vault. |
| `relationship.type` | `string` | Relationship type - `"normal"` for a standalone vault, or `"parent"` / `"child"` for linked vaults. |
| `relationship.data` | `object` | Present for parent/child relationships. For a `parent`, contains `childAddresses` (an array of child vault addresses); for a `child`, identifies the parent vault. |
| `allowDeposits` | `boolean` | Whether the vault currently accepts new deposits. |
| `alwaysCloseOnWithdraw` | `boolean` | Whether a withdrawal always fully closes the follower's position. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### vaultSummaries

list summary information for every vault on the platform.

### userVaultEquities

fetch a user's locked vault equity positions across all vaults they have deposited into.

### leadingVaults

list the vaults a user leads.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## vaultSummaries | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "vaultSummaries"` is used to list summary information for every vault on the platform.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "vaultSummaries"}`.
- Returns one entry per vault on the platform. The array may be empty depending on platform state.
- `relationship.type` distinguishes standalone vaults (`"normal"`) from parent/child vault relationships.
- This is a global, non-user-keyed type; `tvl` is a decimal string.
- For a single vault's full breakdown (portfolio history, followers, APR), use [vaultDetails](https://goldrush.dev/docs/api-reference/hyperliquid-info/vault-details).

Returns summary information for every vault on the platform, one entry per vault: its name, address, leader, total value locked, closed flag, relationship type, and creation time. Use vaultDetails for a single vault's full breakdown.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"vaultSummaries"`. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "vaultSummaries"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "vaultSummaries",
  }),
});

const vaults = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={"type": "vaultSummaries"},
)

vaults = response.json()
```

## Response

An array of vault-summary objects, one per vault. May be empty depending on platform state.

```json
[
  {
    "name": "BlockChain OG",
    "vaultAddress": "0xb9612144b6783f43191c09a7e56333f805ae12dd",
    "leader": "0xc7c6cf1f1a5c5ccb025416b24bbfa678dc5922e7",
    "tvl": "101.0",
    "isClosed": false,
    "relationship": {
      "type": "normal"
    },
    "createTimeMillis": 1773644731666
  }
]
```

### Field descriptions

> **Note:** `tvl` is returned as a **decimal string**, preserving upstream precision. Do not parse it as a float - keep it as a string or use a fixed-precision decimal type.

| Field | Type | Description |
| --- | --- | --- |
| `name` | `string` | Vault name. |
| `vaultAddress` | `string` | Vault contract address (0x-prefixed hex). |
| `leader` | `string` | Vault leader (manager) address. |
| `tvl` | `string` | Total value locked in the vault, in USD, as a decimal string. |
| `isClosed` | `boolean` | Whether the vault is closed. |
| `relationship` | `object` | Relationship metadata for the vault. |
| `relationship.type` | `string` | Relationship type (e.g. `"normal"` for a standalone vault, or `"parent"` / `"child"` for linked vaults). |
| `createTimeMillis` | `int` | Vault creation timestamp (Unix ms). |

{/* generated:hl-linkhub-start */}

## Related endpoints


### vaultDetails

fetch detailed information for a specific vault.

### userVaultEquities

fetch a user's locked vault equity positions across all vaults they have deposited into.

### leadingVaults

list the vaults a user leads.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-08-17_

{/* generated:hl-footer-end */}

---

## webData2 | Hyperliquid Info API

**Credit Cost:** 1 per call


**Processing:** Realtime

The Hyperliquid info endpoint with `type: "webData2"` is used to fetch the composite snapshot the Hyperliquid web app uses for a wallet in a single call.

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-equal to `POST api.hyperliquid.xyz/info` with `{"type": "webData2", "user": "0x..."}`.

Returns the same composite payload the Hyperliquid web frontend pulls on page load for a given wallet: perp clearinghouse state, spot balances, open orders with trigger metadata, recent fills, and assorted UI-side context.

User-keyed. Use this when you want a single round-trip to populate a dashboard for a wallet.

## Endpoint

```
POST https://hypercore.goldrushdata.com/info
Authorization: Bearer
Content-Type: application/json
```

## Request

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `type` | `string` | Yes | Always `"webData2"`. |
| `user` | `string` | Yes | Wallet address (lowercase `0x`-prefixed 42-character hex). The payload is keyed to this user. |

### Example

```bash cURL
curl -X POST https://hypercore.goldrushdata.com/info \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "webData2",
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b"
  }'
```

```typescript TypeScript
const response = await fetch("https://hypercore.goldrushdata.com/info", {
  method: "POST",
  headers: {
    "Authorization": `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    "Content-Type": "application/json",
  },
  body: JSON.stringify({
    type: "webData2",
    user: "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  }),
});

const dashboard = await response.json();
```

```python Python
import os, requests

response = requests.post(
    "https://hypercore.goldrushdata.com/info",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
    json={
        "type": "webData2",
        "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    },
)

dashboard = response.json()
```

## Response

The response is a single composite object. The example below shows one representative element of each array; in practice `meta.universe`, `assetCtxs`, `spotAssetCtxs`, and `openOrders` each contain many entries.

```json
{
  "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
  "isVault": true,
  "agentAddress": null,
  "agentValidUntil": null,
  "serverTime": 1781881474980,
  "cumLedger": "6332392.6399999997",
  "totalVaultEquity": "0.0",
  "perpsAtOpenInterestCap": ["CANTO", "FTM", "JELLY"],
  "twapStates": [],
  "leadingVaults": [],
  "clearinghouseState": {
    "marginSummary": {
      "accountValue": "3007919.6080829999",
      "totalNtlPos": "3459573.844978",
      "totalRawUsd": "3271201.7188229999",
      "totalMarginUsed": "172978.692196"
    },
    "crossMarginSummary": { "...": "same shape as marginSummary" },
    "crossMaintenanceMarginUsed": "...",
    "withdrawable": "...",
    "time": 1781881474980,
    "assetPositions": [
      {
        "type": "oneWay",
        "position": {
          "coin": "BTC",
          "szi": "-0.67076",
          "leverage": { "type": "cross", "value": 20 },
          "entryPx": "62884.6",
          "positionValue": "42329.65132",
          "unrealizedPnl": "-149.163124",
          "returnOnEquity": "-0.070726125",
          "liquidationPx": "4451986.8072480513",
          "marginUsed": "2116.482566",
          "maxLeverage": 50,
          "cumFunding": {
            "allTime": "167037.152562",
            "sinceOpen": "-63.255648",
            "sinceChange": "0.0"
          }
        }
      }
    ]
  },
  "meta": {
    "collateralToken": 0,
    "marginTables": [],
    "universe": [
      { "szDecimals": 5, "name": "BTC", "maxLeverage": 40, "marginTableId": 56 }
    ]
  },
  "assetCtxs": [
    {
      "funding": "0.0000125",
      "openInterest": "30871.17824",
      "prevDayPx": "63776.0",
      "dayNtlVlm": "2564601901.510225296",
      "premium": "-0.000633553",
      "oraclePx": "63136.0",
      "markPx": "63107.0",
      "midPx": "63095.5",
      "impactPxs": ["63095.0", "63096.0"],
      "dayBaseVlm": "40824.8194300001"
    }
  ],
  "spotAssetCtxs": [
    {
      "coin": "PURR/USDC",
      "prevDayPx": "0.094397",
      "dayNtlVlm": "1940712.1805890012",
      "markPx": "0.10119",
      "midPx": "0.101275",
      "circulatingSupply": "595243631.3874200583",
      "totalSupply": "595243637.9101999998",
      "dayBaseVlm": "20336991.0"
    }
  ],
  "openOrders": [
    {
      "coin": "APE",
      "side": "A",
      "limitPx": "0.13155",
      "sz": "5187.6",
      "oid": 473960008142,
      "timestamp": 1781881474980,
      "triggerCondition": "N/A",
      "isTrigger": false,
      "triggerPx": "0.0",
      "children": [],
      "isPositionTpsl": false,
      "reduceOnly": false,
      "orderType": "Limit",
      "origSz": "5187.6",
      "tif": "Alo",
      "cloid": null
    }
  ]
}
```

### Field descriptions

> **Note:** All numeric balances, prices, and sizes are returned as **decimal strings** with full upstream precision. Do not parse them as floats - keep them as strings or use a fixed-precision decimal type. Timestamps (`serverTime`, `time`, `timestamp`) are integer Unix milliseconds.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string` | Echo of the wallet address requested. |
| `isVault` | `boolean` | `true` when the wallet is a Hyperliquid vault address. |
| `agentAddress` | `string | null` | Active API agent address if one is registered for the wallet, otherwise `null`. |
| `agentValidUntil` | `int | null` | Expiry of the API agent in Unix milliseconds, or `null` when no agent is registered. |
| `serverTime` | `int` | HyperCore server time (Unix milliseconds) at the moment the snapshot was assembled. |
| `cumLedger` | `string` | Cumulative non-funding ledger total for the wallet, in USDC. Tracks net deposits/withdrawals/transfers across time. |
| `totalVaultEquity` | `string` | Sum of all vault equity the wallet leads (when `isVault` or a vault leader). `"0.0"` when the wallet leads no vaults. |
| `perpsAtOpenInterestCap` | `array` | List of perp `coin` symbols currently at their open-interest cap. Useful for surfacing "no new shorts/longs" UI states. |
| `twapStates` | `array` | Active TWAP orders for the wallet. Empty array when no TWAPs are in flight. |
| `leadingVaults` | `array` | Vaults the wallet leads, each with vault address and current equity. Empty array when the wallet leads no vaults. |
| `clearinghouseState` | `object` | Perpetuals account state - identical to the response shape of [`clearinghouseState`](https://goldrush.dev/docs/api-reference/hyperliquid-info/clearinghouse-state). Contains `marginSummary`, `crossMarginSummary`, `crossMaintenanceMarginUsed`, `withdrawable`, `time`, and `assetPositions[]`. |
| `meta` | `object` | Perp universe metadata - identical to the response shape of [`meta`](https://goldrush.dev/docs/api-reference/hyperliquid-info/meta). Contains `universe[]` (`{name, szDecimals, maxLeverage, marginTableId}`), `marginTables[]`, and `collateralToken`. |
| `assetCtxs` | `array` | Live per-perp market context, ordered to align with `meta.universe`. Each entry carries `funding`, `openInterest`, `markPx`, `oraclePx`, `midPx`, `impactPxs`, `premium`, `prevDayPx`, `dayNtlVlm`, and `dayBaseVlm`. |
| `spotAssetCtxs` | `array` | Live per-spot-pair market context. Each entry carries `coin` (the spot pair symbol), `markPx`, `midPx`, `prevDayPx`, `dayNtlVlm`, `dayBaseVlm`, `circulatingSupply`, and `totalSupply`. |
| `openOrders` | `array` | The wallet's open orders with full trigger metadata - identical to the response shape of [`frontendOpenOrders`](https://goldrush.dev/docs/api-reference/hyperliquid-info/frontend-open-orders). Each entry includes `coin`, `side`, `limitPx`, `sz`, `oid`, `timestamp`, `triggerCondition`, `isTrigger`, `triggerPx`, `children`, `isPositionTpsl`, `reduceOnly`, `orderType`, `origSz`, `tif`, and `cloid`. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### activeAssetData

fetch a user's active trading limits, leverage setting, available size, and mark price for a single Hyperliquid perpetual…

### allMids

fetch the current mid price for every actively traded asset in a single call.

### allPerpMetas

fetch the perpetuals metadata — universe definitions and margin tables — for every perp DEX in a single request.

See all Hyperliquid endpoints: **Overview hub** · **Info API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-06-19_

{/* generated:hl-footer-end */}

---