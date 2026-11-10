# GoldRush Foundational API on Solana

## Critical Rules

1. Base URL: `https://api.covalenthq.com/v1/solana-mainnet/...` (kebab-case chain name).
2. Wallet address format: base58, **case-preserved** (unlike EVM 0x-hex which is lowercased).
3. Token mints: base58 mint pubkey - takes the `contract_address` / `tokenMint` slot. USDC = `EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v`, wrapped SOL = `So11111111111111111111111111111111111111112`.
4. Transaction id: base58 `signature` (~88 chars), addressed via `/transaction_v2/{signature}/` - **not** `tx_hash` and **not** `/transaction_v2/{txHash}/`.
5. Slot is primary; `block_height` is secondary and can be null because ~5% of slots are skipped.
6. SPL Token + Token-2022 are aggregated by default in every balance/transfer/holder response. Opt out with `?include-token-2022=false`.
7. cNFTs surface alongside Metaplex NFTs with `compressed: true`. For cNFTs, `contract_address` is the Bubblegum Merkle tree (not a mint), and `token_id` is the Merkle leaf index.
8. ALT references in versioned transactions (`v0`) are pre-resolved at index time - clients always see the full `account_keys`.
9. `processed` commitment is not exposed via Foundational (too unstable for REST semantics). Default is `confirmed`; use `?commitment=finalized` for rollback-impossible reads.

---

The GoldRush Foundational API on Solana is the same REST surface that serves other chains, adapted for Solana addressing. Wallets and mints are base58.

## Endpoint

```
GET https://api.covalenthq.com/v1/solana-mainnet/...
Authorization: Bearer
```

`solana-mainnet` slots into the same `{chainName}` path parameter as `eth-mainnet`, `base-mainnet`, or other supported chains.

## Solana addressing conventions

| Topic | Convention |
|---|---|
| **Wallet address** | Base58, 32-44 chars, **case-preserved** (unlike EVM 0x-hex which is lowercased). Example: `4ZJhPQAgUseCsWhKvJLTmmRRUV74fdoTpQLNfKoekbPY`. |
| **Token mint** | Base58 mint pubkey - takes the same path slot as `contract_address` on EVM. SOL is represented as `So11111111111111111111111111111111111111112` (wrapped SOL mint), USDC as `EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v`. |
| **Native unit** | Lamports - 1 SOL = 10⁹ lamports. |

## Supported endpoint

| Endpoint | What it returns |
|---|---|
| **Get token balances for address** | SPL token balances plus native SOL with USD quote where pricing exists. |

Walkthrough: **Wallet**.

## Not supported today

The following are **not** part of Foundational REST coverage on Solana today:

- SPL token transfer history
- Solana transactions (signature lookup, paginated history, summary)
- NFTs (Metaplex and Bubblegum compressed)
- Token pricing REST endpoints (historical or pool spot)
- Solana-native primitives (stake, IDL, validators, Token-2022 extensions, SPL delegations)

## Error handling

Follows the standard GoldRush envelope and error taxonomy - see **Error handling**.

---

This page walks through the wallet-centric Foundational endpoint currently supported on `solana-mainnet`: SPL token balances.

## Balances (SPL + native SOL)

Returns SPL token holdings plus native SOL with USD pricing where available.

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

for (const item of resp.data.items) {
  console.log(item.contract_ticker_symbol, item.balance, item.pretty_quote);
}
```

```python Python
import os, requests

resp = requests.get(
    "https://api.covalenthq.com/v1/solana-mainnet/address/"
    "4ZJhPQAgUseCsWhKvJLTmmRRUV74fdoTpQLNfKoekbPY/balances_v2/",
    headers={"Authorization": f"Bearer {os.environ['GOLDRUSH_API_KEY']}"},
)
print(resp.json()["data"]["items"][:3])
```

Each item carries the SPL mint as `contract_address`, decimals from the Mint account, and `quote` in USD where pricing exists. The wrapped-SOL row (`So111…`) is the native balance.

Reference: **`get-token-balances-for-address`**.

## SPL transfer history

SPL transfer history is **not** available on the Foundational REST API for Solana today.

## Related

- **Foundational on Solana overview** - full endpoint coverage and what's not supported today.

---



---



---



---