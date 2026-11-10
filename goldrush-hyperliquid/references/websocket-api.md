# Hyperliquid WebSocket API

## Critical Rules

1. WebSocket URL: `wss://hypercore.goldrushdata.com/ws?key=<GOLDRUSH_API_KEY>` (note: `hypercore`, not `hyperliquid`; auth is a `?key=` query parameter, not an `Authorization` header).
2. Wire-compatible with `wss://api.hyperliquid.xyz/ws` for shared subscription types (e.g. `l2Book`).
3. No 1000-subscription-per-IP cap. Multiplex many subscriptions on one connection.
4. **`l2Book`** - aggregated price-level snapshots `{px, sz, n}`. `coin` is **optional** - omit it to stream every asset over a single subscription. When `coin` is omitted, `marketTypes` defaults to `["perp"]` (perps only); pass `["spot"]`, `["outcome"]`, a mix, or `["*"]` to opt into spot, outcome, and any future market types.
5. **`l2BookDiff`** - GoldRush-native L2 diff transport. Same aggregated `{px, sz, n}` shape as `l2Book`, but emits one `Snapshot` per subscribed coin and then per-block `Updates` carrying only changed levels. `coin` accepts a single asset, an array of assets, or can be omitted for wildcard (same `marketTypes` default - perps only - applies when `coin` is omitted). Treat `sz: "0"` (with `n: 0`) as level removal. Not available on the public Hyperliquid WebSocket.
6. **`l4Book`** - GoldRush-native order-level stream with `user`, `oid`, `cloid`, `tif`, and trigger metadata per order. `coin` is **required**. Emits a single `Snapshot` on subscribe, then per-block `Updates` (`order_statuses` + `book_diffs`). Not available on the public Hyperliquid WebSocket.

## Available Subscriptions

| Channel | Subscription body | Returns |
|---------|-------------------|---------|
| `l2Book` | `{"type":"l2Book","coin":"BTC"}` (or omit `coin`) | Full L2 book snapshot per tick with bids/asks aggregated by significant figures. Self-healing - every message is a complete snapshot. |
| `l2BookDiff` | `{"type":"l2BookDiff","coin":"HYPE"}`, `{"type":"l2BookDiff","coin":["HYPE","BTC","ETH"]}`, or omit `coin` for wildcard | Initial `Snapshot` per coin (aggregated `{px, sz, n}`), then per-block `Updates` with `book_diffs` grouped by coin carrying only changed levels. `sz: "0"` means level removed. **GoldRush-native, no upstream equivalent.** |
| `l4Book` | `{"type":"l4Book","coin":"BTC"}` | Initial `Snapshot` of every resting order, then per-block `Updates` with `order_statuses` (lifecycle) and `book_diffs` (per-order changes). **GoldRush-native, no upstream equivalent.** |

## Subscribe / Unsubscribe Pattern

```json
// Subscribe
{"method":"subscribe","subscription":{"type":"l2Book","coin":"BTC"}}

// Unsubscribe (same subscription body, method swapped)
{"method":"unsubscribe","subscription":{"type":"l2Book","coin":"BTC"}}
```

## When to use which channel

| Need | Use |
|------|-----|
| Top-of-book, spread, depth-weighted mid, slippage / impact estimator | `l2Book` |
| Stream every asset on one subscription | `l2Book` (omit `coin`) or `l2BookDiff` (omit `coin`) |
| Aggregated `{px, sz, n}` book state with diff-only bandwidth, single coin / list / wildcard | `l2BookDiff` |
| Multi-coin coverage with a fixed list of assets in one subscription | `l2BookDiff` with `coin: ["HYPE","BTC","ETH"]` |
| Queue position, per-user flow attribution, microstructure analytics | `l4Book` |
| Reconstruct an L2-style aggregated view but keep order-level detail | `l4Book` (aggregate client-side) |
| OHLCV candles instead of raw book state | GraphQL `ohlcvCandlesForPair` (see `streaming.md`) |

---

The GoldRush Hyperliquid WebSocket API is a **drop-in replacement** for `wss://api.hyperliquid.xyz/ws`. For the [channels GoldRush supports](#available-subscriptions), subscription payloads, channel names, and message shapes are byte-for-byte identical to the public Hyperliquid feed. The only difference is the connection URL - authentication is a required `key` query parameter, so no header changes are needed in your client.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time.

> **Warning:** The connection URL - including the `key` - is visible to any client that opens the socket. **Do not ship your API key (`cqt_…`) to a browser or mobile app.** For client-side use, mint a short-lived **Ephemeral Key** on your backend and pass that as `key=gr_ek_…` instead. It's scoped to your API key, expires in 30 minutes, and is safe to embed. See **Recipe B: browser WebSocket with auto-refresh**.

## Comparison with the public Hyperliquid WebSocket

| | Public WebSocket | GoldRush |
|---|---|---|
| URL | `wss://api.hyperliquid.xyz/ws` | `wss://hypercore.goldrushdata.com/ws?key=` |
| Auth | None | `key` query parameter (required) |
| Subscriptions per IP | 1000 | No cap |
| Wire compatibility | n/a (it's the source) | Byte-for-byte |
| Available channels | See [Hyperliquid Docs](https://hyperliquid.gitbook.io/hyperliquid-docs/for-developers/api/websocket) | See [Available subscriptions](#available-subscriptions) |

## Available subscriptions

### Order book

Stream the Hyperliquid order book in real time - three channels, from aggregated L2 snapshots to full order-level (L4) detail. Omit `coin` on `l2Book` or `l2BookDiff` to stream **every asset on a single subscription**, which the public WebSocket's 1000-subscription-per-IP cap makes impractical.

| Channel | Subscription body | Returns |
|---|---|---|
| **`l2Book`** | `{"type": "l2Book", "coin": "BTC"}` | Real-time L2 order book snapshots - bids and asks aggregated by significant figures. `coin` is optional - omit it to stream every asset on one subscription. |
| **`l2BookDiff`** | `{"type": "l2BookDiff", "coin": "HYPE"}` | GoldRush-native L2 diff transport - initial `Snapshot` per coin plus per-block `Updates` carrying only changed `{px, sz, n}` levels. `coin` accepts a single asset, an array of assets, or can be omitted to stream every asset. Not available on the public Hyperliquid WebSocket. |
| **`l4Book`** | `{"type": "l4Book", "coin": "BTC"}` | GoldRush-native order-level book stream - initial `Snapshot` of every resting order plus per-block `Updates` with `order_statuses` and `book_diffs`. Exposes `user`, `oid`, `cloid`, `tif`, and trigger metadata per order. `coin` is required. Not available on the public Hyperliquid WebSocket. |

### Wallet activity

| Channel | Subscription body | Returns |
|---|---|---|
| **`userFills`** | `{"type": "userFills", "addresses": ["0x…"]}` | Live trade fills for one or more wallets, batched per block as `[address, fill]` tuples. Aliases `user` / `users` also accepted. |
| **`orderUpdates`** | `{"type": "orderUpdates", "addresses": ["0x…"]}` | Live order lifecycle events (placements, fills, cancels, rejections) for one or more wallets, batched per block as an `updates` array of objects, each tagged with the originating `user`. Aliases `user` / `users` also accepted. |
| **`liquidationFills`** | `{"type": "liquidationFills"}` | Global stream of every liquidation fill on HyperCore. Same shape as `userFills` with a non-null `liquidation` object on every entry. **GoldRush-native**, no upstream equivalent. |
| **`allFills`** | `{"type": "allFills"}` | Global stream of every fill on HyperCore. Optional `coin` filter narrows to a single market. Same per-fill shape as `userFills`. **GoldRush-native**, no upstream equivalent. |
| **`builderFills`** | `{"type": "builderFills", "builder": "0x…"}` | Live attributed fills for one or more builder addresses, with `builder` and `builderFee` on every entry. Accepts `builder` (single) or `addresses` (array). **GoldRush-native**, no upstream equivalent. |
| **`builderLiquidations`** | `{"type": "builderLiquidations", "builder": "0x…"}` | Liquidation fills whose closing order was routed through your builder code - the intersection of `liquidationFills` and `builderFills`. Requires `builder`; carries both the `liquidation` object and `builder` attribution on every entry. **GoldRush-native**, no upstream equivalent. |
| **`userNonFundingLedgerUpdates`** | `{"type": "userNonFundingLedgerUpdates", "addresses": ["0x…"]}` | Live non-funding ledger events (deposits, withdrawals, transfers, liquidations, vault actions, staking, rewards) for one or more wallets. |

> **Note:** **Looking for `candle`, `trades`, `bbo`, or `allMids`?** These public Hyperliquid market-data channels aren't mirrored on the GoldRush WebSocket - use the GoldRush equivalents instead:

  - **OHLCV candles** - the Info API **`candleSnapshot`** endpoint for historical candles, or the real-time **HIP-3** and **HIP-4** OHLCV recipes for candles across every HIP-3/HIP-4 market.
  - **Trade tape** - **`allFills`** streams every fill on HyperCore (the global trade tape); **`userFills`** narrows it to specific wallets.
  - **Best bid/offer and mids** - derive top-of-book from **`l2Book`**, or read mark and mid prices for the full universe from **`metaAndAssetCtxs`**.

## Limits

No 1000-subscription-per-IP cap. On `l2Book` and `l2BookDiff`, filter parameters are optional - omit `coin` to stream the full L2 book across every asset on a single subscription. The wildcard defaults to **perps only** (`marketTypes: ["perp"]`); pass `["spot"]`, `["outcome"]`, a mix, or `["*"]` to opt into spot, outcome, and future market types. `l2BookDiff` additionally accepts an array of coin symbols for a fixed multi-asset subscription. `l4Book` requires `coin` and is one-asset-per-subscription. See **Limits & Connections** for details.

## Billing

Subscriptions bill per minute, in whole minutes, with a **minimum of one full minute per subscription**. There is no proration: a subscription that lives 200 milliseconds costs the same as one that lives 60 seconds, and every reconnect starts a new subscription that pays the minimum again. See **Billing** for the per-minute rates, the `ceil` rounding table, and worked examples.

---

Moving from the public Hyperliquid WebSocket to GoldRush is one change:

1. **URL** - replace `wss://api.hyperliquid.xyz/ws` with `wss://hypercore.goldrushdata.com/ws?key=`.

That's it. Subscription payloads, channel names, and the streamed message shape are byte-for-byte identical. Authentication is a required `key` query parameter, so no header swap is needed in your client.

## Side-by-side

### wscat

```bash Public Hyperliquid
wscat -c wss://api.hyperliquid.xyz/ws

> {"method":"subscribe","subscription":{"type":"l2Book","coin":"BTC"}}
```

```bash GoldRush
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"l2Book","coin":"BTC"}}
```

### JavaScript / TypeScript

```typescript Public Hyperliquid
import WebSocket from "ws";

const ws = new WebSocket("wss://api.hyperliquid.xyz/ws");

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  console.log(JSON.parse(raw.toString()));
});
```

```typescript GoldRush
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  console.log(JSON.parse(raw.toString()));
});
```

### Python

```python Public Hyperliquid
import asyncio, json
import websockets

async def main():
    async with websockets.connect("wss://api.hyperliquid.xyz/ws") as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2Book", "coin": "BTC"},
        }))
        async for raw in ws:
            print(json.loads(raw))

asyncio.run(main())
```

```python GoldRush
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2Book", "coin": "BTC"},
        }))
        async for raw in ws:
            print(json.loads(raw))

asyncio.run(main())
```

## Behavioral notes

Things to be aware of when you cut over.

### Stream payloads are byte-equal, modulo live drift

The `channel` name and `data` shape match Hyperliquid byte-for-byte - same keys, same nesting, same value types. Numeric fields update independently on each side, so a price level may differ by tens of milliseconds, but the schema is identical.

### Auth errors close the connection

A missing or invalid `key` query param returns HTTP `401` on the upgrade handshake, so the WebSocket never opens. Public Hyperliquid has no auth and never rejects the handshake.

### Filter parameters are optional on GoldRush

Parameters that the public Hyperliquid WebSocket **requires** (e.g. `coin` on `l2Book`) are **optional** on GoldRush. Omit them to stream the entire channel on a single subscription instead of fanning out one subscription per asset. See **Limits**.

### Existing SDKs work after a `wsUrl` override

Most popular Hyperliquid SDKs accept a WebSocket base URL override - point them at `wss://hypercore.goldrushdata.com/ws?key=` and the rest of the SDK works unchanged. See **SDK compatibility** for the override snippets.

## Authentication

The WebSocket API uses your standard GoldRush API key, passed as a `key` query parameter at connection time. The same key works against the **Foundational API** and the **Info API**. If you don't have one yet, [sign up here](https://goldrush.dev/platform/auth/register/).

Never hardcode keys in source. Use environment variables or a secrets manager.

## What you gain

- **No subscription cap.** No 1000-subscription-per-IP limit; multiplex hundreds of subscriptions on a single connection.
- **Wildcard subscriptions.** Omit filter parameters to stream the entire channel - e.g. the full L2 order book across every asset on one subscription.
- **One key for everything Hyperliquid.** The same API key unlocks the Info API and HyperEVM via the Foundational API.

---

The most popular Hyperliquid SDKs work against the GoldRush WebSocket API after a one-line URL override. Authentication is a `key` query parameter on the connection URL - no header injection is needed.

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
  // Point at GoldRush - REST and WebSocket
  baseUrl: "https://hypercore.goldrushdata.com",
  wsUrl: `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
  // REST still needs the Authorization header
  headers: {
    Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}`,
  },
});

// Existing subscription methods work unchanged
sdk.subscriptions.subscribeToL2Book("BTC", (book) => {
  console.log(book.coin, book.time, book.levels[0][0]);
});

sdk.subscriptions.subscribeToL2Book("ETH", (book) => {
  console.log(book.coin, book.time, book.levels[0][0]);
});
```

> **Note:** If your SDK version doesn't expose a `wsUrl` option, instantiate the WebSocket client manually and pass it to the SDK, or patch the constant the SDK uses. See the override fallback below.

### Manual WebSocket fallback

When the SDK doesn't expose a `wsUrl` knob, bypass it and drive the raw socket yourself:

```typescript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "l2Book") {
    // Hand off to your application
  }
});
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

# Point Info at GoldRush. skip_ws=False opens the WebSocket on init.
info = Info(
    base_url="https://hypercore.goldrushdata.com",
    skip_ws=False,
)

# Override the WebSocket URL on the underlying client so it includes the key
info.ws_manager.ws_url = (
    f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
)

# Inject the Authorization header for REST calls
info.session.headers.update({
    "Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"
})

# Existing subscription methods work unchanged
def on_book(msg):
    print(msg["data"]["coin"], msg["data"]["time"], msg["data"]["levels"][0][:1])

info.subscribe({"type": "l2Book", "coin": "BTC"}, on_book)
```

> **Tip:** The SDK's `Info` class manages both REST and WebSocket. If you only need WebSocket, you can skip the `session.headers.update(...)` line. If you only need REST, pass `skip_ws=True` instead.

## Verification

After cutover, confirm everything is wired correctly:

1. **Diff a known subscription** - subscribe to `l2Book` for the same coin against both endpoints; the streamed `channel` and `data` shape (keys, nesting, types) should match exactly.
2. **Confirm auth** - remove the `key` query parameter and confirm the WebSocket upgrade fails with HTTP `401`. If the socket opens, your request isn't reaching GoldRush.
3. **Confirm wildcard** - subscribe to `l2Book` **without** a `coin` and confirm you receive book snapshots for multiple assets. This call would be rejected on the public Hyperliquid WebSocket.

## Other SDKs

The pattern is the same for any WebSocket client: override the connection URL to `wss://hypercore.goldrushdata.com/ws?key=`. If you run into a specific SDK that doesn't expose a URL override, [open a support ticket](https://goldrush.dev/platform/support/) - we'll publish a recipe.

---

## Hyperliquid WebSocket rate limits

The **public Hyperliquid WebSocket** (`wss://api.hyperliquid.xyz/ws`) caps each IP at **1000 active subscriptions**, and most channels require one subscription per asset - so tracking the full market means fanning out hundreds of subscriptions and risking the cap.

