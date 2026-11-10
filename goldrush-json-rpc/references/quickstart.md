# GoldRush JSON-RPC Quickstart

## Header-based authentication

API keys are sent as an `Authorization: Bearer <key>` header, never in the URL. The same GoldRush API key works across all GoldRush products.

## Per-library setup

See the rendered reference for copy-paste examples. The pattern in each library:

- **ethers v6**: `new ethers.FetchRequest(url)` + `.setHeader("Authorization", ...)`, pass to `new ethers.JsonRpcProvider(req)`
- **viem**: `http(url, { fetchOptions: { headers: { Authorization: ... } } })`
- **web3.js**: `new Web3.providers.HttpProvider(url, { headers: [{ name, value }] })`
- **web3.py**: `Web3.HTTPProvider(url, request_kwargs={"headers": {...}})`
- **curl**: `-H "Authorization: Bearer $GOLDRUSH_API_KEY"`

## Endpoint shape

```
https://rpc.goldrushdata.com/v1/{chain}
```

Replace `{chain}` with one of: `eth-mainnet`, `matic-mainnet`, `bsc-mainnet`, `arbitrum-mainnet`, `base-mainnet`, `hyperevm-mainnet`, `megaeth-mainnet`, `monad-mainnet`, `tempo-mainnet`, `solana-mainnet`.

---

## Prerequisites

Using any of the GoldRush developer tools requires an API key. If you already have a GoldRush key for any other GoldRush product (Foundational, Hyperliquid, x402), you can use it as-is - JSON-RPC uses the same key.

### Vibe Coders

$10/mo - Built for solo builders and AI-native workflows.

### Teams

$250/mo - Production-grade with 50 RPS and priority support.

## 1. Export your API key

```bash
export GOLDRUSH_API_KEY="cqt_..."
```

> **Warning:** Never commit your API key to source control. Use environment variables or a secrets manager.

## 2. Pick a chain

The endpoint shape is:

```
https://rpc.goldrushdata.com/v1/{chain}
```

Replace `{chain}` with one of the **supported chain slugs**. For Ethereum mainnet, that's `eth-mainnet`; for Solana, that's `solana-mainnet`.

## 3. Make a request

The examples below target an EVM chain. For Solana, jump to [step 3 (Solana)](#3-make-a-request-solana).

```bash curl
curl https://rpc.goldrushdata.com/v1/eth-mainnet \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "eth_blockNumber",
    "params": []
  }'
```

```typescript ethers v6
import { ethers } from "ethers";

const url = "https://rpc.goldrushdata.com/v1/eth-mainnet";
const fetchReq = new ethers.FetchRequest(url);
fetchReq.setHeader("Authorization", `Bearer ${process.env.GOLDRUSH_API_KEY}`);

const provider = new ethers.JsonRpcProvider(fetchReq);
const block = await provider.getBlockNumber();
console.log("latest block:", block);
```

```typescript viem
import { createPublicClient, http } from "viem";
import { mainnet } from "viem/chains";

const client = createPublicClient({
  chain: mainnet,
  transport: http("https://rpc.goldrushdata.com/v1/eth-mainnet", {
    fetchOptions: {
      headers: {
        Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}`,
      },
    },
  }),
});

const block = await client.getBlockNumber();
console.log("latest block:", block);
```

```javascript web3.js
import { Web3 } from "web3";

const provider = new Web3.providers.HttpProvider(
  "https://rpc.goldrushdata.com/v1/eth-mainnet",
  {
    headers: [
      { name: "Authorization", value: `Bearer ${process.env.GOLDRUSH_API_KEY}` },
    ],
  }
);
const web3 = new Web3(provider);
const block = await web3.eth.getBlockNumber();
console.log("latest block:", block);
```

```python web3.py
from os import environ
from web3 import Web3

w3 = Web3(Web3.HTTPProvider(
    "https://rpc.goldrushdata.com/v1/eth-mainnet",
    request_kwargs={
        "headers": {
            "Authorization": f"Bearer {environ['GOLDRUSH_API_KEY']}",
        },
    },
))
print("latest block:", w3.eth.block_number)
```

## 3. Make a request (Solana)

On Solana, the same endpoint shape and header auth apply; only the methods change. Here's a `getSlot` call (the Solana equivalent of `eth_blockNumber`):

```bash curl
curl https://rpc.goldrushdata.com/v1/solana-mainnet \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "getSlot",
    "params": [{ "commitment": "finalized" }]
  }'
```

```typescript @solana/kit
import {
  createDefaultRpcTransport,
  createSolanaRpcFromTransport,
} from "@solana/kit";

