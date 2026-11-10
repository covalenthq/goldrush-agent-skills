# GoldRush API for Solana - Overview

## Quick Reference

| Item | Value |
|------|-------|
| **Foundational base URL** | `https://api.covalenthq.com/v1/solana-mainnet/...` |
| **Authentication** | `Authorization: Bearer <GOLDRUSH_API_KEY>` (same key for all surfaces) |
| **REST chain name** | `solana-mainnet` (kebab-case) |
| **Wallet address format** | base58, 32-44 chars, case-preserved |
| **Transaction id** | `signature` (base58, ~88 chars) |
| **Block identifier** | `slot` (primary) / `block_height` (secondary, ~5% gaps) / `block_time` (unix seconds) |
| **Native unit** | lamports (1 SOL = 10^9 lamports) |
| **Default commitment** | `confirmed` (~1s). `finalized` (~13s) via `?commitment=finalized` |

## Surfaces

| Surface | What it provides |
|---------|------------------|
| Foundational API | REST endpoints for SPL balances (Token + Token-2022), historical balances by slot, SPL transfers, transactions by signature, NFTs (Metaplex + Bubblegum cNFTs), pricing, and Solana-native primitives. |

---

GoldRush's coverage on Solana today spans these primitives:

- **SPL token balances** for any wallet - Foundational REST.


### Foundational API

REST endpoint for SPL token balances on `solana-mainnet`. Base58 addresses.

### GoldRush vs Solana RPC

What GoldRush adds on top of plain Solana RPC.

## What's included

## Quickstart

### Look up a Solana wallet

SPL token balances and native SOL for any base58 address.

---

## Prerequisites

A GoldRush API key. Sign up at [goldrush.dev/platform](https://goldrush.dev/platform/auth/register/).

### Vibe Coders

$10/mo - Built for solo builders and AI-native workflows.

### Teams

$250/mo - Production-grade with priority support.

---

## Look up SPL token balances

Get SPL token balances and native SOL for any base58 wallet address.

```bash cURL
curl -X GET "https://api.covalenthq.com/v1/solana-mainnet/address/4ZJhPQAgUseCsWhKvJLTmmRRUV74fdoTpQLNfKoekbPY/balances_v2/" \
  -H "Authorization: Bearer $GOLDRUSH_API_KEY"
```

```typescript TypeScript
import { GoldRushClient } from "@covalenthq/client-sdk";

const client = new GoldRushClient(process.env.GOLDRUSH_API_KEY);

const resp = await client.BalanceService.getTokenBalancesForWalletAddress({
  chainName: "solana-mainnet",
  walletAddress: "4ZJhPQAgUseCsWhKvJLTmmRRUV74fdoTpQLNfKoekbPY",
});

for (const token of resp.data.items) {
  console.log(`${token.contract_ticker_symbol}: ${token.balance} (${token.pretty_quote})`);
}
```

```python Python
import os
import requests

resp = requests.get(
    "https://api.covalenthq.com/v1/solana-mainnet/address/"
    "4ZJhPQAgUseCsWhKvJLTmmRRUV74fdoTpQLNfKoekbPY/balances_v2/",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
)

for item in resp.json()["data"]["items"]:
    print(item["contract_ticker_symbol"], item["balance"], item.get("pretty_quote"))
```

Balances are returned with `contract_address` as the base58 mint pubkey, `contract_decimals` from the Mint account, and USD `quote` where pricing is available.

### Foundational on Solana walkthrough

SPL token balance details and request shape.

---

## What's next


### Foundational endpoints

SPL token balances on `solana-mainnet`.

### GoldRush vs Solana RPC

What GoldRush adds on top of plain Solana RPC.

---

# Roadmap