**The GoldRush Hyperliquid WebSocket API removes that cap.** It's a **drop-in replacement** with **no per-IP, per-key, or per-connection subscription limit**, plus [wildcard subscriptions](#wildcard-subscriptions) that stream an entire channel over a single subscription.

## No subscription cap

With no subscription limit, you can:

- Open as many concurrent subscriptions as your client supports.
- Multiplex hundreds of `l2Book` subscriptions on a single connection.
- Track every active wallet, market, and asset from one process.

## Wildcard subscriptions

Filter parameters that the public Hyperliquid WebSocket **requires** are **optional** on GoldRush. Omit them to stream the entire channel on one subscription instead of fanning out one subscription per asset.

| Channel | Public Hyperliquid | GoldRush |
|---|---|---|
| `l2Book` | `coin` required - one subscription per asset | `coin` optional - omit it to stream the **full L2 order book across every asset** on a single subscription |

So a single connection can stream Hyperliquid's full live book state without any client-side fan-out logic.

## How streaming works

Messages are pushed directly from a live Hyperliquid ingestion pipeline - no polling, no cache delay. Latency from upstream Hyperliquid event to your client is dominated by network round-trip from our Tokyo nodes.

| Channel | Push trigger |
|---|---|
| `l2Book` | Every L2 update on the subscribed coin (or every coin, if wildcard). |

## Billing