const transport = createDefaultRpcTransport({
  url: "https://rpc.goldrushdata.com/v1/solana-mainnet",
  headers: { Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}` },
});
const rpc = createSolanaRpcFromTransport(transport);

const slot = await rpc.getSlot().send();
console.log("current slot:", slot);
```

```typescript @solana/web3.js
import { Connection } from "@solana/web3.js";

const connection = new Connection(
  "https://rpc.goldrushdata.com/v1/solana-mainnet",
  {
    httpHeaders: {
      Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}`,
    },
  }
);

const slot = await connection.getSlot("finalized");
console.log("current slot:", slot);
```

```python python
import os
import requests

resp = requests.post(
    "https://rpc.goldrushdata.com/v1/solana-mainnet",
    headers={
        "Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}",
        "Content-Type": "application/json",
    },
    json={"jsonrpc": "2.0", "id": 1, "method": "getSlot", "params": [{"commitment": "finalized"}]},
)
print("current slot:", resp.json()["result"])
```

New to Solana RPC? See **Solana concepts** for commitment levels, slots vs blocks, lamports, and encodings.

## 4. Where to next

### Authentication details

Header reference, error codes, key rotation tips.

### Method reference

Every method with parameters, returns, and code examples per chain. See the **Solana method reference** for Solana.

### Endpoint details

Archive, `debug_*`, `trace_*`, SLA.

### Migration guides

Coming from Infura, Alchemy, or Ankr.

---

GoldRush JSON-RPC authenticates every request by an `Authorization: Bearer ` HTTP header. Your API key never appears in the URL, keeping it out of server logs, browser history, screenshots, and error reports. This matches the pattern used across the rest of the GoldRush product family.

The same GoldRush API key works across every GoldRush product: Foundational, Hyperliquid, x402, and JSON-RPC. One key, every product.

## The header

```http
Authorization: Bearer 
Content-Type: application/json
```

`Content-Type: application/json` is required: JSON-RPC payloads are always JSON.

## Per-library setup

`viem`, `ethers`, `web3.js`, and `web3.py` all support custom request headers, but the boilerplate differs slightly between them. Copy whichever one applies.

```typescript ethers v6
import { ethers } from "ethers";

const url = "https://rpc.goldrushdata.com/v1/eth-mainnet";
const fetchReq = new ethers.FetchRequest(url);
fetchReq.setHeader("Authorization", `Bearer ${process.env.GOLDRUSH_API_KEY}`);

const provider = new ethers.JsonRpcProvider(fetchReq);
```

```typescript viem
import { createPublicClient, http } from "viem";
import { mainnet } from "viem/chains";

const client = createPublicClient({
  chain: mainnet,
  transport: http("https://rpc.goldrushdata.com/v1/eth-mainnet", {
    fetchOptions: {
      headers: {
        Authorization: `Bearer ${process.env.GOLDRUSH_API_KEY}`,
      },
    },
  }),
});
```

```javascript web3.js
import { Web3 } from "web3";

const provider = new Web3.providers.HttpProvider(
  "https://rpc.goldrushdata.com/v1/eth-mainnet",
  {
    headers: [
      { name: "Authorization", value: `Bearer ${process.env.GOLDRUSH_API_KEY}` },
    ],
  }
);
const web3 = new Web3(provider);
```

```python web3.py
from os import environ
from web3 import Web3

w3 = Web3(Web3.HTTPProvider(
    "https://rpc.goldrushdata.com/v1/eth-mainnet",
    request_kwargs={
        "headers": {
            "Authorization": f"Bearer {environ['GOLDRUSH_API_KEY']}",
        },
    },
))
```

```bash curl
curl https://rpc.goldrushdata.com/v1/eth-mainnet \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}'
```

## Error responses

Authentication and credit failures return the standard JSON-RPC error envelope with an HTTP status code matching the failure mode.

| HTTP | JSON-RPC code | Meaning | Resolution |
|------|---------------|---------|-----------|
| `401 Unauthorized` | `-32001` | Missing or malformed `Authorization` header | Add the `Authorization: Bearer ` header |
| `403 Forbidden` | `-32002` | Key is valid but lacks JSON-RPC entitlement | Contact support to enable JSON-RPC |
| `402 Payment Required` | `-32003` | Insufficient credits | Top up your credit balance |
| `429 Too Many Requests` | `-32005` | Rate limit exceeded | Back off and retry after `Retry-After` |

Example failure body:

```json
{
  "jsonrpc": "2.0",
  "id": 1,
  "error": {
    "code": -32001,
    "message": "missing or invalid Authorization header"
  }
}
```

## Rotating keys

Generate a new key in the [GoldRush dashboard](https://goldrush.dev), update your environment variable, and revoke the old one. There is no per-product key rotation: rotating once cycles the key for every GoldRush product.

> **Tip:** For zero-downtime rotation, set both the old and new key as accepted in your config, deploy with the new key, then revoke the old key once traffic has cut over.

## Related

### Quickstart

Make your first call.

### Pricing

Per-method credit rates for the Edge tier.