Subscriptions on this WebSocket are billed **per minute, in whole minutes**. There is no proration and there is no partial minute. Every channel bills on that basis; what differs is the unit being counted. Order-book channels (`l2Book`, `l2BookDiff`, `l4Book`, `l4BookUpdates`, `trades`) bill **per coin**. [Wallet-activity channels](#wallet-activity-channels-bill-a-flat-per-channel-rate) bill a **flat rate per channel**, whatever the address count.

> **Warning:** **The minimum charge is one full minute per subscription.** A subscription that lives for 200 milliseconds costs exactly the same as one that lives for 60 seconds. If your client reconnects often, read [Every reconnect costs a new first minute](#every-reconnect-costs-a-new-first-minute).

### The first minute is charged up front

The moment the server accepts your `subscribe` message, it charges one full minute at the channel's per-minute rate. This happens before the first frame reaches you, so subscribing and disconnecting immediately does not avoid the charge.

This is deliberate. Without it, a client could grab a snapshot for a fraction of a credit and drop the connection, which is a far cheaper way to poll the book than the REST endpoints it would otherwise use.

### After that, every started minute is a full minute

Once the first minute is paid, the total you owe is `ceil(seconds_subscribed / 60)`, counted from the instant you subscribed:

| Time subscribed | Minutes billed |
|---|---|
| 200 ms | 1 |
| 1 s | 1 |
| 60 s | 1 |
| 61 s | 2 |
| 120 s | 2 |
| 121 s | 3 |

Any second past a full minute starts the next billable minute. Usage never accrues a fractional minute, so you can always compute a subscription's cost as `ceil(seconds / 60) x rate`.

### Per-minute rates

| Channel | Subscription shape | Credits per minute |
|---|---|---|
| **`l2Book`** | One coin | 0.5 per coin |
| **`l2Book`** | Wildcard (`coin` omitted) | 50 |
| **`l2BookDiff`** | One coin | 0.13 per coin |
| **`l2BookDiff`** | Wildcard (`coin` omitted) | 10 |
| **`l4Book`** | One coin, not BTC | 3 |
| **`l4Book`** | `"coin": "BTC"` | 60 |
| `l4BookUpdates` | One coin | 1 per coin |
| `trades` | One coin | 0.1 per coin |

A wildcard subscription is billed as one subscription at the flat wildcard rate, no matter how many assets it streams. So the wildcard pays for itself once you are tracking enough coins to match its rate: 100 coins on `l2Book` (100 x 0.5 = 50) and 77 coins on `l2BookDiff` (77 x 0.13 = 10.01). Below that, per-coin subscriptions cost less. `l4Book` has no wildcard; `coin` is required. `l4BookUpdates` and `trades` are per-coin with no wildcard and no BTC premium.

### Wallet-activity channels bill a flat per-channel rate

**`userFills`**, **`allFills`**, **`liquidationFills`**, **`orderUpdates`**, **`userNonFundingLedgerUpdates`**, and **`builderFills`** bill on the same whole-minute basis, but at a **flat rate per channel, not per coin**:

| Channel | Subscription shape | Credits per minute |
|---|---|---|
| Any wallet-activity channel | Per connection (any number of addresses) | 1 per channel |

The rate does **not** scale with the number of addresses you track: one `userFills` subscription covering 10 addresses or 1,000 addresses is the same 1 credit per minute. Two consequences:

- **One billable subscription per (connection, channel).** Adding or removing addresses on a channel you are already subscribed to does not open a new billable subscription.
- **Up to 1,000 addresses per connection, per channel.** To track more, open additional connections. Each one bills its own 1 credit per minute per channel.

### What counts as one subscription

On the **order-book channels**, a subscription is identified by **the channel plus the exact `coin` field you sent**, on one WebSocket session. Three consequences follow:

- **Re-sending an identical `subscribe` on a live session is free.** It is deduplicated, produces no extra data, and adds no charge.
- **An array subscription is one subscription, not N.** `{"type": "l2BookDiff", "coin": ["BTC", "ETH", "SOL"]}` is a single billable subscription charged at the sum of its coins' rates: 3 x 0.13 = 0.39 credits per minute.
- **Overlapping subscriptions each bill.** Holding `coin: ["BTC", "ETH"]` and `coin: "BTC"` at the same time gives you two independent streams, both delivering BTC frames, and you pay for both.

On the **wallet-activity channels** there is no `coin` field, so the unit is the channel per connection and the address list never changes it. Everything below applies to both families.

### Every reconnect costs a new first minute

A new WebSocket session is a new subscription, even if you send byte-identical subscribe messages. So every reconnect pays the one-minute minimum again.

This matters most when a connection is flapping. A client that retries every second, holding 50 `l2BookDiff` coin subscriptions, bills 50 minutes per retry. Sixty retries in a minute bills 3,000 subscription-minutes for 60 seconds of wall-clock time.

Two things protect you:

- **Back off exponentially.** Start around 1 second and cap at 30 seconds, as in the [reconnect sketch](#reconnect-sketch) below. That bounds a flapping client to roughly 2 reconnects per minute instead of 60.
- **Prefer one long-lived connection.** Multiplex every subscription onto it rather than opening and closing sockets per query.

### `unsubscribe` must repeat the exact shape you subscribed with

An `unsubscribe` only matches a subscription whose `coin` field is *exactly* the one you sent on `subscribe`.

```text
subscribe    { "type": "l2BookDiff", "coin": ["BTC", "ETH"] }   // one subscription
unsubscribe  { "type": "l2BookDiff", "coin": "ETH" }            // matches nothing
```

The second message is a silent no-op. Hyperliquid replies `Already unsubscribed`, the array keeps streaming both coins, and it keeps billing at the full array rate. To drop one coin out of a multi-coin subscription, unsubscribe with the exact array shape and then subscribe again with the subset you want.

### Worked example: snapshot-only across 168 coins

Subscribing to `l4Book` on 168 coins, reading the opening snapshot, and disconnecting after 400 milliseconds bills the full one-minute minimum on all 168:

| | Coins | Rate per minute | Minutes | Credits |
|---|---|---|---|---|
| BTC | 1 | 60 | 1 | 60 |
| Every other coin | 167 | 3 | 1 | 501 |
| **Total** | **168** | | | **561** |

Staying connected for a full 60 seconds costs the same 561 credits. Staying for 61 seconds costs 1,122. Disconnecting and repeating the same snapshot sweep ten times costs 5,610.

## Connection management

You're not rate-limited, but a few client-side defaults are worth tuning.

| Behavior | Recommended client setting |
|---|---|
| **Reconnect** | On unexpected close, reconnect with exponential backoff capped at ~30 seconds. Re-send your subscription messages after the new socket opens. A fixed short retry is expensive: every reconnect re-pays the [one-minute minimum](#every-reconnect-costs-a-new-first-minute) on every subscription. |
| **Heartbeat** | Send an application-level `ping` every 30 seconds. The server replies with `pong`. Most WebSocket libraries handle this automatically; verify yours does. |
| **Max message size** | L2 book snapshots for wildcard subscriptions can exceed 1 MB. Raise your client's `maxPayload` (Node `ws` library) or `max_size` (Python `websockets`) if you're receiving truncated messages. |
| **Backpressure** | If your handler can't keep up with incoming messages, your client buffer will fill. Drain to a queue or downstream consumer; don't block the read loop on application work. |

### Reconnect sketch

```typescript TypeScript
import WebSocket from "ws";

function connect() {
  const ws = new WebSocket(
    `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
    { maxPayload: 8 * 1024 * 1024 },
  );

  ws.on("open", () => {
    ws.send(JSON.stringify({
      method: "subscribe",
      subscription: { type: "l2Book" }, // wildcard - all assets
    }));
  });

  ws.on("close", () => setTimeout(connect, Math.min(30_000, backoff *= 2)));
  ws.on("error", () => ws.close());
  ws.on("message", handle);
}

let backoff = 1_000;
connect();
```

```python Python
import asyncio, json, os
import websockets

async def consume():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    backoff = 1
    while True:
        try:
            async with websockets.connect(uri, max_size=8 * 1024 * 1024, ping_interval=30) as ws:
                backoff = 1
                await ws.send(json.dumps({
                    "method": "subscribe",
                    "subscription": {"type": "l2Book"},  # wildcard
                }))
                async for raw in ws:
                    handle(json.loads(raw))
        except Exception:
            await asyncio.sleep(min(30, backoff))
            backoff *= 2

asyncio.run(consume())
```

## Watch out for client-side limits

GoldRush has no caps, but the rest of your stack might:

- **OS file descriptor limits** - if you're opening many connections in parallel, raise `ulimit -n`.
- **Reverse proxy idle timeouts** - if you're terminating WS through nginx, HAProxy, or a cloud load balancer, set the idle timeout above your heartbeat interval (typically 60 seconds minimum).
- **Browser concurrency** - browsers limit WebSocket connections per origin; one connection multiplexing many subscriptions is always preferable to many connections.

## Network and TLS

- **HTTP/1.1 Upgrade** to WSS is supported (standard WebSocket handshake).
- **TLS 1.2+** required.
- **Compression (`permessage-deflate`)** is negotiated when offered by the client.

## Need higher guarantees?

Enterprise SLA, dedicated capacity, regional pinning, and on-prem options are all available. **Email sales**.

---

# WebSocket API Reference

## allFills | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native: No `wss://api.hyperliquid.xyz/ws` equivalent.
- Filters `coin` and `aggregateByTime` are both optional. Omit `coin` to stream every market.
- Live-only: No historical snapshot on subscribe. For windowed history, use the Info API [`userFillsByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-fills-by-time).
- Same per-fill shape as `userFills`; channel name in messages is `allFills`.

Subscribe once and receive every fill on HyperCore as it executes, batched per block as `[address, fill]` tuples. Optional `coin` filter narrows the stream to a single market; `aggregateByTime` merges partial fills of the same order in a block.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"allFills"`. __RESPONSE_ROW__coin	string	Restrict the stream to a single market (e.g. `"BTC"`, `"ETH"`, or spot `@N` form). Omit to receive every market on one subscription. __RESPONSE_ROW__aggregateByTime	boolean	When `true`, partial fills of the same order within the same block are merged into one. Default `false`.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"allFills"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: {
      type: "allFills",
    },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "allFills") {
    for (const [address, fill] of msg.fills) {
      console.log(address, fill.coin, fill.side, fill.sz, "@", fill.px);
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "allFills"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "allFills":
                for address, fill in msg["fills"]:
                    print(address, fill["coin"], fill["side"], fill["sz"], "@", fill["px"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": {
    "type": "allFills"
  }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `{"type": "allFills", "coin": "BTC"}` is a different subscription from a wildcard `{"type": "allFills"}` - they must be unsubscribed independently.

## Streamed message

Each push has `channel: "allFills"` and a `fills` array of `[address, fill]` tuples - every fill from the same HyperCore block that matches the optional `coin` filter, with the executing wallet as the first element of each tuple.

```json
{
  "channel": "allFills",
  "fills": [
    [
      "0x742d35cc6634c0532925a3b844bc9e7595f7f2e2",
      {
        "coin": "ETH",
        "px": "2150.5",
        "sz": "1.5",
        "side": "B",
        "time": 1704067200000,
        "startPosition": "1.5",
        "dir": "Open Long",
        "closedPnl": "125.5",
        "hash": "0xabc...def",
        "oid": 12345678,
        "crossed": false,
        "fee": "2.5",
        "tid": 87654321,
        "feeToken": "USDC",
        "twapId": null
      }
    ]
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"allFills"`. |
| `fills` | `array` | Tuples of `[address, fill]`. The `address` is the wallet that executed the fill; the `fill` object carries the trade details. |
| `fills.coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `fills.px` | `string` | Fill execution price (decimal string). |
| `fills.sz` | `string` | Fill size (decimal string). |
| `fills.side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `fills.time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `fills.startPosition` | `string` | Signed position size on the same coin immediately before this fill. |
| `fills.dir` | `string` | Human-readable direction label - `"Open Long"`, `"Open Short"`, `"Close Long"`, `"Close Short"`, `"Buy"`, `"Sell"`, or position-flip labels `"Long > Short"` / `"Short > Long"`. |
| `fills.closedPnl` | `string` | Realized PnL in USDC attributable to this fill (zero when the fill opens or extends a position). |
| `fills.hash` | `string` | L1 transaction hash that included this fill. |
| `fills.oid` | `int` | Parent order ID. |
| `fills.crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fills.fee` | `string` | Trading fee paid for this fill, denominated in `feeToken`. |
| `fills.tid` | `int` | Unique trade ID. |
| `fills.feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `fills.twapId` | `int | null` | Parent TWAP order ID if this fill is a slice of a TWAP, otherwise `null`. |
| `fills.cloid` | `string` | Optional. Client order ID (`0x`-prefixed 32-character hex) if one was set at order placement. |
| `fills.builder` | `string` | Optional. Builder address the order was routed through. |
| `fills.builderFee` | `string` | Optional. Builder fee paid for this fill, denominated in `feeToken`. |
| `fills.liquidation` | `object` | Optional. Present only when this fill closed a position as part of a liquidation event.  __RESPONSE_ROW__liquidatedUser	string	The wallet whose position was liquidated. __RESPONSE_ROW__fills.markPx	string	Mark price at the time of liquidation. __RESPONSE_ROW__fills.method	string	Liquidation method - `"market"` or `"backstop"`.  |

{/* generated:hl-linkhub-start */}

## Related endpoints


### builderFills

stream live attributed fills for one or more builder addresses in real time.

### liquidationFills

stream a global, market-wide feed of every liquidation fill on HyperCore.

### userFills

stream real-time trade fills for one or more wallets as they execute on HyperCore.

### builderLiquidations

subscribe to real-time liquidation fills of your users.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-19_

{/* generated:hl-footer-end */}

---

## builderFills | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native: No `wss://api.hyperliquid.xyz/ws` equivalent.
- Pass `builder` (string) for a single builder or `addresses` (string[]) for many. `aggregateByTime` optional.
- Live-only: No historical snapshot on subscribe. For windowed history, use the Info API [`builderFillsByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/builder-fills-by-time).
- Same per-fill shape as `userFills`, plus `builder` and `builderFee` on every entry; channel name in messages is `builderFills`.

Subscribe to one builder address (`builder`) or many (`addresses`) and receive every fill routed through those builders as they execute, batched per block as `[address, fill]` tuples. Each fill carries the matched `builder` address and the corresponding `builderFee`.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established. Provide either `builder` (single address) or `addresses` (array of addresses).

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"builderFills"`. __RESPONSE_ROW__builder	string	Single builder address (lowercase `0x`-prefixed 42-character hex) to stream fills for. Mutually exclusive with `addresses`. __RESPONSE_ROW__addresses	string[]	Array of builder addresses to stream fills for - the multi-builder form of `builder`. Mutually exclusive with `builder`. __RESPONSE_ROW__aggregateByTime	boolean	When `true`, partial fills of the same order within the same block are merged into one. Default `false`.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"builderFills","builder":"0xb84168cf3be63c6b8dad05ff5d755e97432ff80b"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: {
      type: "builderFills",
      builder: "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b",
    },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "builderFills") {
    for (const [address, fill] of msg.fills) {
      console.log(address, fill.coin, fill.side, fill.sz, "@", fill.px, "builderFee:", fill.builderFee);
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {
                "type": "builderFills",
                "builder": "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b",
            },
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "builderFills":
                for address, fill in msg["fills"]:
                    print(address, fill["coin"], fill["side"], fill["sz"], "@", fill["px"], "builderFee:", fill.get("builderFee"))

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": {
    "type": "builderFills",
    "builder": "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b"
  }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `builder: "0xAAA"` is a different subscription from one created with `addresses: ["0xAAA"]`, even if they target the same builder. To narrow a multi-builder set, unsubscribe the original list in full, then resubscribe with the smaller list.

## Streamed message

Each push has `channel: "builderFills"` and a `fills` array of `[address, fill]` tuples. The first element of each tuple is the trader who executed the fill; the `fill` object carries the trade details, including the `builder` it was routed through and the `builderFee` earned.

```json
{
  "channel": "builderFills",
  "fills": [
    [
      "0x742d35cc6634c0532925a3b844bc9e7595f7f2e2",
      {
        "coin": "ETH",
        "px": "2150.5",
        "sz": "1.5",
        "side": "B",
        "time": 1704067200000,
        "startPosition": "1.5",
        "dir": "Open Long",
        "closedPnl": "125.5",
        "hash": "0xabc...def",
        "oid": 12345678,
        "crossed": false,
        "fee": "2.5",
        "tid": 87654321,
        "feeToken": "USDC",
        "twapId": null,
        "builderFee": "0.1",
        "builder": "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b"
      }
    ]
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"builderFills"`. |
| `fills` | `array` | Tuples of `[address, fill]`. The `address` is the trader who placed the order; the `fill` object carries the trade details plus builder-attribution fields. |
| `fills.coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `fills.px` | `string` | Fill execution price (decimal string). |
| `fills.sz` | `string` | Fill size (decimal string). |
| `fills.side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `fills.time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `fills.startPosition` | `string` | Signed position size the trader held on this coin immediately before this fill. |
| `fills.dir` | `string` | Human-readable direction label - `"Open Long"`, `"Open Short"`, `"Close Long"`, `"Close Short"`, `"Buy"`, `"Sell"`, or position-flip labels `"Long > Short"` / `"Short > Long"`. |
| `fills.closedPnl` | `string` | Realized PnL in USDC attributable to this fill for the trader (zero when the fill opens or extends a position). |
| `fills.hash` | `string` | L1 transaction hash that included this fill. |
| `fills.oid` | `int` | Parent order ID. |
| `fills.crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fills.fee` | `string` | Trading fee paid by the trader for this fill, denominated in `feeToken`. |
| `fills.tid` | `int` | Unique trade ID. |
| `fills.feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `fills.twapId` | `int | null` | Parent TWAP order ID if this fill is a slice of a TWAP, otherwise `null`. |
| `fills.builder` | `string` | Builder address the order was routed through - matches one of the subscribed builders. |
| `fills.builderFee` | `string` | Builder fee earned for this fill, denominated in `feeToken`. |
| `fills.cloid` | `string` | Optional. Client order ID (`0x`-prefixed 32-character hex) if one was set at order placement. |
| `fills.liquidation` | `object` | Optional. Present only when this fill closed a position as part of a liquidation event.  __RESPONSE_ROW__liquidatedUser	string	The wallet whose position was liquidated. __RESPONSE_ROW__fills.markPx	string	Mark price at the time of liquidation. __RESPONSE_ROW__fills.method	string	Liquidation method - `"market"` or `"backstop"`.  |

## Errors

A missing or malformed `builder`/`addresses` field returns an error message on the same channel:

```json
{ "channel": "error", "data": "subscription builderFills requires a 'builder' field" }
```

{/* generated:hl-linkhub-start */}

## Related endpoints


### builderLiquidations

subscribe to real-time liquidation fills of your users.

### allFills

stream every fill on HyperCore in real time for global market analytics and cross-wallet order-flow monitoring.

### liquidationFills

stream a global, market-wide feed of every liquidation fill on HyperCore.

### userFills

stream real-time trade fills for one or more wallets as they execute on HyperCore.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-19_

{/* generated:hl-footer-end */}

---

## builderLiquidations | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native. `builderLiquidations` is not exposed on `wss://api.hyperliquid.xyz/ws`. Pointing a client at the public endpoint with this subscription type will fail.
- TWAP fills do not carry builder codes. If a user's last fill before liquidation was a TWAP fill, no builder liquidation notification will be sent.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established. `builder` is required.

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"` - GoldRush house style, matching the sibling channels. This is the only accepted form; a bare `type: "subscribe"` envelope is not recognized and is relayed upstream unchanged. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"builderLiquidations"`. __RESPONSE_ROW__builder	string	Your builder address (lowercase `0x`-prefixed 42-character hex). Only liquidations whose closing order was routed through this builder are streamed. __RESPONSE_ROW__aggregateByTime	boolean	When `true`, partial fills of the same liquidation within the same block are merged by `(user, time, order_id)` into one entry. **Defaults to `false`** on this channel. __RESPONSE_ROW__dex	string	Optional DEX filter - `"xyz"` or `"main"` (first-DEX fills only). Omit to stream across all DEXs.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"builderLiquidations","builder":"0xb84168cf3be63c6b8dad05ff5d755e97432ff80b"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: {
      type: "builderLiquidations",
      builder: "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b",
    },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.type === "builderLiquidations") {
    for (const [address, fill] of msg.liquidations) {
      console.log(
        "liquidated:", fill.liquidation.liquidatedUser,
        "via", fill.liquidation.method,
        "—", fill.coin, fill.sz, "@", fill.px,
        "builder:", fill.builder,
      );
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {
                "type": "builderLiquidations",
                "builder": "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b",
            },
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("type") == "builderLiquidations":
                for address, fill in msg["liquidations"]:
                    liq = fill["liquidation"]
                    print("liquidated:", liq["liquidatedUser"],
                          "via", liq["method"], "—",
                          fill["coin"], fill["sz"], "@", fill["px"],
                          "builder:", fill["builder"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": {
    "type": "builderLiquidations",
    "builder": "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b"
  }
}
```

## Streamed message

Each push keeps the upstream wire shape: `type: "builderLiquidations"` and a `liquidations` array of `[address, fill]` tuples - it is **not** normalized to the `channel`/`fills` shape used by the sibling channels. The `address` (and mirrored `user` field) is the wallet whose position was liquidated; `liquidation.liquidatedUser` repeats it, and `builder` is the attributed builder code.

```json
{
  "type": "builderLiquidations",
  "liquidations": [
    [
      "0x742d35cc6634c0532925a3b844bc9e7595f7f2e2",
      {
        "coin": "ETH",
        "px": "2150.50",
        "sz": "1.5",
        "side": "A",
        "time": 1704067200000,
        "startPosition": "1.5",
        "dir": "Close Long",
        "closedPnl": "-125.50",
        "hash": "0xabc...def",
        "oid": 12345678,
        "crossed": true,
        "fee": "2.50",
        "tid": 87654321,
        "cloid": null,
        "builderFee": null,
        "deployerFee": null,
        "feeToken": "USDC",
        "builder": "0xb84168cf3be63c6b8dad05ff5d755e97432ff80b",
        "twapId": null,
        "liquidation": {
          "liquidatedUser": "0x742d35cc6634c0532925a3b844bc9e7595f7f2e2",
          "markPx": "2148.00",
          "method": "market"
        },
        "user": "0x742d35cc6634c0532925a3b844bc9e7595f7f2e2"
      }
    ]
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `type` | `string` | Always `"builderLiquidations"`. |
| `liquidations` | `array` | Tuples of `[address, fill]`. The `address` is the liquidated wallet. Same `fill` shape as **`userFills`**, with `liquidation` and `builder` always populated. |
| `liquidations.builder` | `string` | The builder code the closing order was routed through - matches the subscribed `builder`. |
| `liquidations.builderFee` | `string | null` | Builder fee earned on this fill, denominated in `feeToken`; `null` when none applies. |
| `liquidations.deployerFee` | `string | null` | Deployer fee attributed to this fill, denominated in `feeToken`; `null` when none applies. |
| `liquidations.user` | `string` | The liquidated wallet - mirrors the tuple `address`. |
| `liquidations.liquidation` | `object` | Always present on this stream.  __RESPONSE_ROW__liquidatedUser	string	The wallet whose position was liquidated. __RESPONSE_ROW__liquidations.markPx	string	Mark price at the time of liquidation. __RESPONSE_ROW__liquidations.method	string	Liquidation method - `"market"` or `"backstop"`.  All other fields (`coin`, `px`, `sz`, `side`, `time`, `startPosition`, `dir`, `closedPnl`, `hash`, `oid`, `crossed`, `fee`, `tid`, `feeToken`, `twapId`, and optional `cloid`) match the **`userFills`** shape. |

> **Note:** **TWAP-preceded liquidations are omitted.** TWAP fills do not carry builder codes, so if a user's last fill before liquidation was a TWAP slice, GoldRush cannot attribute the liquidation to a builder and no entry is emitted on this stream. Use the global **`liquidationFills`** stream if you need every liquidation regardless of builder attribution.

## Errors

A missing or malformed `builder` field returns an error message:

```json
{ "channel": "error", "data": "subscription builderLiquidations requires a 'builder' field" }
```

{/* generated:hl-linkhub-start */}

## Related endpoints


### builderFills

stream live attributed fills for one or more builder addresses in real time.

### allFills

stream every fill on HyperCore in real time for global market analytics and cross-wallet order-flow monitoring.

### liquidationFills

stream a global, market-wide feed of every liquidation fill on HyperCore.

### userFills

stream real-time trade fills for one or more wallets as they execute on HyperCore.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-07-28_

{/* generated:hl-footer-end */}

---

## l2BookDiff | Hyperliquid WebSocket API

**Credit Cost:** 0.1 per coin per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native. `l2BookDiff` is not exposed on `wss://api.hyperliquid.xyz/ws`. Pointing a client at the public endpoint with this subscription type will fail.
- Snapshot, then diffs. The first message is always a `Snapshot`; every message thereafter is an `Updates`. Clients must seed local book state from the snapshot and apply diffs from there. On reconnect, drop local state and re-seed from the next snapshot.
- `coin` is optional. Omit it to stream the entire L2 order book across every asset on a single subscription.
- When `coin` is omitted, the optional `marketTypes` filter selects which market families to include. It defaults to `["perp"]` only.
- Pass `"marketTypes": ["spot"]`, or `"marketTypes":["outcome"]`, or a mix (e.g. `"marketTypes": ["perp","spot"]`), or use the wildcard `"marketTypes": ["*"]` to opt into spot, perps, outcome, and any future market types.
- No 1000-subscription-per-IP cap - multiplex hundreds of `l2BookDiff` subscriptions on a single connection.
- For OHLCV candles instead of raw book state, use the [Streaming API OHLCV streams](https://goldrush.dev/docs/api-reference/streaming-api/subscriptions/ohlcv-pairs-stream).

**Note:** When `coin` is omitted, a credit rate of `10` **credits per minute subscribed** is applied.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"l2BookDiff"`. __RESPONSE_ROW__coin	string \| string[]	Asset filter. Accepts three shapes: - **String** - a single asset symbol (e.g. `"HYPE"`, `"BTC"`, `"@107"` for spot pairs). For HIP-3 markets, include the deployer prefix. - **Array of strings** - a fixed list of asset symbols (e.g. `["HYPE", "BTC", "ETH"]`). Each listed coin gets its own initial `Snapshot`; subsequent `Updates` may bundle diffs for any subset of the list per block. - **Omitted** - wildcard. Streams the full L2 book across **every perp asset** by default on one subscription (see `marketTypes` to include spot or outcome markets). The server emits one `Snapshot` per live coin, then per-block `Updates` covering only the coins that changed. __RESPONSE_ROW__marketTypes	string[]	Optional. Selects which market families a wildcard subscription includes. **Only valid when `coin` is omitted.** **Defaults to `["perp"]`** - when omitted, only perp markets stream. Spot and outcome markets require explicit opt-in. Accepted values: - `"perp"` *(default)* - vanilla perps and HIP-3 deployer-perps (e.g. `BTC`, `ETH`, `HYPE`, `SOL`, `cash`, `abcd`, `USA500`). - `"spot"` - `@` spot markets and legacy spot pairs (e.g. `@1`, `@107` for HYPE spot, `PURR/USDC`). Not included by default. - `"outcome"` - HIP-4 prediction-market outcomes (e.g. `#700`, `#710`, `#741`). Not included by default. - `"*"` - every current type (`"perp"` + `"spot"` + `"outcome"`) and auto-opt-in to any future types the server adds. Mix and match in one subscription, e.g. `["perp", "outcome"]`. A second `subscribe` with a different `marketTypes` value **replaces** the previous filter rather than coexisting with it.  |

### Example

Pick the subscription shape that matches the coverage you want. Every subscription starts with one `Snapshot` per coin in scope, then per-block `Updates` carrying only changed levels:

| Subscribe with | What you receive |
|---|---|
| `{"type":"l2BookDiff","coin":"HYPE"}` | Snapshot + diffs for **HYPE only** |
| `{"type":"l2BookDiff","coin":["HYPE","BTC","ETH"]}` | Snapshot + diffs for **a fixed list of coins** |
| `{"type":"l2BookDiff"}` | Snapshot + diffs for **every perp coin** (default: `marketTypes: ["perp"]`) |
| `{"type":"l2BookDiff","marketTypes":["spot"]}` | Snapshot + diffs for **every spot coin** |
| `{"type":"l2BookDiff","marketTypes":["outcome"]}` | Snapshot + diffs for **every HIP-4 outcome market** |
| `{"type":"l2BookDiff","marketTypes":["perp","spot"]}` | Snapshot + diffs for **perps + spot** |
| `{"type":"l2BookDiff","marketTypes":["*"]}` | Snapshot + diffs for **every coin** (perp + spot + outcome, plus future types) |

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"l2BookDiff","coin":"HYPE"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2BookDiff", coin: "HYPE" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l2BookDiff") return;

  if (msg.data.Snapshot) {
    const { coin, time, block_height, levels: [bids, asks] } = msg.data.Snapshot;
    console.log("snapshot", coin, time, block_height, "bids:", bids.length, "asks:", asks.length);
  } else if (msg.data.Updates) {
    const { time, block_height, book_diffs } = msg.data.Updates;
    console.log("updates", time, block_height, "coins:", book_diffs.length);
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2BookDiff", "coin": "HYPE"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l2BookDiff":
                continue
            data = msg["data"]
            if "Snapshot" in data:
                snap = data["Snapshot"]
                bids, asks = snap["levels"]
                print("snapshot", snap["coin"], snap["time"], snap["block_height"], "bids:", len(bids), "asks:", len(asks))
            elif "Updates" in data:
                upd = data["Updates"]
                print("updates", upd["time"], upd["block_height"], "coins:", len(upd["book_diffs"]))

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": { "type": "l2BookDiff", "coin": "HYPE" }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `coin: ["BTC", "ETH"]` is a different subscription from one created with `coin: "BTC"` or `coin: "ETH"`.

**You cannot unsubscribe a partial set of coins from an existing multi-coin subscription.** To narrow the set, unsubscribe the original `coin` array in full, then resubscribe with the smaller list:

  ```json
  // Drop ETH from a ["BTC","ETH"] subscription:
  { "method": "unsubscribe", "subscription": { "type": "l2BookDiff", "coin": ["BTC", "ETH"] } }
  { "method": "subscribe",   "subscription": { "type": "l2BookDiff", "coin": ["BTC"] } }
  ```

## Streamed messages

Every message has `channel: "l2BookDiff"`. The `data` payload contains **exactly one** of two variants: a `Snapshot` (emitted once per subscribed coin, immediately after subscribe) or an `Updates` (emitted on each subsequent HyperCore block where the book for at least one subscribed coin changed).

### Initial snapshot

After subscribe, the server emits one `Snapshot` message per coin currently in scope. For a single-coin subscription that is one message; for a list or wildcard subscription that is one message per asset. Each entry in `levels[0]` (bids) and `levels[1]` (asks) is an aggregated price level, sorted best-first.

```json
{
  "channel": "l2BookDiff",
  "data": {
    "Snapshot": {
      "coin": "HYPE",
      "time": 1779220051027,
      "block_height": 1002862373,
      "levels": [
        [
          { "px": "48.601", "sz": "51.26", "n": 1 }
        ],
        [
          { "px": "48.614", "sz": "12.34", "n": 1 }
        ]
      ]
    }
  }
}
```

### Incremental updates

Subsequent messages carry only the levels that changed since the previous block, grouped by coin. A level entry with `sz: "0"` and `n: 0` means **the level at that price has been removed**; any other entry replaces the current state at that `px` with the new `{sz, n}`.

```json
{
  "channel": "l2BookDiff",
  "data": {
    "Updates": {
      "time": 1779220051224,
      "block_height": 1002862374,
      "book_diffs": [
        {
          "coin": "HYPE",
          "levels": [
            [
              { "px": "48.601", "sz": "60.00", "n": 2 }
            ],
            [
              { "px": "48.614", "sz": "0", "n": 0 }
            ]
          ]
        }
      ]
    }
  }
}
```

### Response fields

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"l2BookDiff"`. |
| `data` | `object` | Contains exactly one of `Snapshot` or `Updates`. |
| `data.coin` | `string` | Asset symbol the snapshot belongs to. |
| `data.time` | `int` | HyperCore block timestamp in milliseconds. |
| `data.block_height` | `int` | HyperCore block height the snapshot was taken at. |
| `data.levels` | `array>` | Tuple `[bids, asks]`. Each side is an array of aggregated **Level** objects in best-first order.  __RESPONSE_ROW__px	string	Price for this level (decimal string). __RESPONSE_ROW__data.sz	string	Aggregate size resting at this level (decimal string, base units). __RESPONSE_ROW__data.n	int	Number of orders aggregated into this level.   HyperCore block timestamp in milliseconds. |
| `block_height` | `int` | HyperCore block height. |
| `book_diffs` | `array` | Per-coin lists of changed price levels. One entry per coin that had changes at this block. |
| `book_diffs.coin` | `string` | Asset symbol the diff applies to. |
| `book_diffs.levels` | `array>` | Tuple `[changed_bids, changed_asks]`. Each entry replaces the current state at its `px`. An entry with `sz: "0"` and `n: 0` removes the level at that price.  __RESPONSE_ROW__px	string	Price for this level (decimal string). __RESPONSE_ROW__book_diffs.sz	string	New aggregate size at this level (decimal string). `"0"` means the level is removed. __RESPONSE_ROW__book_diffs.n	int	New number of orders aggregated into this level. `0` means the level is removed.  |



{/* generated:hl-linkhub-start */}

## Related endpoints


### l2Book

subscribe to real-time L2 order book snapshots for all Hyperliquid assets over WebSocket.

### l2BookDiff2

subscribe to a diff-only L2 order book stream with per-coin sequence numbers and a server epoch for gap detection.

### l4Book

subscribe to GoldRush's order-level Hyperliquid book - initial snapshot of every resting order plus per-block diffs with full metadata.

### l4BookUpdates

subscribe to a strictly-ordered, diff-only order-level (L4) book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-16_

{/* generated:hl-footer-end */}

---

## l2BookDiff2 | Hyperliquid WebSocket API

**Processing:** Realtime

> **Note:** - GoldRush-native. `l2BookDiff2` is not exposed on `wss://api.hyperliquid.xyz/ws`. Pointing a client at the public endpoint with this subscription type will fail.
- **Diff-only — no inline snapshot.** Unlike **`l2BookDiff`**, this stream never sends a `Snapshot` frame. Every message is an `Updates` batch. Seed your local book from the REST **`l2BookDiffSnapshot`** info method, then apply diffs on top — see [Bootstrapping & gap detection](#bootstrapping--gap-detection) below.
- **Sequenced for gap detection.** Each per-coin diff carries a monotonic `seq` and the `prev_seq` it follows; each batch carries a server `epoch` and a `cursor`. This lets a client detect a dropped message or a server reset and re-bootstrap deterministically.
- `coin` is optional. Omit it to stream every asset on a single subscription; use `marketTypes` to choose which market families are included (defaults to `["perp"]`).

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"l2BookDiff2"`. __RESPONSE_ROW__coin	string \| string[]	Asset filter. Accepts three shapes: - **String** - a single asset symbol (e.g. `"HYPE"`, `"BTC"`, `"@107"` for spot pairs). For HIP-3 markets, include the deployer prefix. - **Array of strings** - a fixed list of asset symbols (e.g. `["HYPE", "BTC", "ETH"]`). Each coin is sequenced independently. - **Omitted** - wildcard. Streams diffs across **every perp asset** by default on one subscription (see `marketTypes` to include spot or outcome markets). __RESPONSE_ROW__marketTypes	string[]	Optional. Selects which market families a wildcard subscription includes. **Only valid when `coin` is omitted.** **Defaults to `["perp"]`.** Accepted values: - `"perp"` *(default)* - vanilla perps and HIP-3 deployer-perps. - `"spot"` - `@` spot markets and legacy spot pairs. Not included by default. - `"outcome"` - HIP-4 prediction-market outcomes. Not included by default. - `"*"` - every current type (`"perp"` + `"spot"` + `"outcome"`) and auto-opt-in to any future types. Mix and match in one subscription, e.g. `["perp", "outcome"]`. A second `subscribe` with a different `marketTypes` value **replaces** the previous filter.  |

### Example

| Subscribe with | What you receive |
|---|---|
| `{"type":"l2BookDiff2","coin":"HYPE"}` | Diffs for **HYPE only** |
| `{"type":"l2BookDiff2","coin":["HYPE","BTC","ETH"]}` | Diffs for **a fixed list of coins** |
| `{"type":"l2BookDiff2"}` | Diffs for **every perp coin** (default: `marketTypes: ["perp"]`) |
| `{"type":"l2BookDiff2","marketTypes":["*"]}` | Diffs for **every coin** (perp + spot + outcome, plus future types) |

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"l2BookDiff2","coin":"BTC"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2BookDiff2", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l2BookDiff2") return;

  const { time, block_height, epoch, cursor, book_diffs } = msg.data.Updates;
  for (const d of book_diffs) {
    console.log(block_height, epoch, d.coin, "seq", d.prev_seq, "->", d.seq);
    // apply d.levels = [changedBids, changedAsks]; sz "0" removes the level
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2BookDiff2", "coin": "BTC"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l2BookDiff2":
                continue
            upd = msg["data"]["Updates"]
            for d in upd["book_diffs"]:
                print(upd["block_height"], upd["epoch"], d["coin"], "seq", d["prev_seq"], "->", d["seq"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": { "type": "l2BookDiff2", "coin": "BTC" }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `coin: ["BTC", "ETH"]` is a different subscription from one created with `coin: "BTC"`. To narrow a multi-coin set, unsubscribe the original `coin` array in full, then resubscribe with the smaller list.

## Streamed messages

Every message has `channel: "l2BookDiff2"` and a `data` payload containing an `Updates` batch (this stream never emits a `Snapshot`). An `Updates` batch is emitted on each HyperCore block where the book for at least one subscribed coin changed.

```json
{
  "channel": "l2BookDiff2",
  "data": {
    "Updates": {
      "time": 1786379817106,
      "block_height": 1105180205,
      "epoch": "466bf60f-bb7a-4591-89a3-a2660234fef5",
      "cursor": "1105180205:1786379817106",
      "book_diffs": [
        {
          "coin": "BTC",
          "seq": 4229978,
          "prev_seq": 4229977,
          "levels": [
            [
              { "px": "57686.0", "sz": "0.09903", "n": 25 }
            ],
            [
              { "px": "64164.0", "sz": "0", "n": 0 }
            ]
          ]
        }
      ]
    }
  }
}
```

Each entry in `levels[0]` (bids) and `levels[1]` (asks) replaces the current state at its `px`. A level with `sz: "0"` and `n: 0` means **the level at that price has been removed**.

## Bootstrapping & gap detection

`l2BookDiff2` gives you diffs only, so you build the book yourself by seeding from a snapshot and applying diffs in order:

1. **Subscribe** to `l2BookDiff2` for your coin(s) and start **buffering** the incoming `Updates`.
2. **Fetch a snapshot** for each coin from the REST **`l2BookDiffSnapshot`** info method. Note its `height`, `epoch`, and per-coin `seq`.
3. **Discard already-applied diffs.** Drop any buffered batch whose `block_height` is **≤** the snapshot's `height` (the snapshot already includes those blocks). You may equivalently discard per coin by `seq` - drop any diff whose `seq` **≤** the snapshot's `seq` - for the tightest alignment.
4. **Verify the epoch.** Every remaining diff's `epoch` must equal the snapshot's `epoch`. A different `epoch` means the stream reset after your snapshot - re-fetch the snapshot and restart.
5. **Apply in order.** For each coin, the first diff you apply should have `prev_seq == snapshot.seq`. For each level, upsert `{px, sz, n}`, or remove the price when `sz` is `"0"`.
6. **Ongoing gap detection.** Per coin, each diff's `prev_seq` must equal the last `seq` you applied for that coin. On a mismatch (a dropped message) or an `epoch` change (a server reset), re-bootstrap that coin from step 2.

> **Tip:** The `seq`/`prev_seq` are **per coin**, tracked within the current `epoch`. Compare them per coin, not globally across the batch.

## Response fields

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"l2BookDiff2"`. |
| `data` | `object` | Contains an `Updates` batch. |
| `data.time` | `int` | HyperCore block timestamp in milliseconds. |
| `data.block_height` | `int` | HyperCore block height these diffs were produced at. Align against the snapshot's `height`. |
| `data.epoch` | `string` | Server generation (UUID). Regenerated when the stream resets (e.g. a server restart); a new `epoch` means your snapshot and buffered diffs are stale, so re-bootstrap. Matches the `epoch` in the **`l2BookDiffSnapshot`** response. |
| `data.cursor` | `string` | A per-batch position marker, formatted `":"`. To recover from a disconnect, re-bootstrap from a fresh `l2BookDiffSnapshot` (see [Bootstrapping & gap detection](#bootstrapping--gap-detection)) — the stream does not replay from this value. |
| `data.book_diffs` | `array` | Per-coin lists of changed price levels. One entry per coin that changed at this block.  __RESPONSE_ROW__coin	string	Asset symbol the diff applies to. __RESPONSE_ROW__data.seq	int	Per-coin monotonic sequence for this diff, within the current `epoch`. __RESPONSE_ROW__data.prev_seq	int	The `seq` of the previous diff for this coin. Must equal the last `seq` you applied for the coin (or the snapshot's `seq` for the first diff after a bootstrap). A mismatch signals a gap. __RESPONSE_ROW__data.levels	array>	Tuple `[changed_bids, changed_asks]`. Each entry replaces the current state at its `px`; an entry with `sz: "0"` and `n: 0` removes the level at that price.  Price for this level (decimal string). __RESPONSE_ROW__data.sz	string	New aggregate size at this level (decimal string). `"0"` means the level is removed. __RESPONSE_ROW__data.n	int	New number of orders aggregated into this level. `0` means the level is removed.  |



{/* generated:hl-linkhub-start */}

## Related endpoints


### l2Book

subscribe to real-time L2 order book snapshots for all Hyperliquid assets over WebSocket.

### l2BookDiff

subscribe to real-time L2 order book (initial snapshot + diffs) for all Hyperliquid assets over WebSocket.

### l4Book

subscribe to GoldRush's order-level Hyperliquid book - initial snapshot of every resting order plus per-block diffs with full metadata.

### l4BookUpdates

subscribe to a strictly-ordered, diff-only order-level (L4) book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

---

## l2Book | Hyperliquid WebSocket API

**Credit Cost:** 0.5 per coin per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-compatible with `wss://api.hyperliquid.xyz/ws` `l2Book` subscriptions - same channel name, same `levels` shape.
- `coin` is optional on GoldRush. Omit it to stream the entire L2 order book across every asset on a single subscription. The public Hyperliquid API requires `coin` and locks each subscription to one asset at a time.
- When `coin` is omitted, the optional `marketTypes` filter selects which market families to include. It defaults to `["perp"]` only.
- Pass `"marketTypes": ["spot"]`, or `"marketTypes":["outcome"]`, or a mix (e.g. `"marketTypes": ["perp","spot"]`), or use the wildcard `"marketTypes": ["*"]` to opt into spot, perps, outcome, and any future market types.
- No 1000-subscription-per-IP cap - multiplex hundreds of `l2Book` subscriptions on a single connection.
- For OHLCV candles instead of raw book state, use the [Streaming API OHLCV streams](https://goldrush.dev/docs/api-reference/streaming-api/subscriptions/ohlcv-pairs-stream).

**Note:** When `coin` is omitted, a credit rate of `50` **credits per minute subscribed** is applied.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"l2Book"`. __RESPONSE_ROW__coin	string	Asset symbol - e.g. `"BTC"`, `"ETH"`, `"@107"` for spot pairs. For HIP-3 markets, include the deployer prefix. Omit to receive snapshots for **all perp assets** (the default; see `marketTypes` to include spot or outcome markets). __RESPONSE_ROW__marketTypes	string[]	Optional. Selects which market families a wildcard subscription includes. **Only valid when `coin` is omitted.** **Defaults to `["perp"]`** - when omitted, only perp markets stream. Spot and outcome markets require explicit opt-in. Accepted values: - `"perp"` *(default)* - vanilla perps and HIP-3 deployer-perps (e.g. `BTC`, `ETH`, `HYPE`, `SOL`, `cash`, `abcd`, `USA500`). - `"spot"` - `@` spot markets and legacy spot pairs (e.g. `@1`, `@107` for HYPE spot, `PURR/USDC`). Not included by default. - `"outcome"` - HIP-4 prediction-market outcomes (e.g. `#700`, `#710`, `#741`). Not included by default. - `"*"` - every current type (`"perp"` + `"spot"` + `"outcome"`) and auto-opt-in to any future types the server adds. Mix and match in one subscription, e.g. `["perp", "outcome"]`. A second `subscribe` with a different `marketTypes` value **replaces** the previous filter rather than coexisting with it. __RESPONSE_ROW__nSigFigs	int	Significant figures used for price aggregation. One of `2`, `3`, `4`, `5`, or `null` for full precision. Defaults to `null`. __RESPONSE_ROW__mantissa	int	When `nSigFigs` is 5, controls the mantissa rounding. One of `1`, `2`, or `5`. Not allowed for other `nSigFigs` values.  |

### Example

Pick the subscription shape that matches the coverage you want:

| Subscribe with | What you receive |
|---|---|
| `{"type":"l2Book","coin":"BTC"}` | L2 snapshots for **BTC only** |
| `{"type":"l2Book"}` | L2 snapshots for **every perp coin** (default: `marketTypes: ["perp"]`) |
| `{"type":"l2Book","marketTypes":["spot"]}` | L2 snapshots for **every spot coin** |
| `{"type":"l2Book","marketTypes":["outcome"]}` | L2 snapshots for **every HIP-4 outcome market** |
| `{"type":"l2Book","marketTypes":["perp","spot"]}` | L2 snapshots for **perps + spot** |
| `{"type":"l2Book","marketTypes":["*"]}` | L2 snapshots for **every coin** (perp + spot + outcome, plus future types) |

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"l2Book","coin":"BTC"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "l2Book") {
    const { coin, time, levels: [bids, asks] } = msg.data;
    console.log(coin, time, "top bid:", bids[0], "top ask:", asks[0]);
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2Book", "coin": "BTC"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "l2Book":
                print(msg["data"]["coin"], msg["data"]["time"], msg["data"]["levels"][0][:1])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": { "type": "l2Book", "coin": "BTC" }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `coin: ["BTC", "ETH"]` is a different subscription from one created with `coin: "BTC"` or `coin: "ETH"`.

**You cannot unsubscribe a partial set of coins from an existing multi-coin subscription.** To narrow the set, unsubscribe the original `coin` array in full, then resubscribe with the smaller list:

  ```json
  // Drop ETH from a ["BTC","ETH"] subscription:
  { "method": "unsubscribe", "subscription": { "type": "l2Book", "coin": ["BTC", "ETH"] } }
  { "method": "subscribe",   "subscription": { "type": "l2Book", "coin": ["BTC"] } }
  ```

## Streamed message

Each message has `channel: "l2Book"` and a `data` payload with the current book snapshot for the subscribed coin.

```json
{
  "channel": "l2Book",
  "data": {
    "coin": "BTC",
    "time": 1762450000123,
    "block_height": 996629014,
    "levels": [
      [
        { "px": "68210.0", "sz": "1.2345", "n": 3 },
        { "px": "68209.5", "sz": "4.5670", "n": 5 },
        { "px": "68209.0", "sz": "2.1100", "n": 2 }
      ],
      [
        { "px": "68215.0", "sz": "0.8900", "n": 2 },
        { "px": "68215.5", "sz": "3.4500", "n": 4 },
        { "px": "68216.0", "sz": "1.2300", "n": 1 }
      ]
    ]
  }
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"l2Book"`. |
| `data` | `object` |  |
| `data.coin` | `string` | Asset symbol the snapshot belongs to. |
| `data.time` | `int` | HyperCore block timestamp in milliseconds. |
| `data.block_height` | `int` | HyperCore block height the snapshot was taken at. |
| `data.levels` | `array>` | Tuple `[bids, asks]`. Each side is an array of price levels in best-first order.  __RESPONSE_ROW__px	string	Price for this level (decimal string). __RESPONSE_ROW__data.sz	string	Aggregate size resting at this level (decimal string, base units). __RESPONSE_ROW__data.n	int	Number of orders aggregated into this level.  |

{/* generated:hl-linkhub-start */}

## Related endpoints


### l2BookDiff

subscribe to real-time L2 order book (initial snapshot + diffs) for all Hyperliquid assets over WebSocket.

### l2BookDiff2

subscribe to a diff-only L2 order book stream with per-coin sequence numbers and a server epoch for gap detection.

### l4Book

subscribe to GoldRush's order-level Hyperliquid book - initial snapshot of every resting order plus per-block diffs with full metadata.

### l4BookUpdates

subscribe to a strictly-ordered, diff-only order-level (L4) book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-07-28_

{/* generated:hl-footer-end */}

---

## l4BookUpdates | Hyperliquid WebSocket API

**Credit Cost:** 1 per coin per minute


**Processing:** Realtime

> **Note:** - GoldRush-native. `l4BookUpdates` is not exposed on `wss://api.hyperliquid.xyz/ws`. Pointing a client at the public endpoint with this subscription type will fail.
- **Order-level (L4) diffs.** Like **`l4Book`**, every change is per **individual order** (`user`, `oid`, `side`, `raw_book_diff`) plus the order-lifecycle `order_statuses` for the block — not aggregated price levels.
- **Strictly block-ordered.** Diffs are emitted synchronously in monotonic `block_height` order. This is the difference from **`l4Book`**, whose per-block broadcast can deliver adjacent blocks out of order. The `l4Book` channel is unchanged; `l4BookUpdates` is the strictly-ordered, sequenced sibling.
- **Diff-only — no inline snapshot.** This stream never sends a `Snapshot` frame; every message is an `Updates` batch. Seed your local book from the REST **`l4BookSnapshot`** info method, then apply diffs on top — see [Bootstrapping & gap detection](#bootstrapping--gap-detection).
- **Sequenced for gap detection.** Each per-coin diff carries a monotonic `seq` and the `prev_seq` it follows; each batch carries a server `epoch` and a `cursor`. This lets a client detect a dropped message or a server reset and re-bootstrap deterministically.
- **Perps only.** No spot or prediction-market assets. `coin` is required — subscribe with a single symbol or an array of symbols; one asset per book.

**Note:** `l4BookUpdates` bills a **flat** rate per subscribed coin per minute, with **no BTC premium** (unlike **`l4Book`**). A multi-coin array bills the sum across its coins.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"l4BookUpdates"`. __RESPONSE_ROW__coin	string \| string[]	Asset filter. Perps only. Accepts two shapes: - **String** - a single perp symbol (e.g. `"BTC"`, `"HYPE"`). For HIP-3 deployer-perps, include the deployer prefix. - **Array of strings** - a fixed list of perp symbols (e.g. `["BTC", "ETH", "HYPE"]`, up to 64). Each coin is sequenced independently and billed independently. Unlike **`l2BookDiff2`**, there is no spot/outcome market filter — `l4BookUpdates` is perp-only.  |

### Example

| Subscribe with | What you receive |
|---|---|
| `{"type":"l4BookUpdates","coin":"BTC"}` | Order-level diffs for **BTC only** |
| `{"type":"l4BookUpdates","coin":["BTC","ETH","HYPE"]}` | Diffs for **a fixed list of perps** |

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"l4BookUpdates","coin":"BTC"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l4BookUpdates", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l4BookUpdates") return;

  const { block_height, epoch, book_diffs } = msg.data.Updates;
  for (const c of book_diffs) {
    console.log(block_height, epoch, c.coin, "seq", c.prev_seq, "->", c.seq);
    for (const d of c.book_diffs) {
      // d.raw_book_diff is { new: { sz } } | { update: { origSz, newSz } } | "remove"
      console.log("  ", d.side, d.oid, d.px, JSON.stringify(d.raw_book_diff));
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri, max_size=None) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l4BookUpdates", "coin": "BTC"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l4BookUpdates":
                continue
            upd = msg["data"]["Updates"]
            for c in upd["book_diffs"]:
                print(upd["block_height"], upd["epoch"], c["coin"], "seq", c["prev_seq"], "->", c["seq"])
                for d in c["book_diffs"]:
                    print("  ", d.get("side"), d["oid"], d["px"], d["raw_book_diff"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": { "type": "l4BookUpdates", "coin": "BTC" }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `coin: ["BTC", "ETH"]` is a different subscription from one created with `coin: "BTC"`. To narrow a multi-coin set, unsubscribe the original `coin` array in full, then resubscribe with the smaller list.

## Streamed messages

Every message has `channel: "l4BookUpdates"` and a `data` payload containing an `Updates` batch (this stream never emits a `Snapshot`). An `Updates` batch is emitted on each HyperCore block where the book for at least one subscribed coin changed. Each per-coin entry carries the block's `order_statuses` (order lifecycle events) and `book_diffs` (per-order changes) for that coin, plus its own `seq`/`prev_seq`.

```json
{
  "channel": "l4BookUpdates",
  "data": {
    "Updates": {
      "time": 1778865761768,
      "block_height": 997719813,
      "epoch": "466bf60f-bb7a-4591-89a3-a2660234fef5",
      "cursor": "997719813:1778865761768",
      "book_diffs": [
        {
          "coin": "BTC",
          "seq": 4229978,
          "prev_seq": 4229977,
          "order_statuses": [
            {
              "time": "2026-05-15T17:22:41.768005701",
              "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
              "status": "open",
              "order": {
                "user": null,
                "coin": "BTC",
                "side": "B",
                "limitPx": "79242.0",
                "sz": "0.00867",
                "oid": 427632416336,
                "timestamp": 1778865761768,
                "triggerCondition": "N/A",
                "isTrigger": false,
                "triggerPx": "0.0",
                "isPositionTpsl": false,
                "reduceOnly": false,
                "orderType": "Limit",
                "tif": "Alo",
                "cloid": null
              }
            }
          ],
          "book_diffs": [
            {
              "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
              "oid": 427632416336,
              "side": "B",
              "px": "79242.0",
              "coin": "BTC",
              "raw_book_diff": { "new": { "sz": "0.00867" } }
            }
          ]
        }
      ]
    }
  }
}
```

The `raw_book_diff` descriptor is one of:

- `{ "new": { "sz": "" } }` — a newly resting order.
- `{ "update": { "origSz": "", "newSz": "" } }` — a resize (e.g. partial fill).
- `"remove"` — the order left the book (filled or cancelled).

## Bootstrapping & gap detection

`l4BookUpdates` is diff-only, so you build the order-level book yourself by seeding from a snapshot and applying diffs in order — the same mechanism a reference L4 client uses:

1. **Subscribe** to `l4BookUpdates` for your coin(s) and start **buffering** the incoming `Updates`.
2. **Fetch a snapshot** for each coin from the REST **`l4BookSnapshot`** info method. Note its `height`, `epoch`, and per-coin `seq`.
3. **Discard already-applied diffs.** Drop any buffered batch whose `block_height` is **≤** the snapshot's `height` (the snapshot already includes those blocks). Equivalently, per coin, drop any diff whose `seq` **≤** the snapshot's `seq`.
4. **Verify the epoch.** Every remaining diff's `epoch` must equal the snapshot's `epoch`. A different `epoch` means the stream reset after your snapshot — re-fetch the snapshot and restart.
5. **Apply in order.** For each coin, the first diff you apply should have `prev_seq == snapshot.seq`. For each `raw_book_diff`, insert (`new`), resize (`update`), or delete (`remove`) the order by `oid`.
6. **Ongoing gap detection.** Per coin, each diff's `prev_seq` must equal the last `seq` you applied for that coin. On a mismatch (a dropped message) or an `epoch` change (a server reset), re-bootstrap that coin from step 2.

> **Tip:** The `seq`/`prev_seq` are **per coin**, tracked within the current `epoch`. Compare them per coin, not globally across the batch.

## Response fields

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"l4BookUpdates"`. |
| `data` | `object` | Contains an `Updates` batch. |
| `data.time` | `int` | HyperCore block timestamp in milliseconds. |
| `data.block_height` | `int` | HyperCore block height these diffs were produced at. Align against the snapshot's `height`. |
| `data.epoch` | `string` | Server generation (UUID). Regenerated when the stream resets (e.g. a server restart); a new `epoch` means your snapshot and buffered diffs are stale, so re-bootstrap. Matches the `epoch` in the **`l4BookSnapshot`** response. |
| `data.cursor` | `string` | A per-batch position marker, formatted `":"`. To recover from a disconnect, re-bootstrap from a fresh `l4BookSnapshot` (see [Bootstrapping & gap detection](#bootstrapping--gap-detection)) — the stream does not replay from this value. |
| `data.book_diffs` | `array` | Per-coin entries. One entry per subscribed coin whose book changed at this block.  __RESPONSE_ROW__coin	string	Asset symbol this entry applies to. __RESPONSE_ROW__data.seq	int	Per-coin monotonic sequence for this entry, within the current `epoch`. __RESPONSE_ROW__data.prev_seq	int	The `seq` of the previous entry for this coin. Must equal the last `seq` you applied for the coin (or the snapshot's `seq` for the first entry after a bootstrap). A mismatch signals a gap. __RESPONSE_ROW__data.order_statuses	array	Order-lifecycle events for this coin at this block.  ISO-8601 timestamp with nanosecond precision. __RESPONSE_ROW__data.user	string	Wallet address that owns the order. __RESPONSE_ROW__data.status	string	Lifecycle status (e.g. `"open"`). __RESPONSE_ROW__data.order	Order	The order, in the same shape as an **`l4Book`** snapshot entry. `user` inside this nested object is `null` because it duplicates the parent `user`. __RESPONSE_ROW__book_diffs	array	Per-order book changes for this coin at this block. __RESPONSE_ROW__book_diffs.user	string	Wallet address that owns the order. __RESPONSE_ROW__book_diffs.oid	int	Order id the diff applies to. __RESPONSE_ROW__book_diffs.side	string	`"B"` for bid, `"A"` for ask. __RESPONSE_ROW__book_diffs.px	string	Price the order rests at (decimal string). __RESPONSE_ROW__book_diffs.coin	string	Asset symbol. __RESPONSE_ROW__book_diffs.raw_book_diff	object \| string	The change descriptor: `{ "new": { "sz" } }`, `{ "update": { "origSz", "newSz" } }`, or the string `"remove"`.  |



{/* generated:hl-linkhub-start */}

## Related endpoints


### l4Book

subscribe to GoldRush's order-level Hyperliquid book - initial snapshot of every resting order plus per-block diffs with full metadata.

### l2Book

subscribe to real-time L2 order book snapshots for all Hyperliquid assets over WebSocket.

### l2BookDiff

subscribe to real-time L2 order book (initial snapshot + diffs) for all Hyperliquid assets over WebSocket.

### l2BookDiff2

subscribe to a diff-only L2 order book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

---

## l4Book | Hyperliquid WebSocket API

**Credit Cost:** 3 per coin per minute (except BTC which is 60 per minute)


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native. `l4Book` is not exposed on `wss://api.hyperliquid.xyz/ws`. Pointing a client at the public endpoint with this subscription type will fail.
- Perps only. No spot assets.
- `coin` is required. Unlike `l2Book` and `l2BookDiff`, you cannot omit `coin` to stream every asset. Open one subscription per asset.
- Snapshot, then diffs. The first message is always a `Snapshot`; every message thereafter is an `Updates`. Clients must seed local book state from the snapshot and apply diffs from there. On reconnect, drop local state and re-seed from the next snapshot.
- Per-order detail. Each entry exposes `user`, `oid`, `cloid`, `tif`, and trigger metadata - enabling queue-position reconstruction, per-trader flow attribution, and microstructure analytics that are not possible with `l2Book`.
- See the [L4 Order Book recipe](https://goldrush.dev/docs/goldrush-hyperliquid/websocket-api/l4-book) for patterns to maintain book state, attribute flow by `user`, or reconstruct aggregated price levels.

**Note:** When `"coin":"BTC"` is used, a credit rate of `60` **credits per minute subscribed** is applied.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"l4Book"`. __RESPONSE_ROW__coin	string	Asset symbol - e.g. `"BTC"`, `"ETH"`, `"@107"` for spot pairs. For HIP-3 markets, include the deployer prefix. **Required** - unlike `l2Book`, `l4Book` does not support wildcard subscriptions; each subscription is locked to a single asset.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"l4Book","coin":"BTC"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l4Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l4Book") return;

  if (msg.data.Snapshot) {
    const { coin, time, block_height, levels: [bids, asks] } = msg.data.Snapshot;
    console.log("snapshot", coin, time, block_height, "bids:", bids.length, "asks:", asks.length);
  } else if (msg.data.Updates) {
    const { time, block_height, order_statuses, book_diffs } = msg.data.Updates;
    console.log("updates", time, block_height, "statuses:", order_statuses.length, "diffs:", book_diffs.length);
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l4Book", "coin": "BTC"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l4Book":
                continue
            data = msg["data"]
            if "Snapshot" in data:
                snap = data["Snapshot"]
                bids, asks = snap["levels"]
                print("snapshot", snap["coin"], snap["time"], snap["block_height"], "bids:", len(bids), "asks:", len(asks))
            elif "Updates" in data:
                upd = data["Updates"]
                print("updates", upd["time"], upd["block_height"], "statuses:", len(upd["order_statuses"]), "diffs:", len(upd["book_diffs"]))

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": { "type": "l4Book", "coin": "BTC" }
}
```

## Streamed messages

Every message has `channel: "l4Book"`. The `data` payload contains **exactly one** of two variants: a `Snapshot` (emitted once, immediately after subscribe) or an `Updates` (emitted on each subsequent HyperCore block where the book for `coin` changed).

### Initial snapshot

The first message after subscribe carries the full resting book at the current block. Each entry in `levels[0]` (bids) and `levels[1]` (asks) is an **individual order** - not an aggregated price level.

```json
{
  "channel": "l4Book",
  "data": {
    "Snapshot": {
      "coin": "BTC",
      "time": 1778865761968,
      "block_height": 997719816,
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
  }
}
```

### Incremental updates

Subsequent messages carry only what changed since the previous block. `order_statuses` describes order lifecycle events (`open`, etc.); `book_diffs` carries the corresponding price-level changes.

```json
{
  "channel": "l4Book",
  "data": {
    "Updates": {
      "time": 1778865761768,
      "block_height": 997719813,
      "order_statuses": [
        {
          "time": "2026-05-15T17:22:41.768005701",
          "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
          "status": "open",
          "order": {
            "user": null,
            "coin": "BTC",
            "side": "B",
            "limitPx": "79242.0",
            "sz": "0.00867",
            "oid": 427632416336,
            "timestamp": 1778865761768,
            "triggerCondition": "N/A",
            "isTrigger": false,
            "triggerPx": "0.0",
            "isPositionTpsl": false,
            "reduceOnly": false,
            "orderType": "Limit",
            "tif": "Alo",
            "cloid": null
          }
        }
      ],
      "book_diffs": [
        {
          "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
          "oid": 427632416336,
          "px": "79242.0",
          "coin": "BTC",
          "raw_book_diff": { "new": { "sz": "0.00867" } }
        }
      ]
    }
  }
}
```

### Response fields

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"l4Book"`. |
| `data` | `object` | Contains exactly one of `Snapshot` or `Updates`. |
| `data.coin` | `string` | Asset symbol the snapshot belongs to. |
| `data.time` | `int` | HyperCore block timestamp in milliseconds. |
| `data.block_height` | `int` | HyperCore block height the snapshot was taken at. |
| `data.levels` | `array>` | Tuple `[bids, asks]`. Each side is an array of individual **Order** objects (see below), in queue order at their respective price. |
| `data.time` | `int` | HyperCore block timestamp in milliseconds. |
| `data.block_height` | `int` | HyperCore block height. |
| `data.order_statuses` | `array` | Order lifecycle events at this block.  __RESPONSE_ROW__time	string	ISO-8601 timestamp with nanosecond precision. __RESPONSE_ROW__data.user	string	Wallet address that owns the order. __RESPONSE_ROW__data.status	string	Lifecycle status (e.g. `"open"`). __RESPONSE_ROW__data.order	Order	The order, in the same shape as a snapshot entry. `user` inside this nested object is `null` because it duplicates the parent `user`. __RESPONSE_ROW__book_diffs	array	Per-order book changes at this block. __RESPONSE_ROW__book_diffs.user	string	Wallet address that owns the order. __RESPONSE_ROW__book_diffs.oid	int	Order id the diff applies to. __RESPONSE_ROW__book_diffs.px	string	Price level the diff applies to (decimal string). __RESPONSE_ROW__book_diffs.coin	string	Asset symbol. __RESPONSE_ROW__book_diffs.raw_book_diff	object	The change descriptor. Observed shape: `{ "new": { "sz": "" } }` for a newly resting order. Other shapes may carry size deltas or cancellations - inspect the keys to discriminate.  |

### Order object

The **Order** type appears inside `Snapshot.levels[*][*]` and `Updates.order_statuses[*].order`.

| Field | Type | Description |
| --- | --- | --- |
| `user` | `string | null` | Wallet address that owns the order. `null` when the order is nested inside an `order_status` (the parent already carries it). |
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

{/* generated:hl-linkhub-start */}

## Related endpoints


### l2Book

subscribe to real-time L2 order book snapshots for all Hyperliquid assets over WebSocket.

### l2BookDiff

subscribe to real-time L2 order book (initial snapshot + diffs) for all Hyperliquid assets over WebSocket.

### l2BookDiff2

subscribe to a diff-only L2 order book stream with per-coin sequence numbers and a server epoch for gap detection.

### l4BookUpdates

subscribe to a strictly-ordered, diff-only order-level (L4) book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}

_Last reviewed: 2026-11-02_

{/* generated:hl-footer-end */}

---

## liquidationFills | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - GoldRush-native:  No `wss://api.hyperliquid.xyz/ws` equivalent. The public WebSocket exposes per-wallet fills only; detecting liquidations there would require subscribing to every wallet and filtering.
- Global stream: Every liquidation fill on HyperCore, across every wallet, on a single subscription. No `addresses` filter is accepted.
- Every fill in this stream carries a non-null `liquidation` object. The rest of the payload mirrors `userFills`.
- Live-only: No historical snapshot on subscribe. For historical liquidations, query the Streaming API [`HypercoreLedgerEvent`](https://goldrush.dev/docs/api-reference/streaming-api/types/hypercore-ledger-event) type.

Subscribe with no addresses filter to receive every liquidation fill on HyperCore across every wallet, in real time. Same payload shape as `userFills`, with the `liquidation` object populated (with `liquidatedUser`, `markPx`, `method`) on every entry.

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"liquidationFills"`. __RESPONSE_ROW__aggregateByTime	boolean	When `true`, partial fills of the same liquidation within the same block are merged into one. Default `false`.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"liquidationFills"}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "liquidationFills" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "liquidationFills") {
    for (const [address, fill] of msg.fills) {
      console.log(
        "liquidated:", fill.liquidation.liquidatedUser,
        "via", fill.liquidation.method,
        "—", fill.coin, fill.sz, "@", fill.px,
      );
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "liquidationFills"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "liquidationFills":
                for address, fill in msg["fills"]:
                    liq = fill["liquidation"]
                    print("liquidated:", liq["liquidatedUser"],
                          "via", liq["method"], "—",
                          fill["coin"], fill["sz"], "@", fill["px"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": { "type": "liquidationFills" }
}
```

## Streamed message

Each push has `channel: "liquidationFills"` and a `fills` array of `[address, fill]` tuples. The `address` is the wallet whose order was filled (i.e. the liquidator's counterparty); `liquidation.liquidatedUser` is the wallet whose position was liquidated.

```json
{
  "channel": "liquidationFills",
  "fills": [
    [
      "0x742d35cc6634c0532925a3b844bc9e7595f7f2e2",
      {
        "coin": "ETH",
        "px": "2150.5",
        "sz": "1.5",
        "side": "B",
        "time": 1704067200000,
        "startPosition": "1.5",
        "dir": "Open Long",
        "closedPnl": "125.5",
        "hash": "0xabc...def",
        "oid": 12345678,
        "crossed": false,
        "fee": "2.5",
        "tid": 87654321,
        "feeToken": "USDC",
        "liquidation": {
          "liquidatedUser": "0x...",
          "markPx": "2148.75",
          "method": "market"
        },
        "twapId": null
      }
    ]
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"liquidationFills"`. |
| `fills` | `array` | Tuples of `[address, fill]`. Same `fill` shape as **`userFills`**, with `liquidation` always populated. |
| `fills.liquidation` | `object` | Always present on this stream.  __RESPONSE_ROW__liquidatedUser	string	The wallet whose position was liquidated. __RESPONSE_ROW__fills.markPx	string	Mark price at the time of liquidation. __RESPONSE_ROW__fills.method	string	Liquidation method - `"market"` or `"backstop"`.  All other fields (`coin`, `px`, `sz`, `side`, `time`, `startPosition`, `dir`, `closedPnl`, `hash`, `oid`, `crossed`, `fee`, `tid`, `feeToken`, `twapId`, and optional `cloid` / `builderFee` / `builder`) match the **`userFills`** shape. |

{/* generated:hl-linkhub-start */}

## Related endpoints


### allFills

stream every fill on HyperCore in real time for global market analytics and cross-wallet order-flow monitoring.

### builderFills

stream live attributed fills for one or more builder addresses in real time.

### userFills

stream real-time trade fills for one or more wallets as they execute on HyperCore.

### builderLiquidations

subscribe to real-time liquidation fills of your users.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-16_

{/* generated:hl-footer-end */}

---

## orderUpdates | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-compatible with `wss://api.hyperliquid.xyz/ws` `orderUpdates` subscription - same channel name, same per-update shape.
- Up to 1,000 wallet addresses per subscription. Use `addresses` (string[]); aliases `user`(string) and `users` (string[]) are also accepted.
- Messages are batched per HyperCore block; each push carries one or more `updates` entries, each with its own `user` field. Subscribe many wallets and receive one push per block containing every matching wallet’s events.
- Live-only — no historical snapshot of resting orders on subscribe. For the current resting-order set, use the Info API  [`frontendOpenOrders`](https://goldrush.dev/docs/api-reference/hyperliquid-info/frontend-open-orders). For historical fills, use [`userFillsByTime`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-fills-by-time).
- No 1,000-subscription-per-IP cap. Multiplex many `orderUpdates` subscriptions on a single connection.

Subscribe to one or more wallets and receive their live order status updates the moment they change when an order is placed, filled, canceled, or rejected. The server batches one push per HyperCore block, carrying every matching update as an `updates` array of objects, each tagged with the originating `user`.

**Supports up to 1,000 wallet addresses per subscription.**

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"orderUpdates"`. __RESPONSE_ROW__addresses	string[]	One or more wallet addresses (lowercase `0x`-prefixed hex) to stream order updates for. Aliases `user` (string) and `users` (string[]) are also accepted.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"orderUpdates","addresses":["0x010461c14e146ac35fe42271bdc1134ee31c703a"]}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: {
      type: "orderUpdates",
      addresses: ["0x010461c14e146ac35fe42271bdc1134ee31c703a"],
    },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "orderUpdates") {
    for (const update of msg.updates) {
      console.log(
        update.user,
        update.order.coin,
        update.order.side,
        update.order.sz,
        "@",
        update.order.limitPx,
        "->",
        update.status,
      );
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {
                "type": "orderUpdates",
                "addresses": ["0x010461c14e146ac35fe42271bdc1134ee31c703a"],
            },
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "orderUpdates":
                for update in msg["updates"]:
                    print(
                        update["user"],
                        update["order"]["coin"],
                        update["order"]["side"],
                        update["order"]["sz"],
                        "@",
                        update["order"]["limitPx"],
                        "->",
                        update["status"],
                    )

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": {
    "type": "orderUpdates",
    "addresses": ["0x010461c14e146ac35fe42271bdc1134ee31c703a"]
  }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `addresses: ["0xAAA", "0xBBB"]` is a different subscription from two single-address subscriptions. To narrow the set, unsubscribe the original list in full, then resubscribe with the smaller list.

## Streamed message

Each push has `channel: "orderUpdates"` and an `updates` array of objects - every order lifecycle event from the same HyperCore block that matches any subscribed wallet. Each entry is self-tagged with the originating `user`.

```json
{
  "channel": "orderUpdates",
  "updates": [
    {
      "time": "2026-06-18T04:21:19.321641904",
      "user": "0x010461c14e146ac35fe42271bdc1134ee31c703a",
      "hash": "0xc2e340827d8e0749c45c043df991d1019b0058681881261b66abebd53c81e134",
      "status": "open",
      "builder": null,
      "order": {
        "coin": "W",
        "side": "B",
        "oid": 472501605004,
        "limitPx": "0.00963",
        "sz": "77502.4",
        "origSz": "77502.4",
        "timestamp": 1781756479321,
        "orderType": "Limit",
        "tif": "Alo",
        "reduceOnly": false,
        "isTrigger": false,
        "isPositionTpsl": false,
        "triggerCondition": "N/A",
        "triggerPx": "0.0",
        "cloid": null,
        "children": []
      }
    }
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"orderUpdates"`. |
| `updates` | `object[]` | Array of order lifecycle events from the same HyperCore block. Each entry carries its own `user` field, so a single push can contain events for multiple subscribed wallets. |
| `updates.time` | `string` | ISO 8601 timestamp (nanosecond precision) of the HyperCore block in which the status transition occurred. |
| `updates.user` | `string` | Wallet the update belongs to (lowercase `0x`-prefixed hex). |
| `updates.hash` | `string` | Optional. L1 transaction hash for the action that produced this update. Present on placements (`"open"`); typically absent on terminal transitions like `"filled"` and `"canceled"`. |
| `updates.status` | `string` | Order lifecycle state. Common values: `"open"`, `"filled"`, `"canceled"`, `"triggered"`, plus rejection codes (`"iocCancelRejected"`, `"selfTradeCanceled"`, `"badAloPxRejected"`, `"tickRejected"`, `"minTradeNtlRejected"`, `"reduceOnlyRejected"`, `"marginCanceled"`, `"vaultWithdrawalCanceled"`, `"openInsufficientMargin"`, `"perpMarginRejected"`, `"badTriggerPxRejected"`, `"marketOrderNoLiquidityRejected"`, `"positionIncreaseAtOpenInterestCapRejected"`, `"positionFlipAtOpenInterestCapRejected"`, `"tooAggressiveAtOpenInterestCapRejected"`, `"openInterestIncreaseRejected"`, `"insufficientSpotBalanceRejected"`, `"oracleNotFoundRejected"`, `"perpMaxPositionRejected"`). |
| `updates.builder` | `string | null` | Builder address the order was routed through, or `null` if the order was not routed through a builder code. |
| `updates.order` | `object` | Order snapshot at the moment of the status change.  __RESPONSE_ROW__coin	string	Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). __RESPONSE_ROW__updates.side	string	`"B"` for buy/long, `"A"` for ask/short. __RESPONSE_ROW__updates.oid	int	Order ID. __RESPONSE_ROW__updates.limitPx	string	Limit price (decimal string). __RESPONSE_ROW__updates.sz	string	Current remaining size (decimal string). `"0.0"` after a full fill. __RESPONSE_ROW__updates.origSz	string	Original size at placement. __RESPONSE_ROW__updates.timestamp	int	Unix timestamp in milliseconds when the order was placed. __RESPONSE_ROW__updates.orderType	string	`"Limit"` or trigger variants (e.g. `"Stop Market"`, `"Stop Limit"`, `"Take Profit Market"`, `"Take Profit Limit"`). __RESPONSE_ROW__updates.tif	string	Time-in-force - `"Alo"` (add-liquidity-only / post-only), `"Ioc"` (immediate-or-cancel), or `"Gtc"` (good-til-cancel). __RESPONSE_ROW__updates.reduceOnly	boolean	`true` if the order is constrained to reduce an existing position. __RESPONSE_ROW__updates.isTrigger	boolean	`true` if this is a trigger (stop / take-profit) order. __RESPONSE_ROW__updates.isPositionTpsl	boolean	`true` for position-level take-profit / stop-loss orders. __RESPONSE_ROW__updates.triggerCondition	string	Human-readable trigger condition; `"N/A"` for plain limit orders. __RESPONSE_ROW__updates.triggerPx	string	Trigger price (decimal string); `"0.0"` for plain limit orders. __RESPONSE_ROW__updates.cloid	string \| null	Optional client order ID (`0x`-prefixed 32-character hex) if one was set at placement, otherwise `null`. __RESPONSE_ROW__updates.children	object[]	Child orders (e.g. TP/SL attached at placement); empty array if none.  |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userNonFundingLedgerUpdates

stream real-time non-funding ledger events (deposits, withdrawals, vault and staking activity) for one or more…

### userFills

stream real-time trade fills for one or more wallets as they execute on HyperCore.

### l4BookUpdates

subscribe to a strictly-ordered, diff-only order-level (L4) book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-18_

{/* generated:hl-footer-end */}

---

## userFills | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-compatible with `wss://api.hyperliquid.xyz/ws` `userFills` subscription - same channel name, same per-fill shape.
- Up to 1,000 wallet addresses per subscription. Use `addresses` (string[]); aliases `user`(string) and `users` (string[]) are also accepted.
- Messages are batched per HyperCore block as `[address, fill]` tuples; subscribe many wallets, receive one push per block per wallet that had activity.
- Live-only - no historical snapshot on subscribe. For windowed history, use the Info API `userFillsByTime`.
- No 1,000-subscription-per-IP cap. Multiplex many `userFills` subscriptions on a single connection.

Subscribe to one or more wallets and receive their live trade fills the moment they execute. The server batches one push per HyperCore block, carrying every matching fill as `[address, fill]` tuples.

**Supports up to 1,000 wallet addresses per subscription.**

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"userFills"`. __RESPONSE_ROW__addresses	string[]	One or more wallet addresses (lowercase `0x`-prefixed hex) to stream fills for. Aliases `user` (string) and `users` (string[]) are also accepted. __RESPONSE_ROW__aggregateByTime	boolean	When `true`, partial fills of the same order within the same block are merged into one. Default `false`.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"userFills","addresses":["0x31ca8395cf837de08b24da3f660e77761dfb974b"]}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: {
      type: "userFills",
      addresses: ["0x31ca8395cf837de08b24da3f660e77761dfb974b"],
    },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "userFills") {
    for (const [address, fill] of msg.fills) {
      console.log(address, fill.coin, fill.side, fill.sz, "@", fill.px);
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {
                "type": "userFills",
                "addresses": ["0x31ca8395cf837de08b24da3f660e77761dfb974b"],
            },
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "userFills":
                for address, fill in msg["fills"]:
                    print(address, fill["coin"], fill["side"], fill["sz"], "@", fill["px"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": {
    "type": "userFills",
    "addresses": ["0x31ca8395cf837de08b24da3f660e77761dfb974b"]
  }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. A subscription created with `addresses: ["0xAAA", "0xBBB"]` is a different subscription from two single-address subscriptions. To narrow the set, unsubscribe the original list in full, then resubscribe with the smaller list.

## Streamed message

Each push has `channel: "userFills"` and a `fills` array of `[address, fill]` tuples - all fills from the same HyperCore block that match any subscribed wallet.

```json
{
  "channel": "userFills",
  "fills": [
    [
      "0x31ca8395cf837de08b24da3f660e77761dfb974b",
      {
        "coin": "ETH",
        "px": "2150.5",
        "sz": "1.5",
        "side": "B",
        "time": 1704067200000,
        "startPosition": "1.5",
        "dir": "Open Long",
        "closedPnl": "125.5",
        "hash": "0xabc...def",
        "oid": 12345678,
        "crossed": false,
        "fee": "2.5",
        "tid": 87654321,
        "feeToken": "USDC",
        "twapId": null
      }
    ]
  ]
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"userFills"`. |
| `fills` | `array` | Tuples of `[address, fill]`. The `address` is the subscribed wallet the fill belongs to; the `fill` object carries the trade details. |
| `fills.coin` | `string` | Asset symbol - e.g. `"BTC"`, `"ETH"` for perps; spot pairs use the `@N` form (e.g. `"@107"`). |
| `fills.px` | `string` | Fill execution price (decimal string). |
| `fills.sz` | `string` | Fill size (decimal string). |
| `fills.side` | `string` | `"B"` for buy/long, `"A"` for ask/short. |
| `fills.time` | `int` | Unix timestamp in milliseconds when the fill executed. |
| `fills.startPosition` | `string` | Signed position size on the same coin immediately before this fill. |
| `fills.dir` | `string` | Human-readable direction label - `"Open Long"`, `"Open Short"`, `"Close Long"`, `"Close Short"`, `"Buy"`, `"Sell"`, or position-flip labels `"Long > Short"` / `"Short > Long"`. |
| `fills.closedPnl` | `string` | Realized PnL in USDC attributable to this fill (zero when the fill opens or extends a position). |
| `fills.hash` | `string` | L1 transaction hash that included this fill. |
| `fills.oid` | `int` | Parent order ID. |
| `fills.crossed` | `boolean` | `true` when the fill came from the taker side of the order, `false` when it was the maker side. |
| `fills.fee` | `string` | Trading fee paid for this fill, denominated in `feeToken`. |
| `fills.tid` | `int` | Unique trade ID. |
| `fills.feeToken` | `string` | Symbol the fee was paid in - typically `"USDC"`. |
| `fills.twapId` | `int | null` | Parent TWAP order ID if this fill is a slice of a TWAP, otherwise `null`. |
| `fills.cloid` | `string` | Optional. Client order ID (`0x`-prefixed 32-character hex) if one was set at order placement. |
| `fills.builderFee` | `string` | Optional. Builder fee paid for this fill, denominated in `feeToken`. Present only on fills routed through a builder code. |
| `fills.builder` | `string` | Optional. Builder address the order was routed through. |
| `fills.liquidation` | `object` | Optional. Present only when this fill closed a position as part of a liquidation event.  __RESPONSE_ROW__liquidatedUser	string	The wallet whose position was liquidated. __RESPONSE_ROW__fills.markPx	string	Mark price at the time of liquidation. __RESPONSE_ROW__fills.method	string	Liquidation method - `"market"` or `"backstop"`.  |

{/* generated:hl-linkhub-start */}

## Related endpoints


### userNonFundingLedgerUpdates

stream real-time non-funding ledger events (deposits, withdrawals, vault and staking activity) for one or more…

### allFills

stream every fill on HyperCore in real time for global market analytics and cross-wallet order-flow monitoring.

### builderFills

stream live attributed fills for one or more builder addresses in real time.

### liquidationFills

stream a global, market-wide feed of every liquidation fill on HyperCore.

### builderLiquidations

subscribe to real-time liquidation fills of your users.

### orderUpdates

stream real-time order lifecycle events (placements, fills, cancels, and rejections) for one or more wallets on HyperCore.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-16_

{/* generated:hl-footer-end */}

---

## userNonFundingLedgerUpdates | Hyperliquid WebSocket API

**Credit Cost:** 1 per minute


**Processing:** Realtime

> **Tip:** Estimate your monthly cost for this API using the **Pricing Calculator**.

> **Note:** - Wire-compatible with `wss://api.hyperliquid.xyz/ws` `userNonFundingLedgerUpdates`subscription - same channel name, same `delta` shape per event.
- Up to 1,000 wallet addresses per subscription. Use `addresses` (string[]); aliases `user`(string) and `users` (string[]) are also accepted.
- Covers everything that moves USDC or token balances except funding payments - deposits, withdrawals, transfers, liquidations, vault actions, staking, rewards.
- Live-only: `isSnapshot` is always `false` on this transport. For windowed history, use the Info API [`userNonFundingLedgerUpdates`](https://goldrush.dev/docs/api-reference/hyperliquid-info/user-non-funding-ledger-updates).

Subscribe to one or more wallets and receive every non-funding ledger event in real time: deposits, withdrawals, transfers, liquidations, vault deposits/withdrawals, staking, rewards, and more. Each push carries a list of `{time, hash, delta}` entries where `delta.type` identifies the event class and the remaining `delta` fields are type-specific.

**Supports up to 1,000 wallet addresses per subscription.**

## Endpoint

```
wss://hypercore.goldrushdata.com/ws?key=
```

  Your GoldRush API key. Passed as a query parameter at connection time - no `Authorization` header is used.

## Subscribe

Send this JSON message after the connection is established:

| Parameter | Type | Required | Description |
| --- | --- | --- | --- |
| `method` | `string` | Yes | Always `"subscribe"`. |
| `subscription` | `object` | Yes |  __RESPONSE_ROW__type	string	Always `"userNonFundingLedgerUpdates"`. __RESPONSE_ROW__addresses	string[]	One or more wallet addresses (lowercase `0x`-prefixed hex) to stream events for. Aliases `user` (string) and `users` (string[]) are also accepted.  |

### Example

```bash wscat
wscat -c "wss://hypercore.goldrushdata.com/ws?key=$GOLDRUSH_API_KEY"

> {"method":"subscribe","subscription":{"type":"userNonFundingLedgerUpdates","addresses":["0x31ca8395cf837de08b24da3f660e77761dfb974b"]}}
```

```typescript TypeScript
import WebSocket from "ws";

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: {
      type: "userNonFundingLedgerUpdates",
      addresses: ["0x31ca8395cf837de08b24da3f660e77761dfb974b"],
    },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel === "userNonFundingLedgerUpdates") {
    const { user, nonFundingLedgerUpdates } = msg.data;
    for (const update of nonFundingLedgerUpdates) {
      console.log(user, update.delta.type, update.delta);
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {
                "type": "userNonFundingLedgerUpdates",
                "addresses": ["0x31ca8395cf837de08b24da3f660e77761dfb974b"],
            },
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") == "userNonFundingLedgerUpdates":
                data = msg["data"]
                for update in data["nonFundingLedgerUpdates"]:
                    print(data["user"], update["delta"]["type"], update["delta"])

asyncio.run(main())
```

## Unsubscribe

Send the same `subscription` body with `method: "unsubscribe"`:

```json
{
  "method": "unsubscribe",
  "subscription": {
    "type": "userNonFundingLedgerUpdates",
    "addresses": ["0x31ca8395cf837de08b24da3f660e77761dfb974b"]
  }
}
```

> **Note:** Unsubscribe matches subscriptions by **exact body**. To narrow the wallet set, unsubscribe the original `addresses` list in full, then resubscribe with the smaller list.

## Streamed message

Each push has `channel: "userNonFundingLedgerUpdates"` and a `data` object keyed to a single wallet. Multi-wallet subscriptions receive one push per affected wallet.

```json
{
  "channel": "userNonFundingLedgerUpdates",
  "data": {
    "user": "0x31ca8395cf837de08b24da3f660e77761dfb974b",
    "isSnapshot": false,
    "nonFundingLedgerUpdates": [
      {
        "time": 1781560864370,
        "hash": "0xd49c1a45a99fa0b4d615043dce4a050000d7322b4492bf867864c59868937a9f",
        "delta": {
          "type": "send",
          "amount": "0.012417",
          "destination": "0x6043daf4fbd6bd60601d277312a0664551302e70",
          "usdcValue": "0.012417",
          "nativeTokenFee": "0.0"
        }
      }
    ]
  }
}
```

| Field | Type | Description |
| --- | --- | --- |
| `channel` | `string` | Always `"userNonFundingLedgerUpdates"`. |
| `data` | `object` |  |
| `data.user` | `string` | The wallet address this batch of updates belongs to. |
| `data.isSnapshot` | `boolean` | Always `false` on this live stream. The field is preserved for parity with the public Hyperliquid WebSocket contract. |
| `data.nonFundingLedgerUpdates` | `array` | One entry per ledger event in the current block.  __RESPONSE_ROW__time	int	Unix timestamp in milliseconds when the event was recorded. __RESPONSE_ROW__data.hash	string	L1 transaction hash that produced the event. __RESPONSE_ROW__data.delta	object	Event payload. `delta.type` identifies the event class; remaining `delta` fields are type-specific - see [Delta types](#delta-types) below.  |

### Delta types

`delta.type` is one of:

| Value | Description |
|---|---|
| `deposit` | USDC deposit into the perp account from an external chain. |
| `withdraw` | USDC withdrawal to an external chain. |
| `internalTransfer` | USDC transfer between Hyperliquid accounts. |
| `subAccountTransfer` | Transfer between a master account and one of its sub-accounts. |
| `accountClassTransfer` | Transfer between perp and spot accounts on the same wallet. |
| `spotTransfer` | Spot token transfer between wallets. |
| `liquidation` | Position closed by liquidation. |
| `vaultCreate` | Vault was created. |
| `vaultDeposit` | Deposit into a vault. |
| `vaultWithdraw` | Withdrawal from a vault. |
| `vaultDistribution` | Vault PnL distribution to depositors. |
| `vaultLeaderCommission` | Commission paid to a vault leader. |
| `spotGenesis` | Initial token allocation at spot deployment. |
| `rewardsClaim` | Claim of accrued rewards. |
| `accountActivationGas` | Gas fee paid to activate a new account. |
| `perpDexClassTransfer` | Transfer between different perp DEXes on the same wallet. |
| `deployGasAuction` | Gas-auction settlement for HIP-3 / HIP-4 deployments. |
| `send` | Native HYPE / token send. |
| `cStakingTransfer` | Transfer of staked HYPE between wallets. |
| `borrowLend` | Borrow or lend operation in the spot borrow-lend market. |

The remaining keys on `delta` vary by `type` and follow the public Hyperliquid `info` API `userNonFundingLedgerUpdates` payload. Common fields include `amount` (decimal string), `usdcValue` (decimal string), `coin` (string), `destination` / `source` (address strings), and `nativeTokenFee` (decimal string).

{/* generated:hl-linkhub-start */}

## Related endpoints


### userFills

stream real-time trade fills for one or more wallets as they execute on HyperCore.

### orderUpdates

stream real-time order lifecycle events (placements, fills, cancels, and rejections) for one or more wallets on HyperCore.

### l4BookUpdates

subscribe to a strictly-ordered, diff-only order-level (L4) book stream with per-coin sequence numbers and a server epoch for gap detection.

See all Hyperliquid endpoints: **Overview hub** · **WebSocket API reference**

{/* generated:hl-linkhub-end */}

{/* generated:hl-footer-start */}
_Last reviewed: 2026-06-17_

{/* generated:hl-footer-end */}

---


# Recipes

The `l2Book` channel on `wss://hypercore.goldrushdata.com/ws?key=` is wire-equal to the public Hyperliquid feed but with `coin` made optional and the per-IP subscription cap removed. This recipe shows how to turn that stream into common trading and analytics building blocks. For the raw subscription shape see the **`l2Book` reference**; for the connection model see the **WebSocket API overview**.

## What you get

- **Complete snapshots, not diffs.** Every `l2Book` message contains the current `time`, `coin`, and a full `[bids, asks]` tuple in best-first order, with `px` / `sz` / `n` per level. Consume each message in isolation - no sequence numbers to track, no diff replay buffer, no REST snapshot to bootstrap.
- **Self-healing on packet loss.** Drop a message, reconnect mid-session, or restart your process - the next message arrives with the full book state, so your in-memory view is correct on the very next tick.
- **Upstream-compatible aggregation knobs.** `nSigFigs` accepts `2`, `3`, `4`, `5`, or `null` (full precision). `mantissa` accepts `1`, `2`, or `5`, and is only valid when `nSigFigs` is `5`.
- **Wildcard coverage.** Omit `coin` to stream every asset's book over a single subscription, instead of fanning out one subscription per asset. The wildcard defaults to perps only (`marketTypes: ["perp"]`); pass `["spot"]`, `["outcome"]`, a mix, or `["*"]` to opt into spot, outcome, and future market types.

## Subscribe and hold book state

The pattern below keeps a `Map` in memory. Each incoming message replaces the entry for its `coin`, so the map is always current and never needs reconciliation.

```typescript TypeScript
import WebSocket from "ws";

type Level = { px: string; sz: string; n: number };
type Snapshot = { time: number; bids: Level[]; asks: Level[] };

const books = new Map();

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  // Omit `coin` to stream every asset on one subscription.
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l2Book") return;

  const { coin, time, levels: [bids, asks] } = msg.data;
  books.set(coin, { time, bids, asks });

  console.log(coin, time, "bid:", bids[0]?.px, "ask:", asks[0]?.px);
});
```

```python Python
import asyncio, json, os
import websockets

books: dict[str, dict] = {}

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2Book", "coin": "BTC"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l2Book":
                continue
            data = msg["data"]
            coin, time = data["coin"], data["time"]
            bids, asks = data["levels"]
            books[coin] = {"time": time, "bids": bids, "asks": asks}
            print(coin, time, "bid:", bids[0]["px"], "ask:", asks[0]["px"])

asyncio.run(main())
```

## Patterns

### Top-of-book tracker

Read `bids[0]` and `asks[0]` directly from each message. The spread is `Number(asks[0].px) - Number(bids[0].px)`. No state required - every message is self-contained, so a single-line transformation gives you a live ticker.

### Depth-weighted mid quote

Sum `px * sz` across the first `K` levels on each side, then average. This produces a fair-value mid that's robust to thin top-of-book liquidity, and is useful as a hedging or pricing reference.

```typescript TypeScript
function depthWeightedMid(snap: Snapshot, k = 5): number {
  const side = (levels: Level[]) => {
    let num = 0, den = 0;
    for (const { px, sz } of levels.slice(0, k)) {
      const p = Number(px), s = Number(sz);
      num += p * s;
      den += s;
    }
    return den > 0 ? num / den : NaN;
  };
  return (side(snap.bids) + side(snap.asks)) / 2;
}
```

### Slippage / impact estimator

Walk levels on the relevant side until cumulative `sz` covers the requested notional. Return the size-weighted average fill price - the difference vs the top-of-book is your expected slippage.

```typescript TypeScript
function estimateFill(levels: Level[], targetSize: number): number {
  let remaining = targetSize, notional = 0;
  for (const { px, sz } of levels) {
    const take = Math.min(remaining, Number(sz));
    notional += take * Number(px);
    remaining -= take;
    if (remaining  0 ? NaN : notional / targetSize;
}

// Buying 10 BTC against current asks:
const avgFill = estimateFill(books.get("BTC")!.asks, 10);
```

### Liquidity heatmap

On each message, append `[time, coin, side, px, sz]` rows to your time-series store (Clickhouse, TimescaleDB, Parquet). Because every message is a complete snapshot of the top levels, the heatmap rebuilds correctly from any contiguous slice of history - you don't need a separate "initial book" record to seed the visualisation.

## Handling reconnects

Reconnect logic is a one-liner: open a new socket and resend the same `subscribe` payload. The first message after subscribe is a full book snapshot, so your `books` map is correct on the next tick - there's nothing to replay, nothing to buffer, and no sequence numbers to reconcile against a separately-fetched REST snapshot.

```typescript TypeScript
function connect() {
  const ws = new WebSocket(
    `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
  );
  ws.on("open", () => ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2Book", coin: "BTC" },
  })));
  ws.on("close", () => setTimeout(connect, 1000));
  return ws;
}
```

## Related

- **`l2Book` API reference** - full subscription and message schema.
- **WebSocket API overview** - endpoint URL, auth, and limits.
- **`clearinghouseState`** - pair the live book with per-account position and margin state.
- **HIP-3 markets OHLCV recipe** - candles instead of raw book state.

---

The `l2BookDiff` channel on `wss://hypercore.goldrushdata.com/ws?key=` is a GoldRush-exclusive stream - it has no equivalent on `wss://api.hyperliquid.xyz/ws`. After subscribing, the server emits one `Snapshot` per subscribed coin, then per-block `Updates` carrying only the price levels that changed. The shape per level is the same `{px, sz, n}` you already get from `l2Book`, so book-state code only needs to learn how to apply diffs - and `coin` accepts a single asset, a list, or can be omitted to stream every asset on one subscription. For the raw subscription shape see the **`l2BookDiff` reference**; for the connection model see the **WebSocket API overview**.

## What you get

- **Snapshot + diff transport.** One full `Snapshot` per subscribed coin on subscribe, then per-block `Updates` containing only the levels that changed. Apply diffs to local state.
- **Aggregated `{px, sz, n}` shape.** Identical to `l2Book` levels - reuse your existing aggregated-book types and just add a level-apply function.
- **Multi-coin / wildcard friendly.** `coin` accepts a single asset, an array of assets, or can be omitted to stream every asset on one subscription. When `coin` is omitted, `marketTypes` defaults to `["perp"]` - pass `["spot"]`, `["outcome"]`, a mix, or `["*"]` to opt into spot, outcome, and future market types. `l4Book` is one-coin-per-subscription; `l2Book` requires per-asset fan-out on the public feed.
- **Bandwidth proportional to change.** Quiet markets cost almost nothing; only the levels that actually moved arrive over the wire, instead of a full re-snapshot every tick.
- **GoldRush-exclusive.** Public Hyperliquid has no L2-diff transport - `l2Book` is full-snapshot only.

## Subscribe and maintain book state

The pattern below keeps a `Map, asks: Map }>`. Each `Snapshot` seeds the per-coin entry; each `book_diff` inside `Updates` either deletes a level (when `sz === "0"`) or replaces it with the new `{sz, n}`.

```typescript TypeScript
import WebSocket from "ws";

type Level = { px: string; sz: string; n: number };
type Side = Map;
type Book = { bids: Side; asks: Side };

const books = new Map();

function applyLevels(side: Side, levels: Level[]) {
  for (const lvl of levels) {
    if (lvl.sz === "0") side.delete(lvl.px);
    else side.set(lvl.px, lvl);
  }
}

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2BookDiff", coin: "HYPE" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l2BookDiff") return;

  if (msg.data.Snapshot) {
    const { coin, levels: [bids, asks] } = msg.data.Snapshot;
    const book: Book = { bids: new Map(), asks: new Map() };
    for (const l of bids) book.bids.set(l.px, l);
    for (const l of asks) book.asks.set(l.px, l);
    books.set(coin, book);
    return;
  }

  if (msg.data.Updates) {
    for (const diff of msg.data.Updates.book_diffs) {
      const book = books.get(diff.coin);
      if (!book) continue;
      const [bidLevels, askLevels] = diff.levels;
      applyLevels(book.bids, bidLevels);
      applyLevels(book.asks, askLevels);
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

books: dict[str, dict] = {}

def apply_levels(side: dict, levels: list[dict]) -> None:
    for lvl in levels:
        if lvl["sz"] == "0":
            side.pop(lvl["px"], None)
        else:
            side[lvl["px"]] = lvl

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l2BookDiff", "coin": "HYPE"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l2BookDiff":
                continue
            data = msg["data"]

            if "Snapshot" in data:
                snap = data["Snapshot"]
                bids, asks = snap["levels"]
                books[snap["coin"]] = {
                    "bids": {l["px"]: l for l in bids},
                    "asks": {l["px"]: l for l in asks},
                }
                continue

            if "Updates" in data:
                for diff in data["Updates"]["book_diffs"]:
                    book = books.get(diff["coin"])
                    if not book:
                        continue
                    bid_levels, ask_levels = diff["levels"]
                    apply_levels(book["bids"], bid_levels)
                    apply_levels(book["asks"], ask_levels)

asyncio.run(main())
```

## Patterns

### Single coin, list, or wildcard

All three subscription shapes share the same handler - only the payload sent at `subscribe` time changes. Use whichever matches your coverage requirements.

```typescript TypeScript
// Single coin
ws.send(JSON.stringify({
  method: "subscribe",
  subscription: { type: "l2BookDiff", coin: "HYPE" },
}));

// Fixed list of coins
ws.send(JSON.stringify({
  method: "subscribe",
  subscription: { type: "l2BookDiff", coin: ["HYPE", "BTC", "ETH"] },
}));

// Every perp asset on one subscription (perps is the default when coin is omitted)
ws.send(JSON.stringify({
  method: "subscribe",
  subscription: { type: "l2BookDiff" },
}));

// Spot only, or any mix; pass ["*"] for perps + spot + outcomes plus auto-opt-in to future types
ws.send(JSON.stringify({
  method: "subscribe",
  subscription: { type: "l2BookDiff", marketTypes: ["spot"] },
}));
ws.send(JSON.stringify({
  method: "subscribe",
  subscription: { type: "l2BookDiff", marketTypes: ["*"] },
}));
```

A list or wildcard subscription receives one `Snapshot` per live coin before diffs begin, so the `books` map fills in over the first few messages rather than all at once. `marketTypes` is only valid when `coin` is omitted; it defaults to `["perp"]`, so spot and outcome markets require explicit opt-in. A second `subscribe` with a different `marketTypes` value replaces the previous filter rather than coexisting with it.

### Reconstruct a top-of-book stream

After each diff is applied, the best bid is the highest `px` in `book.bids` and the best ask is the lowest `px` in `book.asks`. Emit only when the top level changes to avoid noise.

```typescript TypeScript
function bestLevels(book: Book) {
  let bestBid: string | null = null;
  for (const px of book.bids.keys()) if (!bestBid || Number(px) > Number(bestBid)) bestBid = px;
  let bestAsk: string | null = null;
  for (const px of book.asks.keys()) if (!bestAsk || Number(px)  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l2BookDiff", coin: "HYPE" },
  })));
  ws.on("close", () => {
    books.clear();
    setTimeout(connect, 1000);
  });
  return ws;
}
```

## Related

- **`l2BookDiff` API reference** - full subscription, snapshot, and update schema.
- **`l2Book` reference** - full-snapshot transport when diff replay isn't desirable.
- **`l4Book` reference** - order-level stream with `user`, `oid`, `cloid`, `tif`, and trigger metadata.
- **WebSocket API overview** - endpoint URL, auth, and limits.

---

The `l4Book` channel on `wss://hypercore.goldrushdata.com/ws?key=` is a GoldRush-exclusive stream - it has no equivalent on `wss://api.hyperliquid.xyz/ws`. After subscribing, the server sends a single `Snapshot` of every resting order, then per-block `Updates` carrying lifecycle events and per-order book changes. Each order arrives with its `user`, `oid`, `cloid`, `tif`, and trigger metadata, so you can reconstruct queue position and price-time priority, attribute flow to specific wallets, and run microstructure analytics that `l2Book`'s aggregated `{px, sz, n}` view hides. For the raw subscription shape see the **`l4Book` reference**; for the connection model see the **WebSocket API overview**.

## What you get

- **Per-order visibility.** Every level in the snapshot is an individual order keyed by `oid`, with `user`, `cloid`, `tif`, `orderType`, and trigger metadata attached. `l2Book` only exposes `{px, sz, n}` per price level.
- **Snapshot + diff transport.** One full `Snapshot` on subscribe, then per-block `Updates` containing `order_statuses` (lifecycle events) and `book_diffs` (per-order changes). Apply diffs to local state.
- **Per-block cadence.** Updates fire on each HyperCore block where the book for the subscribed `coin` changed. The `time` and `block_height` fields anchor each message to a specific block.
- **GoldRush-exclusive.** Not available on the public Hyperliquid WebSocket - this stream surfaces user attribution and per-order metadata the public feed never exposes.
- **One coin per subscription.** Unlike `l2Book`, `coin` is required. To cover multiple assets, open one `l4Book` subscription per asset on the same connection.

## Subscribe and maintain book state

The pattern below keeps a `Map` per coin. The snapshot seeds the map; each `Updates` message applies `book_diffs` against it. Reconnects drop the map and re-seed from the next snapshot.

```typescript TypeScript
import WebSocket from "ws";

type Order = {
  user: string | null;
  coin: string;
  side: "B" | "A";
  limitPx: string;
  sz: string;
  oid: number;
  timestamp: number;
  triggerCondition: string;
  isTrigger: boolean;
  triggerPx: string;
  isPositionTpsl: boolean;
  reduceOnly: boolean;
  orderType: string;
  tif: string;
  cloid: string | null;
};

const orders = new Map();

const ws = new WebSocket(
  `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
);

ws.on("open", () => {
  ws.send(JSON.stringify({
    method: "subscribe",
    subscription: { type: "l4Book", coin: "BTC" },
  }));
});

ws.on("message", (raw) => {
  const msg = JSON.parse(raw.toString());
  if (msg.channel !== "l4Book") return;

  if (msg.data.Snapshot) {
    orders.clear();
    const [bids, asks] = msg.data.Snapshot.levels;
    for (const o of [...bids, ...asks]) orders.set(o.oid, o);
    console.log("seeded from snapshot:", orders.size, "orders");
    return;
  }

  if (msg.data.Updates) {
    const { order_statuses, book_diffs } = msg.data.Updates;

    for (const s of order_statuses) {
      // Re-attach the parent `user` since the nested order has user=null.
      orders.set(s.order.oid, { ...s.order, user: s.user });
    }

    for (const d of book_diffs) {
      const existing = orders.get(d.oid);
      if (!existing) continue;
      if (d.raw_book_diff.new) {
        orders.set(d.oid, { ...existing, sz: d.raw_book_diff.new.sz });
      }
      // Other raw_book_diff shapes (deletes, modifies) belong here.
    }
  }
});
```

```python Python
import asyncio, json, os
import websockets

orders: dict[int, dict] = {}

async def main():
    uri = f"wss://hypercore.goldrushdata.com/ws?key={os.environ['GOLDRUSH_API_KEY']}"
    async with websockets.connect(uri) as ws:
        await ws.send(json.dumps({
            "method": "subscribe",
            "subscription": {"type": "l4Book", "coin": "BTC"},
        }))
        async for raw in ws:
            msg = json.loads(raw)
            if msg.get("channel") != "l4Book":
                continue
            data = msg["data"]

            if "Snapshot" in data:
                orders.clear()
                bids, asks = data["Snapshot"]["levels"]
                for o in bids + asks:
                    orders[o["oid"]] = o
                print("seeded from snapshot:", len(orders), "orders")
                continue

            if "Updates" in data:
                for s in data["Updates"]["order_statuses"]:
                    o = {**s["order"], "user": s["user"]}
                    orders[o["oid"]] = o
                for d in data["Updates"]["book_diffs"]:
                    existing = orders.get(d["oid"])
                    if not existing:
                        continue
                    new = d["raw_book_diff"].get("new")
                    if new:
                        existing["sz"] = new["sz"]

asyncio.run(main())
```

## Patterns

### Track individual orders by `oid`

`oid` is the Hyperliquid order id, stable for the lifetime of the order - use it as the primary key in your local map. `cloid` is the client-supplied id (may be `null`); index on it when you need to correlate fills back to a specific trading bot's instructions.

### Per-user flow attribution

Every order entry carries `user`. Group orders by wallet to surface market-maker behavior, identify spoofing patterns, or build a per-trader heatmap of resting size. Pair this with `clearinghouseState` for per-user position and margin context.

```typescript TypeScript
function sizeByUser(orders: Map) {
  const totals = new Map();
  for (const o of orders.values()) {
    if (!o.user) continue;
    totals.set(o.user, (totals.get(o.user) ?? 0) + Number(o.sz));
  }
  return totals;
}
```

### Reconstruct aggregated price levels

If a downstream consumer expects an `l2Book`-style aggregated view, sum `sz` across all orders sharing a `limitPx` on the same `side`. Going the other way isn't possible - `l2Book` collapses the per-order detail you'd lose.

```typescript TypeScript
function aggregate(orders: Map) {
  const bids = new Map();
  const asks = new Map();
  for (const o of orders.values()) {
    const book = o.side === "B" ? bids : asks;
    book.set(o.limitPx, (book.get(o.limitPx) ?? 0) + Number(o.sz));
  }
  return { bids, asks };
}
```

## Handling reconnects

On reconnect, resend the same `subscribe` payload. The first message back is always a fresh `Snapshot` - drop your local `orders` map and re-seed from it. **Do not attempt to replay missed `Updates`** - the snapshot is authoritative and supersedes anything you held before the disconnect.

Back off exponentially between attempts. A reconnect opens a new session, and a new session is a new subscription that re-pays the [one-minute minimum](#billing), so a fixed one-second retry against a flapping connection bills a minute of `l4Book` every second.

```typescript TypeScript
let backoff = 1_000;

function connect() {
  const ws = new WebSocket(
    `wss://hypercore.goldrushdata.com/ws?key=${process.env.GOLDRUSH_API_KEY}`,
  );
  ws.on("open", () => {
    backoff = 1_000;
    ws.send(JSON.stringify({
      method: "subscribe",
      subscription: { type: "l4Book", coin: "BTC" },
    }));
  });
  ws.on("close", () => {
    orders.clear();
    setTimeout(connect, backoff);
    backoff = Math.min(30_000, backoff * 2);
  });
  return ws;
}
```

## Billing

`l4Book` bills **per coin, per minute, in whole minutes**. There is no proration and no partial minute.

| Subscription | Credits per minute |
|---|---|
| `"coin": "BTC"` | 60 |
| Any other coin | 3 |

> **Warning:** **The minimum charge is one full minute.** Sending `subscribe` charges the first minute immediately, before the `Snapshot` is delivered. Subscribing, reading the snapshot, and disconnecting 400 ms later still costs a full minute per coin.

After the first minute, the total is `ceil(seconds_subscribed / 60)` counted from the moment you subscribed. 60 seconds bills 1 minute; 61 seconds bills 2.

Because `coin` is required, every coin you track is its own billable subscription. A snapshot-only sweep across 168 coins costs `60 + (167 x 3) = 561` credits whether the connection lives 400 milliseconds or a full 60 seconds. Repeating that sweep ten times costs ten times as much.

For the rest of the model - what counts as one subscription, why reconnects are not free, and the `unsubscribe` shape-matching rule - see **Billing** on the rate limits page. The same rules apply to every order-book channel, and the whole-minute rounding applies to the wallet-activity channels too.

## Related

- **`l4Book` API reference** - full subscription, snapshot, and update schema.
- **`l2Book` reference** - aggregated price-level snapshots when per-order detail isn't needed.
- **WebSocket API overview** - endpoint URL, auth, and limits.
- **Billing** - the whole-minute model shared by every WebSocket channel.
- **`clearinghouseState`** - pair per-user resting orders with position and margin state.